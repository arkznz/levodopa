import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lookup/drugs.dart';
import 'package:flutter/cupertino.dart';

class EditDrug extends StatefulWidget {
  EditDrug({Key? key, required this.unusedDrugs, required this.updateDrugCallback, this.drugToEdit, this.drugIndexToEdit, this.doseToEdit}) : super(key: key);

  String? drugToEdit;
  int? drugIndexToEdit;
  String? doseToEdit;
  final List<String> unusedDrugs;
  final Function(String, double, String?, int?) updateDrugCallback;

  @override
  State<EditDrug> createState() => _EditDrugState();
}

class _EditDrugState extends State<EditDrug> {

  String _drugToEdit = "";
  String _doseToEdit = "0.0";
  int _led = 0;
  int _drugIndexToEdit = 0;
  TextEditingController doseTextController = TextEditingController();
  String _bottomSheetTitle = "Add Details";
  List<String> _availableDrugs = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    doseTextController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _drugToEdit = widget.drugToEdit?? widget.unusedDrugs[_drugIndexToEdit];
    _doseToEdit = widget.doseToEdit?? "0.0";
    _led = (drugMap[_drugToEdit]!["factor"] * double.parse(_doseToEdit)).round();
    doseTextController = TextEditingController(text: _doseToEdit);
    _availableDrugs = [...widget.unusedDrugs];
    if (widget.drugToEdit != null) {
      _bottomSheetTitle = "Edit Details";
      _availableDrugs.add(widget.drugToEdit!);
    }
    _availableDrugs = _sortDrugs(_availableDrugs);
    _drugIndexToEdit = _availableDrugs.indexOf(_drugToEdit);
  }

  List<String> _sortDrugs(List<String> drugs) {
    drugs.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return drugs;
  }

  @override
  Widget build(BuildContext context) {
    double convFactor = drugMap[_drugToEdit]!["factor"].toDouble();
    return Container(
      height: MediaQuery.of(context).size.height * 0.87,
      padding: new EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_bottomSheetTitle + "\n", style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.w600)),
              ]
          ),
          GestureDetector(
            onTap: () {
              showPicker(context, _availableDrugs);
            },
            child: new DropdownButtonFormField(
              iconSize: 0,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Drug',
              ),
              items: [
                DropdownMenuItem<String>(child: Text("${_drugToEdit}",style: TextStyle(color: Colors.black)))
              ]
            )
          ),
          TextFormField(
            controller: doseTextController,
            onChanged: (text) {
              setState(() {
                _doseToEdit = "0.0";
                if (text != "") {
                  _doseToEdit = text;
                }
                _led = (convFactor*double.parse(_doseToEdit)).round();
              });
            },
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
            ],
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false
            ),
            decoration: InputDecoration(
              suffix: Text(' mg'),
              labelText: 'Dose',
              contentPadding: EdgeInsets.all(12.0)
            )
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: '\nConversion Factor: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '${convFactor}'),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: '\nLED: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '${_led}'),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: '\nNotes: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '${drugMap[_drugToEdit]!["notes"]}\n'),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    minimumSize: const Size.fromHeight(50)// NEW
                ),
                onPressed: () {
                  // Return the drug
                  widget.updateDrugCallback(_drugToEdit, double.parse(doseTextController.text), widget.drugToEdit, widget.drugIndexToEdit);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 20),
                ),
              )
          ),
        ],
      ),
    );
  }

  void showPicker(BuildContext context, List availableDrugs)
  {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          List<Widget> unusedDrugsWidgets = availableDrugs.map(
                (drug) => Container(
                child: Text(
                  drug,
                )
            ),
          ).toList();
          return Container(
              height: MediaQuery.of(context).copyWith().size.height*0.35,
              color: Colors.white,
              child: CupertinoPicker(
                children: unusedDrugsWidgets,
                onSelectedItemChanged: (drugIndex) {
                  setState(() {
                    _drugToEdit = availableDrugs[drugIndex];
                    _drugIndexToEdit = drugIndex;
                    _doseToEdit = "0.0";
                    if (doseTextController.text != "") {
                      _doseToEdit = doseTextController.text;
                    }
                    _led = (drugMap[_drugToEdit]!["factor"]*double.parse(_doseToEdit)).round();
                  });
                },
                scrollController: FixedExtentScrollController(initialItem: _drugIndexToEdit),
                itemExtent: 30,
                diameterRatio:1,
                useMagnifier: true,
                magnification: 1.5,
                looping: false,
              )
          );
        }
    );
  }
}