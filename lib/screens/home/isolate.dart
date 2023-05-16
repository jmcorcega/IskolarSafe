import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class Isolate extends StatefulWidget {
  static const String routeName = "/";

  const Isolate({super.key});

  @override
  State<Isolate> createState() => _IsolateState();
}

class _IsolateState extends State<Isolate> {
  List<IconData> _listIcons = [Symbols.login_rounded, Symbols.logout_rounded];
  List<String> _listStrings = ["My Account", "Logout"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Icon(
                Symbols.sick,
                color: Color(0xFF0CC078),
                size: 40.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text("Under Monitoring",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF0CC078))),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 20, 0, 100),
                  items: List.generate(_listIcons.length, (index) {
                    return PopupMenuItem(
                        value: index,
                        onTap: () {},
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(_listIcons[index]),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(_listStrings[index]))
                          ],
                        ));
                  }));
            },
            icon: const Icon(Symbols.more_vert_rounded),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showProfileModal(context);
        },
        label: const Text("My Profile"),
        icon: const Icon(Symbols.person_filled_rounded),
      ),
    );
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.45,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: const ProfileModal(),
            );
          }),
    );
  }
}

class ProfileModal extends StatelessWidget {
  const ProfileModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 64.0),
        FlutterLogo(size: 150.0),
        SizedBox(height: 18.0),
        Text("User's Name", style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
