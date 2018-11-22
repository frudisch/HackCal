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
    _eventService.getEvents().then((result) {
      setState(() {
        _events = result;
      });
    });
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
        onRefresh: (up) async {
          await _refresh();
          _refreshController.sendBack(up, RefreshStatus.completed);
        },
        child: ListView.builder(
            itemCount: 2 * _events.length - 1,
            itemBuilder: (BuildContext _context, int i) {
              if (i.isOdd) {
                return const Divider();
              }
              final int index = i ~/ 2;
              return EventEintragWidget(parent: this, event: _events[index]);
            }),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Event hinzufügen',
        child: new Icon(Icons.add),
      ),
    );
  }

  _refresh() async {
    List<Event> result = await _eventService.getEvents();
    setState(() {
      _events = result;
    });
  }

  _addEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NeuesEventWidget()),
    ).then((value) => _refresh());
  }

  deleteEvent(Event event) {
    setState(() {
      _events.remove(event);
    });

    try {
      _eventService.deleteEvent(event);
    } catch (e) {
      print('Exception: ${e}');
      _refresh();
    }
  }
}
