import 'dart:convert';

import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

final String eventUrl = 'http://4096e195.ngrok.io/event';

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
}

Future<AppState> loadEvents() async {
  final response = await http.get(eventUrl);

  if (response.statusCode == 200) {
    return AppState.fromJson(json.decode(response.body), new List());
  }
  return Future.error('Failed to load: GET ${eventUrl}');
}

Future<void> createEvent(Event event) async {
  final response = await http.post(eventUrl, body: json.encode(event.toJson()));

  if (response.statusCode == 201) {
    return Future.value();
  }
  return Future.error('Failed to load: POST ${eventUrl}');
}

Future<void> removeEvent(Event event) async {
  final String url = eventUrl + '/' + event.uuid;
  final response = await http.delete(url);

  if (response.statusCode == 204) {
    return Future.value();
  }
  return Future.error('Failed to load: DELETE ${url}');
}
