import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/screens/login.dart';
import 'package:workplace_opinion_app/screens/root.dart';
import 'package:workplace_opinion_app/services/auth.dart';

import 'screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Root(
        auth: new Auth(),
      ),
    );
  }
}



