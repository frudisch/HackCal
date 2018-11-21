import 'package:flutter/material.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

import '../../model/event.dart';
import '../../service/eventService.dart';
import '../eventEintrag/eventEintragWidget.dart';
import '../neuesEvent/neuesEventWidget.dart';
import 'anzeigeWidget.dart';

class AnzeigeState extends State<AnzeigeWidget> {
  final EventService _eventService = EventService();
  final RefreshController _refreshController = RefreshController();

  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _eventService.getEvents().then((result) => _events = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hack Calendar'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _refresh,
        child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 2 * _events.length - 1,
            itemBuilder: (BuildContext _context, int i) {
              if (i.isOdd) {
                return const Divider();
              }
              final int index = i ~/ 2;
              return EventEintragWidget(event: _events[index]);
            }),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Event hinzufügen',
        child: new Icon(Icons.add),
      ),
    );
  }

  _refresh(bool up) async {
    List<Event> result = await _eventService.getEvents();
    setState(() {
      _events = result;
    });
    _refreshController.sendBack(up, RefreshStatus.completed);
  }

  _addEvent() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return NeuesEventWidget();
        },
      ),
    );
  }
}
