import 'package:hack_cal_app/model/user.dart';

class NeuerUserModel {
  final List<User> user;
  final OnAddCallback addCallback;

  NeuerUserModel({this.user, this.addCallback});
}

typedef OnAddCallback = Function(User user);
