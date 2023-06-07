import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/screen_placeholder.dart';
import 'package:iskolarsafe/components/user_details.dart';
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

  ScrollController horizontalController = ScrollController();

  String _search = "";
  String _currentSearchFilter = "Name";
  final List<String> _searchFilters = [
    "Name",
    "Course",
    "College",
    "ID Number"
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Stream<QuerySnapshot> stream = context.watch<AccountsProvider>().students;

    return StreamBuilder(
        stream: stream,
        builder: (context, s) {
          if (s.connectionState == ConnectionState.waiting ||
              !s.hasData ||
              s.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StatefulBuilder(builder: (context, innerSetState) {
            var snapshot = s.data!.docs;
            snapshot.sort((a, b) {
              switch (_currentSearchFilter) {
                case "Name":
                  if ((a.data() as Map<String, dynamic>)["firstName"]
                          .toLowerCase()
                          .compareTo(
                              (b.data() as Map<String, dynamic>)["firstName"]
                                  .toLowerCase()) >
                      0) {
                    return 1;
                  } else {
                    return -1;
                  }
                case "Course":
                  if ((a.data() as Map<String, dynamic>)["course"]
                          .toLowerCase()
                          .compareTo(
                              (b.data() as Map<String, dynamic>)["course"]
                                  .toLowerCase()) >
                      0) {
                    return 1;
                  } else {
                    return -1;
                  }
                case "College":
                  if ((a.data() as Map<String, dynamic>)["college"].compareTo(
                          (b.data() as Map<String, dynamic>)["college"]) >
                      0) {
                    return 1;
                  } else {
                    return -1;
                  }
                case "ID Number":
                  if ((a.data() as Map<String, dynamic>)["studentNumber"]
                          .replaceAll("-", "")
                          .compareTo((b.data()
                                  as Map<String, dynamic>)["studentNumber"]
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
                  icon: Symbols.face,
                  title: "Users",
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
                                  hintText: "Search for users",
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
                                          right:
                                              index == _searchFilters.length - 1
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
              body: Column(
                children: [
                  Expanded(
                    child: snapshot.isEmpty
                        ? const ScreenPlaceholder(
                            asset: "assets/images/illust_list_empty.svg",
                            text: "No users to display",
                          )
                        : ListView.builder(
                            itemCount: snapshot.length,
                            itemBuilder: ((context, index) {
                              IskolarInfo user = IskolarInfo.fromJson(
                                  snapshot[index].data()
                                      as Map<String, dynamic>);

                              if (!(_search == "" ||
                                  (user.firstName + user.lastName)
                                      .replaceAll(" ", "")
                                      .toLowerCase()
                                      .contains(_search.replaceAll(" ", "")) ||
                                  user.userName
                                      .toLowerCase()
                                      .contains(_search) ||
                                  user.studentNumber
                                      .replaceAll("-", "")
                                      .contains(_search))) {
                                return Container();
                              }

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                leading: SizedBox(
                                  height: double.infinity,
                                  child: user.photoUrl != null
                                      ? CircleAvatar(
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                                  user.photoUrl!),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                title:
                                    Text("${user.firstName} ${user.lastName}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.studentNumber,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ],
                                ),
                                onTap: () =>
                                    UserDetails.showSheet(context, user),
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
}
