// Name
// Action (diff color) Monitor Name
// Date
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/building_logs_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Stream<QuerySnapshot> stream = context.watch<BuildingLogsProvider>().entries;
    context.read<BuildingLogsProvider>().fetchLogs(context);
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting ||
          !snapshot.hasData ||
          snapshot.data == null) 
        {
          return const Center(child: CircularProgressIndicator());
        }

      return listTileHandler(context, snapshot);
      }
    );
  }

  Widget listTileHandler(BuildContext context, snapshot) {
     String _search = "";
    return StatefulBuilder(
    builder: (context, innerSetState) {
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
                  onChanged: (value) => innerSetState(
                    () {
                      _search = value.toLowerCase();
                    }
                  ),                  
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
        itemCount: snapshot.data!.docs.length,
        itemBuilder: ((context, index) {
          Map<String,dynamic> data = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
          String epoch_date = data["entryDate"];
          IskolarInfo user = IskolarInfo.fromJson(data["user"]);
          if (!(_search == "" || (user.firstName + " " + user.lastName).toLowerCase().contains(_search) 
          || user.userName.toLowerCase().contains(_search) || user.studentNumber.contains(_search))) {
            return Container();
          }
    
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: SizedBox(
              height: double.infinity,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                    "${user.firstName.substring(0,1)}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)),
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
                  DateTime.fromMillisecondsSinceEpoch(int.parse(epoch_date)).toString(),
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
        onPressed: () {},
        label: const Text("Scan user's entry"),
        icon: const Icon(Symbols.qr_code_scanner_rounded),
      ),
    );
    });
  }
}
