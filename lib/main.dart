import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screen/home_screen.dart';

void main() => runApp(RootApp());

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
