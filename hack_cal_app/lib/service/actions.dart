import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';

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

class FetchAllUserAction {}

class AllUserLoadedAction {
  final List<User> user;

  AllUserLoadedAction(this.user);
}

class FetchMembersForEvent {
  final String event;

  FetchMembersForEvent(this.event);
}

class AllMembersForEventLoadedAction {
  final String event;
  final List<String> members;

  AllMembersForEventLoadedAction({this.event, this.members});
}

class SaveMembersForEventAction {
  final String event;
  final List<String> members;
  final List<String> notMembers;

  SaveMembersForEventAction({this.event, this.members, this.notMembers});
}
