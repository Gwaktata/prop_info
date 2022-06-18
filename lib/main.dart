import 'package:flutter/material.dart';
import 'request_permission.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.white,
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.black),
            subtitle1: TextStyle(
                color: Colors.black, fontSize: 70, fontWeight: FontWeight.bold),
          )),
      home: RequestPermission(),
    );
  }
}
