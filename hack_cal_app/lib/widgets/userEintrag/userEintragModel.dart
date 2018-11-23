import 'package:hack_cal_app/model/user.dart';

class UserEintragModel {
  final OnDeleteCallback deleteCallback;

  UserEintragModel({this.deleteCallback});
}

typedef OnDeleteCallback = Function(User user);
