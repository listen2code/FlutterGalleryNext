extension NullableStringExtension on String? {
  /// Returns `true` if the string is either `null` or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension StringExtensions on String {
  bool get isVideo {
    return toLowerCase().endsWith(".mp4") ||
        toLowerCase().endsWith(".wav") ||
        toLowerCase().endsWith(".mp3") ||
        toLowerCase().endsWith(".m4a");
  }

  bool get isSvg => toLowerCase().endsWith(".svg");

  bool get flag => this == "1";

  int? toIntOrNull() => int.tryParse(this);

  double? toDoubleOrNull() => double.tryParse(this);

  bool isNum() {
    return num.tryParse(this) is num;
  }

  /// Examples:
  /// - "007" -> "7"
  /// - "123.0" -> "123"
  /// - "10.50" -> "10.5"
  /// - "0.5" -> "0.5"
  String get cleanZero {
    final number = num.tryParse(this);
    // If it's not a valid number, return the original string.
    if (number == null) {
      return this;
    }
    // If the number has no fractional part, return as integer string.
    if (number % 1 == 0) {
      return number.toInt().toString();
    }
    // Otherwise, return the standard double string representation.
    return number.toString();
  }

  /// Safely truncates a string using runes to prevent splitting multi-byte characters like emoji.
  ///
  /// Examples:
  /// - 'Hello👍'.safeSubstring(0, 6) -> 'Hello👍' (Correctly includes the emoji)
  /// - 'Hello👍'.substring(0, 6) -> 'Hello' (Standard substring corrupts the emoji)
  String safeSubstring(int start, [int? end]) {
    // String.subString
    // 'Hello👍' = [H, e, l, l, o, 👍, 👍]
    // runes.toList()
    // 'Hello👍' = [72, 101, 108, 108, 111, 128077]
    final runeList = runes.toList();

    final realStart = start.clamp(0, runeList.length);
    final realEnd = (end ?? runeList.length).clamp(realStart, runeList.length);

    return String.fromCharCodes(runeList.sublist(realStart, realEnd));
  }

  int get stringToInt {
    if (isNum()) {
      int valueInt = 0;
      double valueDouble = 0;
      valueDouble = double.parse(this);
      valueInt = valueDouble.toInt();
      if (valueInt >= 0) {
        return valueInt;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  double parseDouble(String? value) {
    if (value == null) {
      return 0;
    }
    try {
      return double.tryParse(value) ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
