import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class AppOptions extends StatefulWidget {
  const AppOptions({super.key});

  @override
  State<AppOptions> createState() => _AppOptionsState();
}

class _AppOptionsState extends State<AppOptions> {
  @override
  Widget build(BuildContext context) {
    User? user = context.read<AccountsProvider>().user;
    Future<AppUserInfo?>? userInfo = context.read<AccountsProvider>().userInfo;

    return FutureBuilder(
      future: userInfo,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return IconButton(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                (user?.displayName ?? "U").substring(0, 1),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            onPressed: () => _showAppOptionsDialog(context),
          );
        } else {
          var userPhoto = user!.photoURL;

          return IconButton(
            icon: userPhoto != null
                ? CircleAvatar(
                    radius: 14,
                    foregroundImage: CachedNetworkImageProvider(userPhoto),
                  )
                : CircleAvatar(
                    radius: 14,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      user.displayName!.substring(0, 1),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
            onPressed: () => _showAppOptionsDialog(context),
          );
        }
      },
    );
  }

  Future<void> _showAppOptionsDialog(BuildContext context) {
    User? user = context.read<AccountsProvider>().user;
    Future<AppUserInfo?>? userInfo = context.read<AccountsProvider>().userInfo;
    String? userPhoto = user?.photoURL;

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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: userInfo,
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      child: Text(
                                        user!.displayName!.substring(0, 1),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                    );
                                  } else {
                                    return userPhoto != null
                                        ? CircleAvatar(
                                            foregroundImage:
                                                CachedNetworkImageProvider(
                                                    userPhoto),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Text(
                                              user!.displayName!
                                                  .substring(0, 1),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                            ),
                                          );
                                  }
                                },
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user!.displayName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .apply(
                                            fontSizeDelta: 2,
                                          ),
                                    ),
                                    Text(user.email!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .apply(
                                              fontSizeDelta: -1,
                                            )),
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
                      Navigator.pop(context);
                      context.read<AccountsProvider>().signOut();
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
