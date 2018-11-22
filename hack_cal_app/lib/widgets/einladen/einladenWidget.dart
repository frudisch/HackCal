import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';
import 'package:hack_cal_app/widgets/einladen/einladenEventDetailsWidget.dart';
import 'package:hack_cal_app/widgets/einladen/einladenTeilnehmerWidget.dart';

class EinladenWidget extends StatelessWidget {
  final Event event;

  EinladenWidget(this.event);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnSaveCallback>(converter: (store) {
      return (event, teilnehmer) => store.dispatch(null /* TODO */);
    }, builder: (context, callback) {
      return EinladenDialogWidget(event, callback: callback);
    });
  }
}

class EinladenDialogWidget extends StatelessWidget {
  final OnSaveCallback callback;
  final Event event;

  EinladenDialogWidget(this.event, {this.callback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Freunde einladen'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(children: <Widget>[
            EinladenEventDetailsWidget(event),
            SizedBox(height: 22.0),
            EinladenTeilnehmerWidget(
              event: event,
              alleUser: null /*TODO*/,
            )
          ]),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: callback(event, null /* TODO */),
        tooltip: 'Teilnehmer speichern',
        child: new Icon(Icons.save),
      ),
    );
  }
}

typedef OnSaveCallback = Function(Event event, List<User> teilnehmer);
