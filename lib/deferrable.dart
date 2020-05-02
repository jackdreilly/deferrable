import 'package:flutter/widgets.dart';

mixin Deferrable<T extends StatefulWidget> on State<T> {
  bool _isDisposed = false;
  final _deferreds = <Function>[];
  void defer(Function f) => _deferreds.add(f);
  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    _isDisposed = true;
    _deferreds.forEach((f) => f());
    super.dispose();
  }
}
