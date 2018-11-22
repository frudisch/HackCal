import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/service/actions.dart';

AppState appStateReducers(AppState state, dynamic action) {
  if (action is AllEventsLoadedAction) {
    return loadEvents(action);
  }
  return state;
}

AppState loadEvents(AllEventsLoadedAction action) {
  return new AppState(action.events);
}