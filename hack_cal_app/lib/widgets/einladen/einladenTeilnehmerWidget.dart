import 'package:flutter/material.dart';

import '../../model/event.dart';
import 'einladenTeilnehmerState.dart';

class EinladenTeilnehmerWidget extends StatefulWidget {
  final Event event;

  EinladenTeilnehmerWidget({this.event});

  @override
  EinladenTeilnehmerState createState() =>
      new EinladenTeilnehmerState(event: event);
}
