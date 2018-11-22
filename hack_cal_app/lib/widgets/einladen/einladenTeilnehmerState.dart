import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

import '../../model/event.dart';
import '../../model/user.dart';
import '../../service/eventService.dart';
import '../../service/userService.dart';
import 'einladenTeilnehmerWidget.dart';

class EinladenTeilnehmerState extends State<EinladenTeilnehmerWidget> {
  final TextStyle _headerFont =
      TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final TextStyle _font = TextStyle(fontSize: 18.0, color: Colors.black);
  final UserService _userService = UserService();
  final EventService _eventService = EventService();

  final GlobalKey<AutoCompleteTextFieldState<User>> key = GlobalKey();
  final Event event;
  List<User> alleUser = [];
  List<User> _teilnehmer = [];

  String currentUserName = "";
  AutoCompleteTextField textField;

  EinladenTeilnehmerState({this.event});

  @override
  void initState() {
    super.initState();
    _userService.getUser().then((result) {
      setState(() {
        alleUser = result;
        textField.updateSuggestions(alleUser);
      });
    });
    _eventService.getTeilnehmerVonEvent(event.uuid).then((result) {
      setState(() {
        _teilnehmer = result;
      });
    });
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
        suggestions: alleUser,
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
          return item.name.startsWith(query) && !_teilnehmer.contains(item);
        });

    Widget teilnehmer = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _teilnehmer.map((user) => _buildUserWidget(user)).toList(),
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
              _teilnehmer.remove(user);
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
    alleUser.forEach((u) {
      if (u.name == username) {
        current = u;
      }
    });
    if (current == null) {
      return;
    }

    setState(() {
      _teilnehmer.add(current);
      currentUserName = null;
      textField.clear();
    });
  }
}
