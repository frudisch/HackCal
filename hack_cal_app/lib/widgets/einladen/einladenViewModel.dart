import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';

class EinladenViewModel {
  final List<User> alleUser;
  final Event event;
  final List<User> originalTeilnehmer;
  List<User> teilnehmer;
  List<User> nichtTeilnehmer;

  EinladenViewModel({this.alleUser, this.event, this.originalTeilnehmer}) {
    teilnehmer = new List();
    nichtTeilnehmer = new List();

    teilnehmer.addAll(originalTeilnehmer);
  }

  addTeilnehmer(User user) {
    teilnehmer.add(user);
    nichtTeilnehmer.remove(user);
  }

  removeTeilnehmer(User user) {
    nichtTeilnehmer.add(user);
    teilnehmer.remove(user);
  }
}
