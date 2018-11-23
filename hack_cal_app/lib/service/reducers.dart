import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/service/actions.dart';

AppState appStateReducers(AppState state, dynamic action) {
  if (action is AllEventsLoadedAction) {
    return loadEvents(state, action);
  }
  if (action is CreateEventAction) {
    return createEvent(state, action);
  }
  if (action is RemoveEventAction) {
    return removeEvent(state, action);
  }

  if (action is AllUserLoadedAction) {
    return loadUser(state, action);
  }

  if (action is AllMembersForEventLoadedAction) {
    return loadMember(state, action);
  }
  if (action is SaveMembersForEventAction) {
    return saveMember(state, action);
  }
  return state;
}

AppState loadEvents(AppState state, AllEventsLoadedAction action) {
  return AppState(
      eventList: action.events,
      members: state.members,
      userList: state.userList);
}

AppState createEvent(AppState state, CreateEventAction action) {
  state.eventList.add(action.event);
  return state;
}

AppState removeEvent(AppState state, RemoveEventAction action) {
  state.eventList.remove(action.event);
  return state;
}

AppState loadUser(AppState state, AllUserLoadedAction action) {
  return AppState(
      eventList: state.eventList,
      members: state.members,
      userList: action.user);
}

AppState loadMember(AppState state, AllMembersForEventLoadedAction action) {
  Map<String, List<String>> members =
      state.members != null ? state.members : new Map();
  members[action.event] = action.members;
  return AppState(
      eventList: state.eventList, members: members, userList: state.userList);
}

AppState saveMember(AppState state, SaveMembersForEventAction action) {
  Map<String, List<String>> members =
      state.members != null ? state.members : new Map();
  members[action.event] = action.members;
  return AppState(
      eventList: state.eventList, members: members, userList: state.userList);
}
