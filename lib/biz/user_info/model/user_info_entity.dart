import 'dart:convert';

import 'package:flutter_gallery_next/generated/json/base/json_field.dart';
import 'package:flutter_gallery_next/generated/json/user_info_entity.g.dart';

export 'package:flutter_gallery_next/generated/json/user_info_entity.g.dart';

@JsonSerializable()
class UserInfoEntity {
  late String name;
  late String age;
  late String address;
  late String phone;
  late String email;

  UserInfoEntity();

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) => $UserInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
