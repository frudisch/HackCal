import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:hack_cal_app/widgets/einladen/einladenViewModel.dart';

class EinladenTeilnehmerWidget extends StatelessWidget {
  final Event event;
  EinladenTeilnehmerDialogWidget _einladenTeilnehmerDialogWidget;

  EinladenTeilnehmerWidget(this.event);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, EinladenViewModel>(converter: (store) {
      store.dispatch(FetchMembersForEvent(event.uuid));
      return EinladenViewModel(
          event: event,
          alleUser: store.state.userList,
          teilnehmer: store.state.fullMembers(event.uuid));
    }, builder: (context, model) {
      _einladenTeilnehmerDialogWidget = EinladenTeilnehmerDialogWidget(model);
      return _einladenTeilnehmerDialogWidget;
    });
  }

  List<User> getTeilnehmer() {
    return _einladenTeilnehmerDialogWidget.getTeilnehmer();
  }
}

class EinladenTeilnehmerDialogWidget extends StatefulWidget {
  final EinladenViewModel model;
  EinladenTeilnehmerDialogState _einladenTeilnehmerDialogState;

  EinladenTeilnehmerDialogWidget(this.model) {
    _einladenTeilnehmerDialogState = EinladenTeilnehmerDialogState(model);
  }

  @override
  State<StatefulWidget> createState() => _einladenTeilnehmerDialogState;

  List<User> getTeilnehmer() {
    return _einladenTeilnehmerDialogState.getTeilnehmer();
  }
}

class EinladenTeilnehmerDialogState
    extends State<EinladenTeilnehmerDialogWidget> {
  final TextStyle _headerFont =
      TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final TextStyle _font = TextStyle(fontSize: 18.0, color: Colors.black);

  final GlobalKey<AutoCompleteTextFieldState<User>> key = GlobalKey();
  final EinladenViewModel model;
  List<User> _neueTeilnehmer;

  String currentUserName = "";
  AutoCompleteTextField textField;

  EinladenTeilnehmerDialogState(this.model) {
    _neueTeilnehmer = model.teilnehmer;
  }

  @override
  Widget build(BuildContext context) {
    textField = AutoCompleteTextField<User>(
        decoration: InputDecoration(
          hintText: "Teilnehmer",
        ),
        key: key,
        style: _font,
        submitOnSuggestionTap: true,
        clearOnSubmit: true,
        suggestions: model.alleUser,
        textInputAction: TextInputAction.go,
        textChanged: (item) => currentUserName = item,
        textSubmitted: _submit,
        itemBuilder: (context, item) {
          return new Padding(
              padding: EdgeInsets.all(8.0), child: new Text(item.name));
        },
        itemSorter: (a, b) {
          return a.compareTo(b);
        },
        itemFilter: (item, query) {
          return item.name.startsWith(query) && !_neueTeilnehmer.contains(item);
        });

    Widget teilnehmer = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              _neueTeilnehmer.map((user) => _buildUserWidget(user)).toList(),
        ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Teilnehmer:', style: _headerFont),
        ListTile(
            title: textField,
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _submit(currentUserName),
            )),
        SizedBox(height: 10.0),
        teilnehmer,
      ],
    );
  }

  Widget _buildUserWidget(User user) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              _neueTeilnehmer.remove(user);
            });
          },
        ),
        Text(
          user.name,
          style: _font,
        )
      ],
    );
  }

  _submit(String username) {
    User current = null;
    model.alleUser.forEach((u) {
      if (u.name == username) {
        current = u;
      }
    });
    if (current == null) {
      return;
    }

    setState(() {
      _neueTeilnehmer.add(current);
      currentUserName = null;
      textField.clear();
    });
  }

  getTeilnehmer() {
    return _neueTeilnehmer;
  }
}
