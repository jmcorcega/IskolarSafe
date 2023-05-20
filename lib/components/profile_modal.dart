import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProfileModal extends StatelessWidget {
  const ProfileModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 64.0),

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
