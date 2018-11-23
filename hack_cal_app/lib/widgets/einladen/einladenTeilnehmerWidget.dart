import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';
import 'package:hack_cal_app/widgets/einladen/einladenViewModel.dart';

class EinladenTeilnehmerWidget extends StatelessWidget {
  final Event event;
  EinladenViewModel model;

  EinladenTeilnehmerWidget(this.event);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, EinladenViewModel>(converter: (store) {
      return EinladenViewModel(
          event: event,
          alleUser: store.state.userList,
          originalTeilnehmer: store.state.fullMembers(event.uuid));
    }, builder: (context, model) {
      this.model = model;
      return EinladenTeilnehmerDialogWidget(model);
    });
  }

  List<User> getTeilnehmer() {
    return model.teilnehmer;
  }
}

class EinladenTeilnehmerDialogWidget extends StatefulWidget {
  final EinladenViewModel model;

  EinladenTeilnehmerDialogWidget(this.model);

  @override
  State<StatefulWidget> createState() => EinladenTeilnehmerDialogState();
}

class EinladenTeilnehmerDialogState
    extends State<EinladenTeilnehmerDialogWidget> {
  final TextStyle _headerFont =
      TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final TextStyle _font = TextStyle(fontSize: 18.0, color: Colors.black);

  final GlobalKey<AutoCompleteTextFieldState<User>> key = GlobalKey();

  String currentUserName = "";
  AutoCompleteTextField textField;

  EinladenTeilnehmerDialogState();

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
        suggestions: widget.model.alleUser,
        textInputAction: TextInputAction.go,
        textChanged: (item) => currentUserName = item,
        textSubmitted: _submit,
        itemBuilder: (context, item) {
          return Padding(
              padding: EdgeInsets.all(8.0), child: Text(item.username));
        },
        itemSorter: (a, b) {
          return a.compareTo(b);
        },
        itemFilter: (item, query) {
          return item.username.toLowerCase().startsWith(query.toLowerCase()) &&
              !widget.model.teilnehmer.contains(item);
        });

    Widget teilnehmer = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.model.teilnehmer
              .map((user) => _buildUserWidget(user))
              .toList(),
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
              widget.model.removeTeilnehmer(user);
            });
          },
        ),
        Text(
          user.username,
          style: _font,
        )
      ],
    );
  }

  _submit(String username) {
    User current = null;
    widget.model.alleUser.forEach((u) {
      if (u.username == username) {
        current = u;
      }
    });
    if (current == null) {
      return;
    }

    setState(() {
      widget.model.addTeilnehmer(current);
      currentUserName = null;
      textField.clear();
    });
  }
}
