import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:hack_cal_app/widgets/einladen/einladenEventDetailsWidget.dart';
import 'package:hack_cal_app/widgets/einladen/einladenTeilnehmerWidget.dart';
import 'package:hack_cal_app/widgets/einladen/einladenViewModel.dart';

class EinladenWidget extends StatelessWidget {
  final Event event;

  EinladenWidget(this.event);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnSaveCallback>(converter: (store) {
      return (event, model) => store.dispatch(SaveMembersForEventAction(
          event: event.uuid,
          members: model.teilnehmer.map((u) => u.uuid).toList(),
          notMembers: model.nichtTeilnehmer.map((u) => u.uuid).toList()));
    }, builder: (context, callback) {
      return EinladenDialogWidget(event, callback: callback);
    });
  }
}

class EinladenDialogWidget extends StatelessWidget {
  final OnSaveCallback callback;
  final Event event;
  EinladenTeilnehmerWidget _einladenTeilnehmerWidget;

  EinladenDialogWidget(this.event, {this.callback});

  @override
  Widget build(BuildContext context) {
    _einladenTeilnehmerWidget = EinladenTeilnehmerWidget(event);

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
            _einladenTeilnehmerWidget
          ]),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          callback(event, _einladenTeilnehmerWidget.model);
          Navigator.pop(context);
        },
        tooltip: 'Teilnehmer speichern',
        child: new Icon(Icons.save),
      ),
    );
  }
}

typedef OnSaveCallback = Function(Event event, EinladenViewModel model);
