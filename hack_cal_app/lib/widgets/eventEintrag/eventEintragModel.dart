import 'package:hack_cal_app/model/event.dart';

class EventEintragModel {
  final OnDeleteCallback deleteCallback;
  final OnEinladenClick einladenClick;

  EventEintragModel({this.einladenClick, this.deleteCallback});
}

typedef OnDeleteCallback = Function(Event event);

typedef OnEinladenClick = Function();
