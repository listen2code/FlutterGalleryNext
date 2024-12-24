import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:yaml/yaml.dart';

void main() async {
  // 打开 pubspec.lock 文件
  final lockFile = File('pubspec.lock');

  // 读取文件内容
  final content = await lockFile.readAsString();

  // 解析 YAML 格式内容
  final lockData = jsonDecode(jsonEncode(loadYaml(content)));

  // 获取依赖项列表
  final packages = lockData['packages'] as Map<String, dynamic>;

  // 创建 CSV 数据
  List<List<String>> rows = [
    ['Package', 'Version'], // 表头
  ];

  packages.forEach((packageName, packageData) {
    final version = packageData['version'];
    rows.add([packageName, version]);
  });

  // 将数据转换为 CSV 格式
  String csv = const ListToCsvConverter().convert(rows);

  // 保存 CSV 文件
  final outputFile = File('dependencies.csv');
  await outputFile.writeAsString(csv);

  print('依赖项已成功导出到 dependencies.csv');
}
