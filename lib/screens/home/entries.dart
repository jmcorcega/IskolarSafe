import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/request.dart';
import 'package:material_symbols_icons/symbols.dart';

class Entries extends StatefulWidget {
  static const String routeName = "/";

  const Entries({super.key});

  @override
  State<Entries> createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const AppBarHeader(icon: Symbols.home_rounded, title: "My Entries"),
        actions: const [
          Request(),
          AppOptions(),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading:
                Icon(Symbols.health_and_safety_rounded, color: Colors.green),
            title: Text("Date goes here"),
            subtitle: Text(
              "Safe for entry",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: Colors.green),
            ),
            onTap: () {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showProfileModal(context);
        },
        label: const Text("My Profile"),
        icon: const Icon(Symbols.person_filled_rounded),
      ),
    );
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          snap: true,
          initialChildSize: 0.45,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: const ProfileModal(),
            );
          }),
    );
  }
}

class ProfileModal extends StatelessWidget {
  const ProfileModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 64.0),

        // TODO: QR goes here
        FlutterLogo(size: 150.0),

        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text("U",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
            const SizedBox(width: 16.0),
            Wrap(
              direction: Axis.vertical,
              children: [
                Text(
                  'John Doe',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(fontSizeDelta: 2),
                ),
                Text('2020-012345',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .apply(fontWeightDelta: -1)),
              ],
            ),
          ],
        ),
        TextButton.icon(
          onPressed: null,
          icon: const Icon(Symbols.check_circle_filled, size: 20.0),
          label: Text("Safe for entry",
              style: Theme.of(context).textTheme.labelLarge!.apply(
                    fontSizeDelta: 1,
                    color: Colors.green,
                  )),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(0.0),
            ),
            foregroundColor: MaterialStateProperty.all(
              Colors.green,
            ),
          ),
        ),

        const SizedBox(height: 32.0),
        SizedBox(
          width: MediaQuery.of(context).size.width -
              (MediaQuery.of(context).size.width * 0.1),
          child: const AppBarHeader(
            title: "Entry Information",
            icon: Symbols.login_rounded,
            hasAction: false,
            isCenter: false,
          ),
        ),

        const SizedBox(height: 32.0),
        SizedBox(
          width: MediaQuery.of(context).size.width -
              (MediaQuery.of(context).size.width * 0.1),
          child: const AppBarHeader(
            title: "Medical Information",
            icon: Symbols.medical_information_rounded,
            hasAction: false,
            isCenter: false,
          ),
        ),
      ],
    );
  }
}
