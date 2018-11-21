import 'package:flutter/material.dart';

import '../../model/event.dart';
import '../../service/eventService.dart';
import '../datetimeInputField/DatetimeInputFieldWidget.dart';
import '../textInputField/textInputFieldWidget.dart';
import 'neuesEventWidget.dart';

class NeuesEventState extends State<NeuesEventWidget> {
  final EventService _eventService = EventService();
  final _formKey = GlobalKey<FormState>();

  final _nameField = TextInputFieldWidget(name: 'Name');
  final _datetimeField = DatetimeInputFieldWidget(name: 'Datum');
  final _descriptionField =
      TextInputFieldWidget(name: 'Beschreibung', required: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Event hinzufügen'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(children: <Widget>[
            _nameField,
            SizedBox(height: 22.0),
            _datetimeField,
            SizedBox(height: 22.0),
            _descriptionField,
          ]),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }
          _save(context);
        },
        tooltip: 'Event speichern',
        child: new Icon(Icons.save),
      ),
    );
  }

  _save(BuildContext context) {
    Event event = Event(
        name: _nameField.getTextValue(),
        date: _datetimeField.getValue(),
        description: _descriptionField.getTextValue());
    _eventService.addEvent(event);
    Navigator.pop(context);
  }
}
