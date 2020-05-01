# deferrable

```dart
void initState() {
    super.initState();
    _append('time created');
    // Cancel the stream subscription on `dispose()` by calling `defer`
    defer(Stream.periodic(const Duration(seconds: 1))
        .listen((_) => setState(() => date = DateTime.now()))
        .cancel);
  }
```

## Why?

Add operations to perform in `dispose` call of `StatefulWidget` `State`.

Useful when you're creating things in `initState` that need to be disposed of in `dispose`.

Instead of having to store things in private members, and clean up in a different spot in the code, simply call `defer` and this takes care of the rest.

## Example

```dart
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
  }

  @override
  Widget build(BuildContext context) => Text(date.toIso8601String());
}
```

See the example and tests for usage.
