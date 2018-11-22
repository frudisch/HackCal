import 'dart:convert';

import 'package:hack_cal_app/model/event.dart';
import 'package:http/http.dart' as http;
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:redux/redux.dart';

final String eventUrl = 'https://67dabc37.ngrok.io/event';

void storeEventsMiddleware(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  if (action is FetchAllEventsAction) {
    loadEvents().then((state) {
      store.dispatch(new AllEventsLoadedAction(state.eventList));
    });
  }
}

Future<AppState> loadEvents() async {
  final response = await http.get(eventUrl);

  if (response.statusCode == 200) {
    return AppState.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load: GET ${eventUrl}');
  }
}