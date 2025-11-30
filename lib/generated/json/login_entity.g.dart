import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:flutter_gallery_next/generated/json/base/json_convert_content.dart';

LoginEntity $LoginEntityFromJson(Map<String, dynamic> json) {
  final LoginEntity loginEntity = LoginEntity();
  final String? userId = jsonConvert.convert<String>(json['userId']);
  if (userId != null) {
    loginEntity.userId = userId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    loginEntity.name = name;
  }
  return loginEntity;
}

Map<String, dynamic> $LoginEntityToJson(LoginEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['userId'] = entity.userId;
  data['name'] = entity.name;
  return data;
}

extension LoginEntityExtension on LoginEntity {
  LoginEntity copyWith({
    String? userId,
    String? name,
  }) {
    return LoginEntity()
      ..userId = userId ?? this.userId
      ..name = name ?? this.name;
  }
}
