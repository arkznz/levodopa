List<String> allDrugs = [
  "Amantadine",
  "Apomorphine",
  "Azilect",
  "Bromocriptine",
  "Cabergoline",
  "Duodopa",
  "Levodopa",
  "LevodopaCR",
  "Levodopa with Entacapone",
  "Levodopa with Tolcapone",
  "Lisuride",
  "Madopar",
  "Mirapex",
  "Perglide",
  "Pramipexole",
  "Rasagiline",
  "Requip",
  "RequipXL",
  "Ropinirole",
  "RopiniroleCR",
  "Rotigotine",
  "Rytary",
  "SelegilineOral",
  "SelegilineSublingual",
  "Sinemet",
  "SinemetCR",
  "Stalevo",
];

String disclaimer = "This drug contains multiple components. Input the levodopa dose only.";

Map<String, Map<String, dynamic>> drugMap = {
  "Amantadine": {
    "factor": 1,
    "notes": ""
  },
  "Apomorphine": {
    "factor": 10,
    "notes": ""
  },
  "Azilect": {
    "factor": 100,
    "notes": "Brand name of rasagiline."
  },
  "Bromocriptine": {
    "factor": 10,
    "notes": ""
  },
  "Cabergoline": {
    "factor": 80,
    "notes": ""
  },
  "Duodopa": {
    "factor": 1.11,
    "notes": "${disclaimer}"
  },
  "Levodopa": {
    "factor": 1,
    "notes": "${disclaimer}"
  },
  "LevodopaCR": {
    "factor": 0.75,
    "notes": "${disclaimer}"
  },
  "Levodopa with Entacapone": {
    "factor": 1.33,
    "notes": "${disclaimer}"
  },
  "Levodopa with Tolcapone": {
    "factor": 1.5,
    "notes": "${disclaimer}"
  },
  "Lisuride": {
    "factor": 100,
    "notes": ""
  },
  "Madopar": {
    "factor": 1,
    "notes": "Brand name of levodopa and benserazide. ${disclaimer}"
  },
  "Mirapex": {
    "factor": 100,
    "notes": "Brand name of pramipexole."
  },
  "Perglide": {
    "factor": 100,
    "notes": ""
  },
  "Pramipexole": {
    "factor": 100,
    "notes": ""
  },
  "Rasagiline": {
    "factor": 100,
    "notes": "Maximum effect found with 1mg."
  },
  "Requip": {
    "factor": 20,
    "notes": "Brand name of ropinirole."
  },
  "RequipXL": {
    "factor": 20,
    "notes": "Brand name of ropinirole CR."
  },
  "Ropinirole": {
    "factor": 20,
    "notes": ""
  },
  "RopiniroleCR": {
    "factor": 20,
    "notes": "See RequipXL."
  },
  "Rotigotine": {
    "factor": 30,
    "notes": ""
  },
  "Rytary": {
    "factor": 0.6,
    "notes": "Conversion from Immediate-Release Carbidopa-Levodopa to Rytary. ${disclaimer}"
  },
  "SelegilineOral": {
    "factor": 10,
    "notes": ""
  },
  "SelegilineSublingual": {
    "factor": 80,
    "notes": ""
},
  "Sinemet": {
    "factor": 1,
    "notes": "Brand name of levopdopa with carbidopa. ${disclaimer}"
  },
  "SinemetCR": {
    "factor": 0.75,
    "notes": "Brand name of controlled release levopdopa with carbidopa. ${disclaimer}"
  },
  "Stalevo": {
    "factor": 1.33,
    "notes": "(1.2,1.33,1.25). ${disclaimer}"
  },
};