// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deferrable/deferrable.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

var _x = false;

class _TestWidgetState extends State<TestWidget> with Deferrable {
  @override
  void initState() {
    super.initState();
    defer(() => _x = true);
  }

  @override
  Widget build(BuildContext context) => Container();
}

void main() {
  testWidgets('Test dispose defer', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TestWidget());
    expect(_x, isFalse);
    await tester.pumpWidget(Container());
    expect(_x, isTrue);
  });
}
