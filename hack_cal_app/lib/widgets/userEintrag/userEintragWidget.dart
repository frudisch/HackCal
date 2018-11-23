import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/user.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:hack_cal_app/widgets/userEintrag/userEintragModel.dart';

class UserEintragWidget extends StatelessWidget {
  final User user;

  UserEintragWidget(this.user);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, UserEintragModel>(converter: (store) {
      return UserEintragModel(
          deleteCallback: (user) => store.dispatch(RemoveUserAction(user)));
    }, builder: (context, model) {
      return UserEintragDialogWidget(user, model: model);
    });
  }
}

class UserEintragDialogWidget extends StatelessWidget {
  final TextStyle _biggerFont = const TextStyle(fontSize: 22.0);

  final User user;
  final UserEintragModel model;

  UserEintragDialogWidget(this.user, {this.model});

  @override
  Widget build(BuildContext context) {
    Widget tile = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              user.username,
              style: _biggerFont,
            ),
            Text('Vorname: ${user.firstName}'),
            Text('Nachname: ${user.lastName}'),
          ],
        ));

    return Slidable(
      delegate: SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: tile,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Löschen',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.deleteCallback(user),
        ),
      ],
    );
  }
}
