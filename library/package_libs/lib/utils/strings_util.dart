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
}
