import 'package:flutter/material.dart';

import '../../model/event.dart';

class EventEintragWidget extends StatelessWidget {
  final TextStyle _biggerFont = const TextStyle(fontSize: 22.0);
  final Event event;

  EventEintragWidget({this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.name,
          style: _biggerFont,
        ),
        Text('am ${event.date}'),
        Text(event.description),
      ],
    );
  }
}
