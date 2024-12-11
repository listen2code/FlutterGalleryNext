extension StringExtensions on String {
  bool get isVideo {
    return toLowerCase().endsWith(".mp4") ||
        toLowerCase().endsWith(".wav") ||
        toLowerCase().endsWith(".mp3") ||
        toLowerCase().endsWith(".m4a");
  }

  bool get isSvg {
    return toLowerCase().endsWith(".svg");
  }

  bool isNull(dynamic value) => value == null;

  bool isNum(String value) {
    if (isNull(value)) {
      return false;
    }

    return num.tryParse(value) is num;
  }

  int get toInt {
    if (isNum(this)) {
      int value = int.parse(this);
      return value;
    } else {
      return -1;
    }
  }
}
