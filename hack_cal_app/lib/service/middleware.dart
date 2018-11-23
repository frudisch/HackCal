import 'dart:convert';

import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

final String baseUrl = 'http://fe31eea2.ngrok.io';
final String eventUrl = '$baseUrl/event';
final String userUrl = '$baseUrl/user';

void storeEventsMiddleware(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  if (action is FetchAllEventsAction) {
    loadEvents().then(
        (state) => store.dispatch(AllEventsLoadedAction(state.eventList)));
  }
  if (action is CreateEventAction) {
    createEvent(action.event)
        .catchError(() => store.dispatch(FetchAllEventsAction()));
  }
  if (action is RemoveEventAction) {
    removeEvent(action.event)
        .catchError(() => store.dispatch(FetchAllEventsAction()));
  }

  if (action is FetchAllUserAction) {
    loadUser()
        .then((state) => store.dispatch(AllUserLoadedAction(state.userList)));
  }

  if (action is FetchMembersForEvent) {
    String uuid = action.event;
    loadMember(uuid).then((state) => store.dispatch(
        AllMembersForEventLoadedAction(
            event: uuid, members: state.members[uuid])));
  }
  if (action is SaveMembersForEventAction) {
    saveMember(action.event, action.members)
        .catchError(() => store.dispatch(FetchMembersForEvent(action.event)));
    action.notMembers.forEach((member) {
      removeMember(action.event, member)
          .catchError(() => store.dispatch(FetchMembersForEvent(action.event)));
    });
  }
}

Future<AppState> loadEvents() async {
  final response = await http.get(eventUrl);

  if (response.statusCode == 200) {
    List<Event> events = [];
    json.decode(response.body).forEach((i) {
      events.add(Event.fromJson(i as Map<String, dynamic>));
    });
    return AppState.fromJson(events: events);
  }
  return Future.error('Failed to load: GET $eventUrl');
}

Future<void> createEvent(Event event) async {
  final response = await http.post(eventUrl, body: json.encode(event.toJson()));

  if (response.statusCode == 201) {
    return Future.value();
  }
  return Future.error('Failed to load: POST $eventUrl');
}

Future<void> removeEvent(Event event) async {
  final String url = eventUrl + '/' + event.uuid;
  final response = await http.delete(url);

  if (response.statusCode == 204) {
    return Future.value();
  }
  return Future.error('Failed to load: DELETE $url');
}

Future<AppState> loadUser() async {
  final response = await http.get(userUrl);

  if (response.statusCode == 200) {
    List<User> user = [];
    json.decode(response.body).forEach((i) {
      user.add(User.fromJson(i as Map<String, dynamic>));
    });
    return AppState.fromJson(user: user);
  }
  return Future.error('Failed to load: GET $userUrl');
}

Future<AppState> loadMember(String eventUuid) async {
  String url = '$eventUrl/$eventUuid/member';
  final response = await http.get(url);

  if (response.statusCode == 200) {
    var object = json.decode(response.body);
    List<String> member = [];
    object['member'].forEach((i) {
      member.add(i);
    });

    Map<String, List<String>> map = new Map();
    map[object['event']] = member;
    return AppState.fromJson(members: map);
  }
  return Future.error('Failed to load: GET $url');
}

Future<void> saveMember(String eventUuid, List<String> member) async {
  String url = '$eventUrl/$eventUuid/member';
  final response = await http.post(url, body: json.encode({"members": member}));

  if (response.statusCode == 201) {
    return Future.value();
  }
  return Future.error('Failed to load: POST $url');
}

Future<void> removeMember(String eventUuid, String member) async {
  String url = '$eventUrl/$eventUuid/member/$member';
  final response = await http.delete(url);

  if (response.statusCode == 204) {
    return Future.value();
  }
  return Future.error('Failed to load: DELETE $url');
}
