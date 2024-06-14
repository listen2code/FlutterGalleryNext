import 'package:flutter_gallery_next/generated/json/base/json_field.dart';
import 'package:flutter_gallery_next/generated/json/login_entity.g.dart';
import 'dart:convert';
export 'package:flutter_gallery_next/generated/json/login_entity.g.dart';

@JsonSerializable()
class LoginEntity {
	String? id = '';
	String? name = '';

	LoginEntity();

	factory LoginEntity.fromJson(Map<String, dynamic> json) => $LoginEntityFromJson(json);

	Map<String, dynamic> toJson() => $LoginEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}