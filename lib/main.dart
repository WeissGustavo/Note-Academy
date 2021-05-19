import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    title: "Note Academy",
    themeMode: ThemeMode.system,
  ));
}
