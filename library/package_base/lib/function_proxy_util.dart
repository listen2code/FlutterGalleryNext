import 'dart:async';

final _functionTimers = <Function, Timer>{};

extension FunctionExt on Function {
  /// Creates a throttled version of the function that runs the function at most
  /// once in the given `duration`.
  ///
  /// The function is executed immediately on the first call (leading-edge).
  /// Subsequent calls within the duration are ignored.
  ///
  /// This can be used directly in an event handler, for example:
  /// `onPressed: myAction.throttle()`
  throttle({int milliseconds = 500}) {
    return () {
      // Check if a timer is active for this function.
      if (_functionTimers[this] == null) {
        // If no timer, execute the function immediately.
        this();

        // Start a timer. During this time, calls will be ignored.
        _functionTimers[this] = Timer(Duration(milliseconds: milliseconds), () {
          // When the timer completes, remove it.
          _functionTimers.remove(this);
        });
      }
    };
  }

  /// Creates a debounced version of the function that delays its execution
  /// until after the given `duration` has elapsed since the last time it was called.
  ///
  /// This is useful for delaying an action until a user has stopped triggering
  /// the event (e.g., waiting for a user to stop typing in a search field).
  ///
  /// This can be used directly in an event handler, for example:
  /// `onChanged: (text) => mySearchAction.debounce()`, although for functions
  /// with arguments, you may need a more specific implementation.
  debounce({int milliseconds = 500}) {
    return () {
      // If a timer is already active, cancel it.
      _functionTimers[this]?.cancel();

      // Start a new timer.
      _functionTimers[this] = Timer(Duration(milliseconds: milliseconds), () {
        // When the timer completes, execute the function and remove the timer.
        this();
        _functionTimers.remove(this);
      });
    };
  }

  /// Cancels any pending debounced or throttled execution for this function.
  void cancelTimer() {
    _functionTimers[this]?.cancel();
    _functionTimers.remove(this);
  }
}
