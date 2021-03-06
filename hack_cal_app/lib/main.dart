import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hack_cal_app/model/appstate.dart';
import 'package:hack_cal_app/service/actions.dart';
import 'package:hack_cal_app/service/middleware.dart';
import 'package:hack_cal_app/service/reducers.dart';
import 'package:hack_cal_app/widgets/eventAnzeige/eventAnzeigeWidget.dart';
import 'package:hack_cal_app/widgets/userAnzeige/userAnzeigeWidget.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(appStateReducers,
      initialState: AppState.empty, middleware: [storeEventsMiddleware]);

  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Hack Calendar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StoreBuilder<AppState>(
          onInit: (store) {
            store.dispatch(FetchAllEventsAction());
            store.dispatch(FetchAllUserAction());
          },
          builder: (context, store) => DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    bottom: TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.event)),
                        Tab(icon: Icon(Icons.people)),
                      ],
                    ),
                    title: Text('Hack Calendar'),
                  ),
                  body: TabBarView(
                    children: [
                      EventAnzeigeWidget(store),
                      UserAnzeigeWidget(store),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
