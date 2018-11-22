import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:hack_cal_app/widgets/datetimeInputField/DatetimeInputFieldWidget.dart';
import 'package:hack_cal_app/widgets/textInputField/textInputFieldWidget.dart';
import 'package:uuid/uuid.dart';

class NeuesEventWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnAddCallback>(converter: (store) {
      return (event) => store.dispatch(CreateEventAction(event));
    }, builder: (context, callback) {
      return NeuesEventDialogWidget(callback);
    });
  }
}

class NeuesEventDialogWidget extends StatefulWidget {
  final OnAddCallback callback;

  NeuesEventDialogWidget(this.callback);

  @override
  State<StatefulWidget> createState() => NeuesEventDialogWidgetState(callback);
}

class NeuesEventDialogWidgetState extends State<NeuesEventDialogWidget> {
  final _formKey = GlobalKey<FormState>();

  final _nameField = TextInputFieldWidget(name: 'Name');
  final _datetimeField = DatetimeInputFieldWidget(name: 'Datum');
  final _descriptionField =
      TextInputFieldWidget(name: 'Beschreibung', required: false);

  final OnAddCallback callback;

  NeuesEventDialogWidgetState(this.callback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          callback(_buildEvent());
          Navigator.pop(context);
        },
        tooltip: 'Event speichern',
        child: Icon(Icons.save),
      ),
    );
  }

  _buildEvent() {
    return Event(
        uuid: Uuid().v1(),
        name: _nameField.getTextValue(),
        date: _datetimeField.getValue(),
        description: _descriptionField.getTextValue());
  }
}

typedef OnAddCallback = Function(Event event);
