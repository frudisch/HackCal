import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/event.dart';

class EinladenEventDetailsWidget extends StatelessWidget {
  final TextStyle _headerFont =
      TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final TextStyle _font = TextStyle(fontSize: 18.0);
  final _dateFormat = DateFormat("dd.MM.yyyy");
  final _timeFormat = DateFormat("HH:mm");

  final Event event;

  EinladenEventDetailsWidget({this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(event.name, style: _headerFont),
        SizedBox(height: 5.0),
        Text('Datum: ${_dateFormat.format(event.date)}', style: _font),
        Text('Uhrzeit: ${_timeFormat.format(event.date)}', style: _font),
        SizedBox(height: 5.0),
        Text(event.description, style: _font, softWrap: true)
      ],
    );
  }
}
