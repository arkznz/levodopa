import 'package:flutter/material.dart';
import 'lookup/drugs.dart';
import 'edit_drug.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEDD Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(title: 'LEDD Calculator'),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  List<Map> _usedDrugs = [];
  List<String> _unusedDrugs = [];

  @override
  void initState() {
    super.initState();
    _usedDrugs = [];
    _unusedDrugs = allDrugs;
  }

  // Callback used by the Edit Drug screen to modify state of the calculator
  void _addOrEditDrug(String newDrugName, double newDose, String? oldDrugName, int? oldDrugIndex) {
    // Drug has changed.
    if (oldDrugName != null && oldDrugName != newDrugName) {
      _removeDrugByIndex(oldDrugIndex!);
      oldDrugName = null;
    }
    if (oldDrugName == null) {
      setState(() {
        _usedDrugs.add({newDrugName: newDose});
        _unusedDrugs.remove(newDrugName);
      });
    }
    else {
      setState(() {
        _usedDrugs[oldDrugIndex!][oldDrugName] = newDose;
      });
    }
  }

  void _removeDrugByIndex(int usedDrugIndex) {
    String drugName = _usedDrugs[usedDrugIndex].keys.toList()[0].toString();
    setState(() {
      _usedDrugs.removeAt(usedDrugIndex);
      _unusedDrugs.add(drugName);
    });
  }

  void _showAbout() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.87,
              padding: new EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text('About\n', style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.w600)),
                    const Text('Levodopa Equivalency Daily Dosage (LEDD) Calculator is a free, open-source app that is intended to help people with Parkinson\'s (PwP).\n'),
                    const Text('The app is based on the web-based calculator built by Parkinson\'s Measurement. The web-based calculator can be found at:\n\nhttps://www.parkinsonsmeasurement.org/toolBox/levodopaEquivalentDose.htm'),
                    const Text('\nSimilar to the web-based calculator, LEDD Calculator gets its conversion factors from the following works:\n'),
                    const Text('''[1] "Levodopa Dose Equivalency: A Systematic Review"\nDr Claire Smith, Birmingham Clinical Trials Unit\n8th June 2010\nSmith et al.\n'''),
                    const Text('''[2] "Cálculo de unidades de equivalencia de levodopa en enfermedad de Parkinson"\nAmin Cervantes-Arriaga, Mayela Rodríguez-Violante, Alejandra Villar-Velarde, Teresa Corona\nArch Neurocien (Mex) Vol. 14, No. 2: 116-119; 2009\n'''),
                    const Text('''[3] GSK prescribing information for RequipXL\n'''),
                    const Text('''[4] Rytary prescribing information\nRevised 1/2015\n''')
                  ],
                ),
              )
          );
        }
    );
  }

  Widget _buildDrugs() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _usedDrugs.length + 1,
      itemBuilder: /*1*/ (context, index) {
        if (index == _usedDrugs.length) {
          return CircleAvatar(
            backgroundColor: Colors.green,
            radius: 20,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                showDetails(context);
              },
            ),
          );
        }
        String drugName = _usedDrugs[index].keys.toList()[0].toString();
        String dosage = _usedDrugs[index][drugName].toString();
        int led = (_usedDrugs[index][drugName] * drugMap[drugName]!["factor"]).round();
        return Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.delete_forever),
          ),
          key: UniqueKey(),
          onDismissed: (DismissDirection direction){
            _removeDrugByIndex(index);
          },
          child: Card(
            child: ListTile(
              title: Text("${drugName}", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)),
              trailing: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '${dosage} mg | '),
                    TextSpan(text: '${led} mg', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              onTap:() {
                showDetails(context, drugName, index, dosage);
              },
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final ledd = _usedDrugs.fold<double>(
        0, (previousValue, element) => previousValue + (element.values.toList()[0] * drugMap[element.keys.toList()[0]]!["factor"]).round());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _showAbout();
              },
              child: Icon(
                Icons.info_outlined,
                size: 26.0,
              ),
            )
          ),
        ]
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Expanded(
              child: _buildDrugs(),
            ),
            ListTile(
              tileColor: Colors.blue.withOpacity(1.0),
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '\nTotal, LEDD: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '${ledd.toInt()} mg\n'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showDetails(BuildContext context, [usedDrugName, usedDrugIndex, usedDrugDose])
  {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          if (usedDrugIndex == null) {
            return EditDrug(unusedDrugs: _unusedDrugs,
                updateDrugCallback: _addOrEditDrug);
          }
          else {
            return EditDrug(unusedDrugs: _unusedDrugs,
                updateDrugCallback: _addOrEditDrug, drugToEdit: usedDrugName, drugIndexToEdit: usedDrugIndex, doseToEdit: usedDrugDose,);
          }
        }
    );
  }
}
