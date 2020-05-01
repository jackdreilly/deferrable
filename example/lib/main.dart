import 'dart:async';

import 'package:deferrable/deferrable.dart';
import 'package:flutter/material.dart';

class DeferredTimerWidget extends StatefulWidget {
  @override
  _DeferredTimerWidgetState createState() => _DeferredTimerWidgetState();
}

class _DeferredTimerWidgetState extends State<DeferredTimerWidget>
    with Deferrable {
  var date = DateTime.now();
  @override
  void initState() {
    super.initState();
    _append('time created');
    defer(Stream.periodic(const Duration(seconds: 1))
        .listen((_) => setState(() => date = DateTime.now()))
        .cancel);
    defer(() => Future.microtask(() => _append('time disposed')));
  }

  @override
  Widget build(BuildContext context) => Text(date.toIso8601String());
}

class Deferred extends StatefulWidget {
  @override
  _DeferredState createState() => _DeferredState();
}

class _DeferredState extends State<Deferred> with Deferrable {
  @override
  void initState() {
    super.initState();
    _append('button created');
    defer(() => Future.microtask(() => _append('button disposed')));
  }

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: () => showNotifier.value = false,
        child: Text("Dispose Deferred"),
        color: Colors.green,
      );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

final showNotifier = ValueNotifier(false);
final _statusController = StreamController<String>();
final _append = _statusController.add;

class _AppState extends State<App> with Deferrable {
  String status = "nothing";
  @override
  void initState() {
    super.initState();
    defer(_statusController.stream
        .listen((s) => setState(() => status = '$status\n$s'))
        .cancel);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
      valueListenable: showNotifier,
      builder: (context, b, _) => Center(
            child: Column(children: [
              b
                  ? Deferred()
                  : RaisedButton(
                      onPressed: () => showNotifier.value = true,
                      child: Text("Create Deferred"),
                      color: Colors.red,
                    ),
              b ? DeferredTimerWidget() : SizedBox(),
              Text(status),
            ]),
          ));
}

void main() => runApp(MaterialApp(home: Scaffold(body: App())));
