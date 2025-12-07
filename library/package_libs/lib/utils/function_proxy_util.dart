import 'dart:async';

extension FunctionExt on Function {
  debounce({int milliseconds = 500}) {
    return FunctionProxy(this, milliseconds).run;
  }
}

/// [describe] メソッドプロキシ
///
/// [date] 2024/09/18
class FunctionProxy {
  final int milliseconds;
  static Timer? _timer;

  Function? action;

  FunctionProxy(this.action, this.milliseconds);

  void run() {
    if (_timer == null) {
      action?.call();
      _timer = Timer(Duration(milliseconds: milliseconds), () {
        _timer = null;
      });
    }
  }

  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
