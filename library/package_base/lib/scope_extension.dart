extension ScopeExtension<T> on T {
  /// Calls the [block] with `this` and returns its result.
  /// Example: `nullableObject?.let((it) => print(it));`
  R let<R>(R Function(T) block) {
    return block(this);
  }

  /// Calls the [block] with `this` and returns `this`.
  /// Example: `myObject.also((it) => logger.log(it));`
  T also(void Function(T) block) {
    block(this);
    return this;
  }

  /// Returns `this` if it satisfies the [predicate], or `null` otherwise.
  /// Example: `final positive = number.takeIf((it) => it > 0);`
  T? takeIf(bool Function(T) predicate) {
    return predicate(this) ? this : null;
  }

  /// Returns `this` if it does not satisfy the [predicate], or `null` otherwise.
  /// Example: `final odd = number.takeUnless((it) => it.isEven);`
  T? takeUnless(bool Function(T) predicate) {
    return !predicate(this) ? this : null;
  }
}

extension BoolExtension on bool {
  /// Executes the [action] if `this` is `true`.
  /// Example: `isSuccess.then(() => print('Success!'));`
  void then(void Function() action) {
    if (this) action();
  }

  /// Executes the [action] if `this` is `false`.
  /// Example: `isFailure.otherwise(() => print('Failure!'));`
  void otherwise(void Function() action) {
    if (!this) action();
  }
}

extension NullableStringExtension on String? {
  /// Returns `true` if the string is either `null` or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension StringParsingExtension on String {
  /// Parses the string as an [int] or returns `null` if it fails.
  int? toIntOrNull() => int.tryParse(this);

  /// Parses the string as a [double] or returns `null` if it fails.
  double? toDoubleOrNull() => double.tryParse(this);
}
