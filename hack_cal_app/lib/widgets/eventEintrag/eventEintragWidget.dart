import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/service/actions.dart';

class EventEintragWidget extends StatelessWidget {
  final Event event;

  EventEintragWidget(this.event);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnDeleteCallback>(converter: (store) {
      return (event) => store.dispatch(RemoveEventAction(event));
    }, builder: (context, deleteCallback) {
      return EventEintragDialogWidget(event, deleteCallback: deleteCallback);
    });
  }
}

class EventEintragDialogWidget extends StatelessWidget {
  final TextStyle _biggerFont = const TextStyle(fontSize: 22.0);

  final Event event;
  final OnDeleteCallback deleteCallback;

  EventEintragDialogWidget(this.event, {this.deleteCallback});

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
//          onTap: () => TODO,
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Löschen',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => deleteCallback(event),
        ),
      ],
    );
  }
}

typedef OnDeleteCallback = Function(Event event);
