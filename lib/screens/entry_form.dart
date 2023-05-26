import 'package:flutter/material.dart';

class EntryForm extends StatefulWidget {
  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formValues = {
    'Checkbox 1': false,
    'Checkbox 2': false,
    'Checkbox 3': false,
    'Checkbox 4': false,
    'Checkbox 5': false,
    'Checkbox 6': false,
    'Checkbox 7': false,
    'Checkbox 8': false,
    'Checkbox 9': false,
    'RadioValue 1': 1,
    'RadioValue 2': 1,
    'RadioValue 3': 1,
    'RadioValue 4': 1,
    'RadioValue 5': 1,
  };

  @override
  Widget build(BuildContext) {
    return Form(
        key: _formKey,
        child: Column(children: [
          Text("Flu-like Symptoms / Mala-trangkasong sintomas"),
          CheckboxListTile(
            title: Text("None/Wala"),
            value: formValues['Checkbox 1'],
            onChanged: (bool? value) {
              setState(() {
                formValues['Checkbox 1'] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Feeling Feverish / Pakiramdam na lalagnatin"),
            value: formValues['Checkbox 2'],
            onChanged: (bool? value) {
              setState(() {
                formValues['Checkbox 2'] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
                "Muscle or Joint Pains / Sakit ng buto-buto o kasu-kasuan"),
            value: formValues['Checkbox 3'],
            onChanged: (bool? value) {
              setState(() {
                formValues['Checkbox 3'] = value!;
              });
            },
          ),
          const Text("Respiratory Symptoms"),
          CheckboxListTile(
            title: Text("None or Wala"),
            value: formValues['Checkbox 4'],
            onChanged: (bool? value) {
              setState(() {
                formValues['Checkbox 4'] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Cough / Ubo"),
            value: formValues['Checkbox 5'],
            onChanged: (bool? value) {
              setState(() {
                formValues['Checkbox 5'] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Colds / Sipon"),
            value: formValues['Checkbox 6'],
            onChanged: (bool? value) {
              setState(() {
                formValues['Checkbox 6'] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Sore Throat / Sakit ng lalamunan"),
            value: formValues['Checkbox 7'],
            onChanged: (bool? value) {
              setState(() {
                formValues['Checkbox 7'] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Difficulty of Breathing / Hirap sa Paghinga"),
            value: formValues['Checkbox 8'],
            onChanged: (bool? value) {
              setState(() {
                formValues['Checkbox 8'] = value!;
              });
            },
          ),
        ]));
  }
}
