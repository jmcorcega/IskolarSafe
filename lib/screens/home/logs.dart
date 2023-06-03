// Name
// Action (diff color) Monitor Name
// Date

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/dummy_info.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class Logs extends StatefulWidget {
  static const String routeName = "/logs";

  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  TextEditingController _search = new TextEditingController();

  final List<IskolarInfo> _iskolarInfo = DummyInfo.fakeInfoList;

  @override
  Widget build(BuildContext context) {
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
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Symbols.search_rounded),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                    hintText: "Search for logs",
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
      body: ListView.builder(
        itemCount: _iskolarInfo.length,
        itemBuilder: ((context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: SizedBox(
              height: double.infinity,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                    "${_iskolarInfo[index].firstName} ${_iskolarInfo[index].lastName}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ),
            minLeadingWidth: 44.0,
            title: Text(
              "${_iskolarInfo[index].firstName} ${_iskolarInfo[index].lastName}",
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _iskolarInfo[index].studentNumber,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  "18/05/2023 11:53am",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            isThreeLine: true,
            onTap: () => UserDetails.showSheet(context, _iskolarInfo[index]),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Scan user's entry"),
        icon: const Icon(Symbols.qr_code_scanner_rounded),
      ),
    );
  }
}
