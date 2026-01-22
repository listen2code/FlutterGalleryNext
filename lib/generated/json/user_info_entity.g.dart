import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';
import 'package:flutter_gallery_next/generated/json/base/json_convert_content.dart';

UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
  final UserInfoEntity userInfoEntity = UserInfoEntity();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    userInfoEntity.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    userInfoEntity.name = name;
  }
  final String? age = jsonConvert.convert<String>(json['age']);
  if (age != null) {
    userInfoEntity.age = age;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    userInfoEntity.address = address;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userInfoEntity.phone = phone;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    userInfoEntity.email = email;
  }
  return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['age'] = entity.age;
  data['address'] = entity.address;
  data['phone'] = entity.phone;
  data['email'] = entity.email;
  return data;
}

extension UserInfoEntityExtension on UserInfoEntity {
  UserInfoEntity copyWith({
    String? id,
    String? name,
    String? age,
    String? address,
    String? phone,
    String? email,
  }) {
    return UserInfoEntity()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..age = age ?? this.age
      ..address = address ?? this.address
      ..phone = phone ?? this.phone
      ..email = email ?? this.email;
  }
}
