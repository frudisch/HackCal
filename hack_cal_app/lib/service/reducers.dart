import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/service/actions.dart';

AppState appStateReducers(AppState state, dynamic action) {
  if (action is AllEventsLoadedAction) {
    return loadEvents(action);
  }
  if (action is CreateEventAction) {
    return createEvent(state, action);
  }
  if (action is RemoveEventAction) {
    return removeEvent(state, action);
  }
  return state;
}

AppState loadEvents(AllEventsLoadedAction action) {
  return new AppState(action.events);
}

AppState createEvent(AppState state, CreateEventAction action) {
  state.eventList.add(action.event);
  return state;
}

AppState removeEvent(AppState state, RemoveEventAction action) {
  state.eventList.remove(action.event);
  return state;
}
