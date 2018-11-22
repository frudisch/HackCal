import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

class AnzeigeWidget extends StatelessWidget {

  final Store<AppState> store;

  AnzeigeWidget(this.store);

  @override
  Widget build(BuildContext context) {
    print(store);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Hack Calendar'),
      ),
      body: new EventList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
      ),
    );
  }
}

class EventList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, List<Event>>(
      converter: (store) => store.state.eventList,
      builder: (context, list) {
        print(list);
        return new ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, position) =>
            new EventListItem(list[position]));
      },
    );
  }
}

class EventListItem extends StatelessWidget {
  final Event event;

  EventListItem(this.event);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(event.name),
    );
  }
}

typedef OnStateChanged = Function(Event item);

typedef OnRemoveIconClicked = Function(Event item);
