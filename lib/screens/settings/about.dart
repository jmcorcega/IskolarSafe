// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';

class About extends StatelessWidget {
  const About({super.key});
  static const String routeName = "/about";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const AppBarHeader(
        icon: Symbols.info_rounded,
        title: "About",
        isCenter: false,
      )),
    );
  }
}
