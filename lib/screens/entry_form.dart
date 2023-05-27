import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({super.key});

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
    'RadioValue 1': [1],
    'RadioValue 2': [1],
    'RadioValue 3': [1],
    'RadioValue 4': [1],
  };
  Widget buildCheckboxListTile(String title, String formKey) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        title,
      ),
      value: formValues[formKey],
      onChanged: (bool? value) {
        setState(() {
          formValues[formKey] = value!;
        });
      },
    );
  }

  Widget buildRadioListTile(String title, int value, String formKey) {
    return RadioListTile<int>(
      title: Text(title),
      value: value,
      groupValue: formValues[formKey]!.first,
      onChanged: (int? selectedValue) {
        setState(() {
          formValues[formKey] = [selectedValue!];
        });
      },
    );
  }

  @override
  Widget build(BuildContext) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          const SizedBox(height: 15.0),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create Daily Health Status",
                      style: Theme.of(context).textTheme.headlineSmall!.apply(
                            fontSizeDelta: 4,
                          ),
                    )),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Icon(
                      Symbols.check_box_sharp,
                      size: 20,
                    ),
                    Text(
                      " Please tick all the symptoms that apply",
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon: const Icon(Symbols.device_thermostat_rounded, size: 28.0),
                label: Text("Fever (37.8°C and above)",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          fontSizeDelta: 4,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(children: [
                        buildRadioListTile("Yes", 1, "RadioValue 1"),
                        buildRadioListTile("No", 2, "RadioValue 1"),
                      ])))),
          const Divider(),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon: const Icon(Symbols.sick_rounded, size: 28.0),
                label: Text("Flu-like Symptoms",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          fontSizeDelta: 4,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(children: [
                        buildCheckboxListTile("None/Wala", 'Checkbox 1'),
                        buildCheckboxListTile(
                            "Feeling Feverish / Pakiramdam na lalagnatin",
                            'Checkbox 2'),
                        buildCheckboxListTile(
                            "Muscle or Joint Pains / Sakit ng buto-buto o kasu-kasuan",
                            'Checkbox 3'),
                      ])))),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon: const Icon(Symbols.pulmonology_rounded, size: 28.0),
                label: Text("Respiratory Symptoms",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          fontSizeDelta: 4,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(children: [
                        buildCheckboxListTile("None/Wala", 'Checkbox 4'),
                        buildCheckboxListTile("Cough / Ubo", 'Checkbox 5'),
                        buildCheckboxListTile("Colds / Sipon", 'Checkbox 6'),
                        buildCheckboxListTile(
                            "Sore Throat / Sakit ng lalamunan", 'Checkbox 7'),
                        buildCheckboxListTile(
                            "Difficulty of Breathing / Hirap sa Paghinga",
                            'Checkbox 8'),
                      ])))),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon: const Icon(Symbols.microbiology_rounded, size: 28.0),
                label: Text("Other Symptoms",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          fontSizeDelta: 4,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(children: [
                  buildCheckboxListTile("None/Wala", 'Checkbox 9'),
                  buildCheckboxListTile("Diarrhea / Pagtatae", 'Checkbox 10'),
                  buildCheckboxListTile(
                      "Loss of Taste / Kawalan ng Panlasa", 'Checkbox 11'),
                  buildCheckboxListTile(
                      "Loss of Smell / Kawalan ng Pangamoy", 'Checkbox 12'),
                ]),
              ))),
          const SizedBox(height: 10.0),
          const Divider(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon: const Icon(Symbols.medication_rounded, size: 28.0),
                label: Text("Existing Illnesses",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          fontSizeDelta: 4,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(children: [
                        buildCheckboxListTile("None", 'Checkbox 13'),
                        buildCheckboxListTile("Hypertension", 'Checkbox 14'),
                        buildCheckboxListTile("Diabetes", 'Checkbox 15'),
                        buildCheckboxListTile("Tuberculosis", 'Checkbox 16'),
                        buildCheckboxListTile("Cancer", 'Checkbox 17'),
                        buildCheckboxListTile("Kidney Disease", 'Checkbox 18'),
                        buildCheckboxListTile("Cardiac Disease", 'Checkbox 19'),
                        buildCheckboxListTile(
                            "Autoimmune Disease", 'Checkbox 20'),
                        buildCheckboxListTile("Asthma", 'Checkbox 21'),
                      ])))),
          const SizedBox(height: 10.0),
          const Divider(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon: const Icon(Symbols.medical_mask_rounded, size: 28.0),
                label: Text("Exposure Report",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          fontSizeDelta: 4,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(children: [
                        const Text(
                          "(APPLICABLE ONLY TO THOSE WHO ARE NOT FULLY COVID-19 VACCINATED (incomplete primary dose). For those with COMPLETE PRIMARY DOSE and WITHOUT SYMPTOMS, there is no need to declare an exposure because you do not have to go on quarantine.)",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                            "\n(Do not encode the same data you previously encoded. / Huwag nang i-encode and datos kung ito ay nai-encode niyo na dati.)\n",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            )),
                        const Text(
                          "Did you have a face-to-face encounter or contact with a confirmed COVID-19 case within 1 meter and for more than 15 minutes; or direct care for a patient with a probable or confirmed COVID-19 case? (Ikaw ba ay may nakahalubilong may COVID-19 sa distansyang mababa sa 1 metro at tumagal nang higit sa 15 minuto; o, nakapag-alaga ng indibidwal na may COVID-19?)",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        buildRadioListTile("Yes", 1, "RadioValue 2"),
                        buildRadioListTile("No", 2, "RadioValue 2"),
                      ])))),
          const SizedBox(height: 10.0),
          const Divider(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon:
                    const Icon(Symbols.medical_information_rounded, size: 28.0),
                label: Text("RT-PCR Test",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          fontSizeDelta: 4,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: [
                        Text("Are you waiting for an RT-PCR result?",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        buildRadioListTile("Yes", 1, "RadioValue 3"),
                        buildRadioListTile("No", 2, "RadioValue 3"),
                      ])))),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon:
                    const Icon(Symbols.medical_information_rounded, size: 28.0),
                label: Text("Rapid Antigen Test for COVID-19",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          fontSizeDelta: 4,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(children: [
                        const Text(
                            "Did you undergo a Rapid Antigen Test / Ikaw ba ay sumailalim sa Rapid Antigen Test?",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        buildRadioListTile("Yes", 1, "RadioValue 4"),
                        buildRadioListTile("No", 2, "RadioValue 4"),
                      ])))),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
