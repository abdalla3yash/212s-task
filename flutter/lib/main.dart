import 'package:flutter/material.dart';
import 'package:task212/demopage.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Demo',
      theme: ThemeData.dark(),
      home: DemoPage(),
    );
  }

}

