import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/user.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:hack_cal_app/widgets/neuerUser/neuerUserModel.dart';
import 'package:hack_cal_app/widgets/textInputField/textInputFieldWidget.dart';
import 'package:uuid/uuid.dart';

class NeuerUserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, NeuerUserModel>(converter: (store) {
      return NeuerUserModel(
          user: store.state.userList,
          addCallback: (user) => store.dispatch(CreateUserAction(user)));
    }, builder: (context, model) {
      return NeuerUserDialogWidget(model);
    });
  }
}

class NeuerUserDialogWidget extends StatefulWidget {
  final NeuerUserModel model;

  NeuerUserDialogWidget(this.model);

  @override
  State<StatefulWidget> createState() => NeuerUserDialogWidgetState();
}

class NeuerUserDialogWidgetState extends State<NeuerUserDialogWidget> {
  final _formKey = GlobalKey<FormState>();

  TextInputFieldWidget _usernameField;
  TextInputFieldWidget _firstNameField;
  TextInputFieldWidget _lastNameField;

  NeuerUserDialogWidgetState() {
    _usernameField = TextInputFieldWidget(
      name: 'Username',
      validator: (value) {
        if (widget.model.user
                .firstWhere((u) => u.username == value, orElse: () => null) !=
            null) {
          return 'Der Username ist bereits vergeben.';
        }
      },
    );
    _firstNameField = TextInputFieldWidget(name: 'Vorname');
    _lastNameField = TextInputFieldWidget(name: 'Nachname');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User hinzufügen'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(children: <Widget>[
            _usernameField,
            SizedBox(height: 22.0),
            _firstNameField,
            SizedBox(height: 22.0),
            _lastNameField,
          ]),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }
          widget.model.addCallback(_buildUser());
          Navigator.pop(context);
        },
        tooltip: 'User speichern',
        child: Icon(Icons.save),
      ),
    );
  }

  _buildUser() {
    return User(
        uuid: Uuid().v1(),
        username: _usernameField.getTextValue(),
        firstName: _firstNameField.getTextValue(),
        lastName: _lastNameField.getTextValue());
  }
}
