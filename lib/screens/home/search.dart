import 'package:cached_network_image/cached_network_image.dart';
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

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> stream = context.watch<AccountsProvider>().students;

    return StreamBuilder(
        stream: stream,
        builder: (context, s) {
          if (s.connectionState == ConnectionState.waiting ||
              !s.hasData ||
              s.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

    String _search = "";
    String _currentSearchFilter = "";
    List<String> _searchFilters = ["Name","Course", "College", "Student No"];

    return StatefulBuilder(
      builder: (context, innerSetState) {

        var snapshot = s.data!.docs;
        snapshot.sort((a,b) {
          switch(_currentSearchFilter){
            case "Name":
              if ((a.data() as Map<String,dynamic>)["firstName"].toLowerCase().compareTo((b.data() as Map<String,dynamic>)["firstName"].toLowerCase()) > 0) {
                return 1;
              } else {
                return -1;
              }
            case "Course":
              if ((a.data() as Map<String,dynamic>)["course"].toLowerCase().compareTo((b.data() as Map<String,dynamic>)["course"].toLowerCase()) > 0) {
                return 1;
              } else {
                return -1;
              }
            case "College":
              if ((a.data() as Map<String,dynamic>)["college"].compareTo((b.data() as Map<String,dynamic>)["college"]) > 0) {
                return 1;
              } else {
                return -1;
              }
            case "Student No":
              if ((a.data() as Map<String,dynamic>)["studentNumber"].replaceAll("-","").compareTo((b.data() as Map<String,dynamic>)["studentNumber"].replaceAll("-","")) > 0) {
                return 1;
              } else {
                return -1;
              }
            default:
              return 0;
          }
               
        });

          return Scaffold(
            appBar: AppBar(
              leading: EditRequestButton(),
              centerTitle: true,
              title: const AppBarHeader(
                icon: Symbols.face,
                title: "Users",
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
                        onChanged: (value) => innerSetState(
                          () {
                            _search = value.replaceAll(" ","").replaceAll("-","").toLowerCase();
                          }
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Symbols.search_rounded),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                          hintText: "Search for students",
                          suffixIcon: PopupMenuButton(
                            icon: Icon(Icons.sort),
                            onSelected: (value) {
                              innerSetState(
                                () {
                                  _currentSearchFilter = value;
                                }
                              );                              
                            },
                            itemBuilder: (context) {
                              return _searchFilters.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          )
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
                    itemCount: snapshot.length,
                    itemBuilder: ((context, index) {
                      IskolarInfo user = IskolarInfo.fromJson(
                          snapshot[index].data()
                              as Map<String, dynamic>);

                      if (!(
                        _search == "" ||
                        (user.firstName + user.lastName).replaceAll(" ","").toLowerCase().contains(_search.replaceAll(" ","")) ||
                        user.userName.toLowerCase().contains(_search) ||
                        user.studentNumber.replaceAll("-","").contains(_search)
                        )) {
                        return Container();
                      }
                      
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24.0),
                        leading: SizedBox(
                          height: double.infinity,
                          child: user.photoUrl != null
                              ? CircleAvatar(
                                  foregroundImage: CachedNetworkImageProvider(
                                      user.photoUrl!),
                                )
                              : CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: Text(
                                      user.firstName.toString().substring(0, 1),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                ),
                        ),
                        minLeadingWidth: 44.0,
                        title: Text("${user.firstName} ${user.lastName}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.studentNumber,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        onTap: () => UserDetails.showSheet(context, user),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }); // });
      });
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
