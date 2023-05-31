import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/dummy_info.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class Search extends StatefulWidget {
  static const String routeName = "/";

  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<IskolarInfo> _iskolarInfo = DummyInfo.fakeInfoList;

  @override
  Widget build(BuildContext context) {
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
              itemCount: _iskolarInfo.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  leading: SizedBox(
                    height: double.infinity,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                          _iskolarInfo[index]
                              .firstName
                              .toString()
                              .substring(0, 1),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary)),
                    ),
                  ),
                  minLeadingWidth: 44.0,
                  title: Text(
                      "${_iskolarInfo[index].firstName} ${_iskolarInfo[index].lastName}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _iskolarInfo[index].studentNumber,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  onTap: () =>
                      UserDetails.showSheet(context, _iskolarInfo[index], ""),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
