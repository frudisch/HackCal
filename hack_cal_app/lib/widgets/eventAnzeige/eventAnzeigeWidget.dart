import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:hack_cal_app/widgets/eventEintrag/eventEintragWidget.dart';
import 'package:hack_cal_app/widgets/neuesEvent/neuesEventWidget.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:redux/redux.dart';

class EventAnzeigeWidget extends StatelessWidget {
  final Store<AppState> store;
  final RefreshController _refreshController = RefreshController();

  EventAnzeigeWidget(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildEventList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openNeuesEventDialog(context),
      ),
    );
  }

  _buildEventList() {
    return StoreConnector<AppState, List<Event>>(
      converter: (store) => store.state.eventList,
      builder: (context, list) {
        return Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              controller: _refreshController,
              onRefresh: (up) {
                store.dispatch(FetchAllEventsAction());
                _refreshController.sendBack(up, RefreshStatus.completed);
              },
              child: ListView.builder(
                  itemCount: 2 * list.length - 1,
                  itemBuilder: (BuildContext _context, int i) {
                    if (i.isOdd) {
                      return const Divider();
                    }
                    final int index = i ~/ 2;
                    return EventEintragWidget(list[index]);
                  }),
            ));
      },
    );
  }

  _openNeuesEventDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => NeuesEventWidget());
  }
}
