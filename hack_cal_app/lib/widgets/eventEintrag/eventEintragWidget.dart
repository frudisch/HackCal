import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../model/event.dart';
import '../anzeige/anzeigeState.dart';
import '../einladen/einladenWidget.dart';

class EventEintragWidget extends StatelessWidget {
  final TextStyle _biggerFont = const TextStyle(fontSize: 22.0);
  final AnzeigeState parent;
  final Event event;

  EventEintragWidget({this.parent, this.event});

  @override
  Widget build(BuildContext context) {
    Widget tile = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              event.name,
              style: _biggerFont,
            ),
            Text('am ${event.date}'),
            Text(event.description, softWrap: true),
          ],
        ));

    return Slidable(
      delegate: SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: tile,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Einladen',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => _invite(context),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Löschen',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _delete(),
        ),
      ],
    );
  }

  _invite(context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EinladenWidget(event: event)));
  }

  _delete() {
    parent.deleteEvent(event);
  }
}
