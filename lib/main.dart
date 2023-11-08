import 'package:blog/authenticate.dart';
import 'package:blog/mapping.dart';
import 'package:blog/startup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BlocApp());
}

class BlocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
