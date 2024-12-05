
///テーマのタイプ
enum ThemeType {
  themeWhite(1),
  themeBlack(2),
  themeAuto(0);

  final int key;
  const ThemeType(this.key);
}