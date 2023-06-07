// Name
// Action (diff color) Monitor Name
// Date
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/building_logs_provider.dart';
import 'package:iskolarsafe/screens/qr_scanner.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class Logs extends StatefulWidget {
  static const String routeName = "/logs";

  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  String _search = "";
  String _currentSearchFilter = "";
  List<String> _searchFilters = [
    "Date",
    "Name",
    "Course",
    "College",
    "Student No"
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Stream<QuerySnapshot> stream =
        context.watch<BuildingLogsProvider>().entries;
    context.read<BuildingLogsProvider>().fetchLogs(context);
    return StreamBuilder(
        stream: stream,
        builder: (context, s) {
          if (s.connectionState == ConnectionState.waiting ||
              !s.hasData ||
              s.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StatefulBuilder(
            builder: (context, innerSetState) {
              var snapshot = s.data!.docs;
              snapshot.sort((a, b) {
                switch (_currentSearchFilter) {
                  case "Date":
                    if ((a.data() as Map<String, dynamic>)["entryDate"]
                            .toLowerCase()
                            .compareTo(
                                (b.data() as Map<String, dynamic>)["entryDate"]
                                    .toLowerCase()) >
                        0) {
                      return 1;
                    } else {
                      return -1;
                    }
                  case "Name":
                    if ((a.data() as Map<String, dynamic>)["user"]["firstName"]
                            .toLowerCase()
                            .compareTo(
                                (b.data() as Map<String, dynamic>)["user"]
                                        ["firstName"]
                                    .toLowerCase()) >
                        0) {
                      return 1;
                    } else {
                      return -1;
                    }
                  case "Course":
                    if ((a.data() as Map<String, dynamic>)["user"]["course"]
                            .toLowerCase()
                            .compareTo((b.data()
                                    as Map<String, dynamic>)["user"]["course"]
                                .toLowerCase()) >
                        0) {
                      return 1;
                    } else {
                      return -1;
                    }
                  case "College":
                    if ((a.data() as Map<String, dynamic>)["user"]["college"]
                            .compareTo((b.data()
                                as Map<String, dynamic>)["user"]["college"]) >
                        0) {
                      return 1;
                    } else {
                      return -1;
                    }
                  case "Student No":
                    if ((a.data() as Map<String, dynamic>)["user"]
                                ["studentNumber"]
                            .replaceAll("-", "")
                            .compareTo(
                                (b.data() as Map<String, dynamic>)["user"]
                                        ["studentNumber"]
                                    .replaceAll("-", "")) >
                        0) {
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
                    icon: Symbols.quick_reference_all_rounded,
                    title: "Logs",
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
                            onChanged: (value) => innerSetState(() {
                              _search = value.replaceAll(" ", "");
                            }),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Symbols.search_rounded),
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 16.0),
                                hintText: "Search for logs",
                                suffixIcon: PopupMenuButton(
                                  icon: Icon(Icons.sort),
                                  onSelected: (value) {
                                    innerSetState(() {
                                      _currentSearchFilter = value;
                                    });
                                  },
                                  itemBuilder: (context) {
                                    return _searchFilters.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: const [
                    AppOptions(),
                  ],
                ),
                body: ListView.builder(
                  itemCount: snapshot.length,
                  itemBuilder: ((context, index) {
                    Map<String, dynamic> data =
                        snapshot[index].data() as Map<String, dynamic>;
                    String epoch_date = data["entryDate"];
                    IskolarInfo user = IskolarInfo.fromJson(data["user"]);

                    if (!(_search == "" ||
                        (user.firstName + user.lastName)
                            .toLowerCase()
                            .replaceAll(" ", "")
                            .contains(_search.replaceAll(" ", "")) ||
                        user.userName.toLowerCase().contains(_search) ||
                        user.studentNumber.contains(_search))) {
                      return Container();
                    }

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24.0),
                      leading: SizedBox(
                        height: double.infinity,
                        child: user.photoUrl != null
                            ? CircleAvatar(
                                foregroundImage:
                                    CachedNetworkImageProvider(user.photoUrl!),
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
                      title: Text(
                        "${user.firstName} ${user.lastName}",
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.studentNumber,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(epoch_date))
                                .toString(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () => UserDetails.showSheet(context, user),
                    );
                  }),
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, QRScanner.routeName);
                  },
                  label: const Text("Scan user's entry"),
                  icon: const Icon(Symbols.qr_code_scanner_rounded),
                ),
              );
            },
          );
        });
  }
}
