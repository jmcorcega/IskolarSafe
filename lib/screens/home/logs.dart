// Name
// Action (diff color) Monitor Name
// Date
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/health_badge.dart';
import 'package:iskolarsafe/components/log_details.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/screen_placeholder.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/building_log_model.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/providers/building_logs_provider.dart';
import 'package:iskolarsafe/screens/qr_scanner.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class Logs extends StatefulWidget {
  static const String routeName = "/logs";

  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  ScrollController horizontalController = ScrollController();
  String _search = "";
  String _currentSearchFilter = "Date";
  final List<String> _searchFilters = [
    "Date",
    "Name",
    "Course",
    "College",
    "Student No"
  ];

  // Wait until user has scanned a valid entry
  void _scanOnPressed() async {
    final result = await Navigator.pushNamed(context, QRScanner.routeName);

    // If user has put a valid new entry, add it to the list
    if (context.mounted && result != null) {
      var now = DateTime.now();
      var entry = result as HealthEntry;
      BuildingLog log = BuildingLog(
        entryDate: now,
        monitorId: context.read<AccountsProvider>().userInfo!.id!,
        entryId: entry.id!,
        user: entry.userInfo,
      );

      if (entry.dateGenerated
          .isBefore(DateTime(now.year, now.month, now.day))) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('QR code is not generated today.'),
        ));
      }

      await context.read<BuildingLogsProvider>().addEntry(log);

      // Show snackbar to user if entry added successfully
      if (context.mounted) {
        if (context.read<BuildingLogsProvider>().status) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Row(
                  children: [
                    entry.userInfo.photoUrl != null
                        ? CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                                entry.userInfo.photoUrl!),
                          )
                        : CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Text(
                                entry.userInfo.firstName
                                    .toString()
                                    .substring(0, 1),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                          ),
                    const SizedBox(width: 18.0),
                    Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            "${entry.userInfo.firstName} ${entry.userInfo.lastName}",
                            style:
                                Theme.of(context).textTheme.labelLarge!.apply(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSizeDelta: 4,
                                    ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: HealthBadge(entry.verdict),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('An error has occured. Try again later.'),
          ));
        }
      }
    }

    // And update the state to show the new entry
    setState(() {});
  }

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
                            .compareTo((b.data()
                                as Map<String, dynamic>)["entryDate"]) <
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
                    preferredSize: const Size.fromHeight(120),
                    child: AppBar(
                      titleSpacing: 0,
                      toolbarHeight: 120,
                      title: SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          height: 120,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 6.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: TextField(
                                  onChanged: (value) => innerSetState(() {
                                    _search = value.replaceAll(" ", "");
                                  }),
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Symbols.search_rounded),
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    hintText: "Search for logs",
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ScrollShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withAlpha((255 * 0.25).toInt()),
                                  scrollDirection: Axis.horizontal,
                                  controller: horizontalController,
                                  child: ListView.builder(
                                    controller: horizontalController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _searchFilters.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            left: index == 0 ? 24 : 4,
                                            right: index ==
                                                    _searchFilters.length - 1
                                                ? 24
                                                : 4),
                                        child: ChoiceChip(
                                          label: Text(_searchFilters[index]),
                                          selected: _currentSearchFilter ==
                                              _searchFilters[index],
                                          onSelected: (value) {
                                            innerSetState(() {
                                              _currentSearchFilter =
                                                  _searchFilters[index];
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: const [
                    AppOptions(),
                  ],
                ),
                body: snapshot.isEmpty
                    ? const ScreenPlaceholder(
                        asset: "assets/images/illust_list_empty.svg",
                        text: "No entries to display",
                      )
                    : ListView.builder(
                        itemCount: snapshot.length,
                        itemBuilder: ((context, index) {
                          BuildingLog log = BuildingLog.fromJson(
                              snapshot[index].data() as Map<String, dynamic>);
                          IskolarInfo user = log.user;

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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 8.0,
                            ),
                            leading: SizedBox(
                              height: double.infinity,
                              child: user.photoUrl != null
                                  ? CircleAvatar(
                                      foregroundImage:
                                          CachedNetworkImageProvider(
                                              user.photoUrl!),
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      child: Text(
                                          user.firstName
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
                              "${user.firstName} ${user.lastName}",
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.studentNumber,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  log.entryDate
                                      .relativeTime(context)
                                      .capitalizeFirstLetter(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                            onTap: () =>
                                LogDetails.showSheet(context, log, user),
                          );
                        }),
                      ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: _scanOnPressed,
                  label: const Text("Scan user's entry"),
                  icon: const Icon(Symbols.qr_code_scanner_rounded),
                ),
              );
            },
          );
        });
  }
}
