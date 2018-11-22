import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';

class EinladenViewModel {
  final List<User> alleUser;
  final Event event;
  final List<User> teilnehmer;

  EinladenViewModel({this.alleUser, this.event, this.teilnehmer});
}
