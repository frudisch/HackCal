import 'package:flutter/material.dart';

import '../../model/event.dart';
import '../../service/eventService.dart';
import '../eventEintrag/eventEintragWidget.dart';
import 'anzeigeWidget.dart';

class AnzeigeState extends State<AnzeigeWidget> {
  final TextStyle biggerFont = const TextStyle(fontSize: 18.0);
  final EventService eventService = EventService();

  Future<List<Event>> _request;
  List<Event> _events = <Event>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _request = eventService.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: _request,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _events = snapshot.data;
          return _buildAnzeige();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildAnzeige() {
    final Iterable<ListTile> tiles = _events.map(
      (Event event) {
        return ListTile(
          title: EventEintragWidget(
            event: event,
          ),
        );
      },
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return ListView(children: divided);
  }
}
