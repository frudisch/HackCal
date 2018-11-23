import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:hack_cal_app/widgets/einladen/einladenWidget.dart';
import 'package:hack_cal_app/widgets/eventEintrag/eventEintragModel.dart';

class EventEintragWidget extends StatelessWidget {
  final Event event;

  EventEintragWidget(this.event);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, EventEintragModel>(converter: (store) {
      return EventEintragModel(
          deleteCallback: (event) => store.dispatch(RemoveEventAction(event)),
          einladenClick: () =>
              store.dispatch(FetchMembersForEvent(event.uuid)));
    }, builder: (context, model) {
      return EventEintragDialogWidget(event, model: model);
    });
  }
}

class EventEintragDialogWidget extends StatelessWidget {
  final TextStyle _biggerFont = const TextStyle(fontSize: 22.0);

  final Event event;
  final EventEintragModel model;

  EventEintragDialogWidget(this.event, {this.model});

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
          onTap: () => _openEinladenDialog(context),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Löschen',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.deleteCallback(event),
        ),
      ],
    );
  }

  _openEinladenDialog(BuildContext context) {
    model.einladenClick();
    showDialog(context: context, builder: (context) => EinladenWidget(event));
  }
}
