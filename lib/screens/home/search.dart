import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/dummy_info.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  static const String routeName = "/";

  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //future: context.read<AccountsProvider>().refetchStudents(),
    //  builder: (context, snapshot) {
    /*if (snapshot.hasError) {
            return _buildNoInternetScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }*/
    // if (snapshot.connectionState == ConnectionState.waiting) {return Text('h', style: TextStyle(fontSize: 100));}
    // context.watch<AccountsProvider>().fetchStudents();
    // context.read<AccountsProvider>().fetchStudents();

    Stream<QuerySnapshot> stream = context.watch<AccountsProvider>().students;

    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          /*
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return _buildEmptyScreen();
          }*/
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData ||
              snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: AppBar(
              leading: EditRequestButton(),
              centerTitle: true,
              title: const AppBarHeader(
                icon: Symbols.face,
                title: "Students",
                hasAction: false,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: AppBar(
                  toolbarHeight: 80,
                  title: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: TextField(
                        onSubmitted: (value) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Symbols.search_rounded),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                          hintText: "Search for students",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              actions: const [
                AppOptions(),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24.0),
                        leading: SizedBox(
                          height: double.infinity,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Text(
                                snapshot.data!.docs[index]["firstName"]
                                    .toString()
                                    .substring(0, 1),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                          ),
                        ),
                        minLeadingWidth: 44.0,
                        title: Text(
                            "${snapshot.data!.docs[index]["firstName"]} ${snapshot.data!.docs[index]["lastName"]}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.docs[index]["studentNumber"],
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        onTap: () => UserDetails.showSheet(
                            context,
                            IskolarInfo.fromJson(snapshot.data!.docs[index]
                                .data() as Map<String, dynamic>)),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }); // });
  }

  /*Widget _buildEmptyScreen() {
      return Center(
        // Show a message where the user can add an entry if list is empty
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_add_outlined,
                size: 64.0,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.75)),
            const SizedBox(height: 16.0),
            /*Text("Create your first entry!",
                style: Theme.of(context).textTheme.titleLarge!.apply(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.75))),*/
            const SizedBox(height: 20.0),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, NewEntry.routeName);
              },
              icon: const Icon(Icons.add_outlined),
              label: const Text("New Entry"),
            )
          ],
        ),
      );
    }

    Widget _buildNoInternetScreen() {
    return Center(
        // Show a message where the user can add an entry if list is empty
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off_outlined,
            size: 64.0,
            color:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.75)),
        const SizedBox(height: 16.0),
        Text("Connect to the internet to get students",
            style: Theme.of(context).textTheme.titleLarge!.apply(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.75))),
      ],
    ));
  }*/
}
