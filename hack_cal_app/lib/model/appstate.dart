import 'package:hack_cal_app/model/event.dart';

class AppState {
  static var empty = AppState(new List());

  final List<Event> eventList;

  AppState(this.eventList);

  AppState.fromJson(List<dynamic> json)
      : eventList = json
      .map((i) => new Event.fromJson(i as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => {'cartItems': eventList};

  @override
  String toString() => "$eventList";
}