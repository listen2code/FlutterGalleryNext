extension StringExtensions on String {
  bool get isVideo {
    return toLowerCase().endsWith(".mp4") ||
        toLowerCase().endsWith(".wav") ||
        toLowerCase().endsWith(".mp3") ||
        toLowerCase().endsWith(".m4a");
  }

  bool get isSvg => toLowerCase().endsWith(".svg");

  bool get flag => this == "1";

  bool isNull(dynamic value) => value == null;

  bool isNum(String value) {
    if (isNull(value)) {
      return false;
    }

    return num.tryParse(value) is num;
  }

  int get stringToInt {
    if (isNum(this)) {
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
