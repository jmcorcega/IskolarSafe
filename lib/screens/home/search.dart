import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  static const String routeName = "/";

  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Learn 📗',
    ));
  }
}
