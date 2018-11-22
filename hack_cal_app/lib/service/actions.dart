import 'package:hack_cal_app/model/event.dart';

class FetchAllEventsAction {}

class AllEventsLoadedAction {
  final List<Event> events;

  AllEventsLoadedAction(this.events);
}

class CreateEventAction {
  final Event event;

  CreateEventAction(this.event);
}

class RemoveEventAction {
  final Event event;

  RemoveEventAction(this.event);
}
