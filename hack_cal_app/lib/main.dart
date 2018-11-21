import 'package:flutter/material.dart';

import 'widgets/anzeige/anzeigeWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hack Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new AnzeigeWidget(),
    );
  }
}
