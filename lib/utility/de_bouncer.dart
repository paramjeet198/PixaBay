import 'dart:async';

typedef EasyDebounceCallBack = void Function();

class EasyDebounce {
  static final _debounceMap = <String, Timer>{};

  static void debounce(
      {required String tag,
      required Duration duration,
      required EasyDebounceCallBack callBack}) {

    if (_debounceMap.containsKey(tag)) cancel(tag: tag);

    _debounceMap[tag] = Timer(duration, callBack);
  }


  /// Cancels any active debounce operation with the given [tag].
  static void cancel({required String tag}) {
    _debounceMap[tag]?.cancel();
    _debounceMap.remove(tag);
  }

  /// Cancels all active debouncers.
  static void cancelAll() {
    for (final timer in _debounceMap.values) {
      timer.cancel();
    }
    _debounceMap.clear();
  }

  /// Returns the number of active debouncers.
  static int count() {
    return _debounceMap.length;
  }

  @override
  String toString() {
    return 'EasyDebounce{${_debounceMap.entries}}';
  }
}
