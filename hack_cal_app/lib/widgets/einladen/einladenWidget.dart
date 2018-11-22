import 'package:flutter/material.dart';

import '../../model/event.dart';
import 'einladenEventDetailsWidget.dart';
import 'einladenTeilnehmerWidget.dart';

class EinladenWidget extends StatelessWidget {
  final Event event;

  EinladenWidget({this.event});

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
            EinladenEventDetailsWidget(event: event),
            SizedBox(height: 22.0),
            EinladenTeilnehmerWidget(event: event)
          ]),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _save,
        tooltip: 'Teilnehmer speichern',
        child: new Icon(Icons.save),
      ),
    );
  }

  _save() {
    //TODO
  }
}
