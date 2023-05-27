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
    'Checkbox 10': false,
    'Checkbox 11': false,
    'Checkbox 12': false,
    'Checkbox 13': false,
    'Checkbox 14': false,
    'Checkbox 15': false,
    'Checkbox 16': false,
    'Checkbox 17': false,
    'Checkbox 18': false,
    'Checkbox 19': false,
    'Checkbox 20': false,
    'Checkbox 21': false,
    'RadioValue 1': 1,
    'RadioValue 2': 1,
    'RadioValue 3': 1,
    'RadioValue 4': 1,
    'RadioValue 5': 1,
  };
  Widget buildCheckboxListTile(String title, String formKey) {
    return CheckboxListTile(
      title: Text(title),
      value: formValues[formKey],
      onChanged: (bool? value) {
        setState(() {
          formValues[formKey] = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext) {
    return Form(
      key: _formKey,
      child: ListView(children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Card(
                child: Column(children: [
              Text("Flu-like Symptoms / Mala-trangkasong sintomas"),
              buildCheckboxListTile("None/Wala", 'Checkbox 1'),
              buildCheckboxListTile(
                  "Feeling Feverish / Pakiramdam na lalagnatin", 'Checkbox 2'),
              buildCheckboxListTile(
                  "Muscle or Joint Pains / Sakit ng buto-buto o kasu-kasuan",
                  'Checkbox 3'),
            ]))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Card(
                child: Column(children: [
              Text("Respiratory Symptoms"),
              buildCheckboxListTile("None/Wala", 'Checkbox 4'),
              buildCheckboxListTile("Cough / Ubo", 'Checkbox 5'),
              buildCheckboxListTile("Colds / Sipon", 'Checkbox 6'),
              buildCheckboxListTile(
                  "Sore Throat / Sakit ng lalamunan", 'Checkbox 7'),
              buildCheckboxListTile(
                  "Difficulty of Breathing / Hirap sa Paghinga", 'Checkbox 8'),
            ]))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Card(
                child: Column(children: [
              Text("Other Symptoms / Iba pang sintomas"),
              buildCheckboxListTile("None/Wala", 'Checkbox 9'),
              buildCheckboxListTile("Diarrhea / Pagtatae", 'Checkbox 10'),
              buildCheckboxListTile(
                  "Loss of Taste / Kawalan ng Panlasa", 'Checkbox 11'),
              buildCheckboxListTile(
                  "Loss of Smell / Kawalan ng Pangamoy", 'Checkbox 12'),
            ]))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Card(
                child: Column(children: [
              Text("Existing Illnesses"),
              buildCheckboxListTile("None", 'Checkbox 13'),
              buildCheckboxListTile("Hypertension", 'Checkbox 14'),
              buildCheckboxListTile("Diabetes", 'Checkbox 15'),
              buildCheckboxListTile("Tuberculosis", 'Checkbox 16'),
              buildCheckboxListTile("Cancer", 'Checkbox 17'),
              buildCheckboxListTile("Kidney Disease", 'Checkbox 18'),
              buildCheckboxListTile("Cardiac Disease", 'Checkbox 19'),
              buildCheckboxListTile("Autoimmune Disease", 'Checkbox 20'),
              buildCheckboxListTile("Asthma", 'Checkbox 21'),
            ]))),
      ]),
    );
  }
}
