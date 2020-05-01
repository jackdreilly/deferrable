import 'package:flutter/widgets.dart';

mixin Deferrable<T extends StatefulWidget> on State<T> {
  final _deferreds = <Function>[];
  void defer(Function f) => _deferreds.add(f);

  @override
  void dispose() {
    _deferreds.forEach((f) => f());
    super.dispose();
  }
}
