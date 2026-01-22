import 'package:flutter_gallery_next/generated/json/base/json_field.dart';
import 'package:flutter_gallery_next/generated/json/user_info_entity.g.dart';
import 'dart:convert';
export 'package:flutter_gallery_next/generated/json/user_info_entity.g.dart';

@JsonSerializable()
class UserInfoEntity {
  String? id = '';
  String? name = '';
  String? age = '';
  String? address = '';
  String? phone = '';
  String? email = '';

  UserInfoEntity();

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) => $UserInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
