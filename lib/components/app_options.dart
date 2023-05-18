import 'package:flutter/material.dart';
import 'package:iskolarsafe/screens/login.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppOptions extends StatelessWidget {
  const AppOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: CircleAvatar(
        radius: 14,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text("U",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      onPressed: () => _showAppOptionsDialog(context),
    );
  }

  Future<void> _showAppOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: MediaQuery.of(context).size.height * 0.085,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        contentPadding: const EdgeInsets.all(0.0),
        content: Builder(
          builder: (context) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const SizedBox(width: 18.0),
                      IconButton(
                        icon: const Icon(Symbols.close_rounded),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Text(
                          "IskolarSafe",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge!.apply(
                                fontWeightDelta: 2,
                                fontSizeDelta: -4,
                              ),
                        ),
                      ),
                      const IconButton(
                        icon: Icon(null),
                        onPressed: null,
                      ),
                      const SizedBox(width: 18.0),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Text("U",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'John Doe',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .apply(fontWeightDelta: 1),
                                    ),
                                    Text('johndoe@example.com',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18.0),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text("Edit your profile"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ListTile(
                    leading: const Icon(Symbols.settings_rounded),
                    title: const Text("App Settings"),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24.0),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Symbols.logout_rounded),
                    title: const Text("Log out"),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24.0),
                    onTap: () {
                      // TODO: Should trigger logout
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Login.routeName);
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "Stay safe, isko/iska!",
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
