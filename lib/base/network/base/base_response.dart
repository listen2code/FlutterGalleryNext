import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/generated/json/base/json_convert_content.dart';
import 'package:package_libs/utils/http_util.dart';

class ResponseEntity<T> {
  T? body;
  int? code;
  String? msg;
  String? messageId;
  String? message;

  DateTime? serverTime;

  APIResult result = APIResult.loading;

  void setError({
    int? code,
    String? msg,
    APIResult apiResult = APIResult.networkError,
  }) {
    result = apiResult;
    this.code = code ?? -1;
    this.msg = msg ?? "";
  }

  ResponseEntity();

  factory ResponseEntity.fromJson(Map<String, dynamic> json) => _$BaseEntityFromJson(json);

  factory ResponseEntity.error({int? code, String? msg, APIResult? result}) =>
      _$BaseEntityFromError(msg: msg, code: code, result: result);

  Map<String, dynamic> toJson() => _$BaseEntityToJson(this);
}

ResponseEntity<T> _$BaseEntityFromJson<T>(Map<String, dynamic> json) {
  final ResponseEntity<T> baseEntity = ResponseEntity();
  T? body;
  if (json['body'] != null) {
    body = JsonConvert.fromJsonAsT<T>(json['body']);
  }
  if (body != null) {
    baseEntity.body = body;
  }
  final String? messageId = jsonConvert.convert<String>(json['messageId']);
  if (messageId != null) {
    baseEntity.messageId = messageId;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    baseEntity.message = message;
  }
  final String? result = jsonConvert.convert<String>(json['result']);
  if (result != null) {
    baseEntity.result = APIResultExtension.fromCode(result);
  }
  return baseEntity;
}

ResponseEntity<T> _$BaseEntityFromError<T>({int? code, String? msg, APIResult? result}) {
  final ResponseEntity<T> baseEntity = ResponseEntity();
  if (code != null) {
    baseEntity.code = code;
  }
  if (msg != null) {
    baseEntity.msg = msg;
  }
  if (result != null) {
    baseEntity.result = result;
  }
  return baseEntity;
}

Map<String, dynamic> _$BaseEntityToJson(ResponseEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['body'] = entity.body?.toJson();
  data['messageId'] = entity.messageId;
  data['message'] = entity.message;
  data['result'] = entity.result;
  return data;
}

extension BaseEntityExtension<T> on ResponseEntity<T> {
  ResponseEntity<T> copyWith({
    T? body,
    String? messageId,
    String? message,
    APIResult? result,
  }) {
    return ResponseEntity()
      ..body = body ?? this.body
      ..messageId = messageId ?? this.messageId
      ..message = message ?? this.message
      ..result = result ?? this.result;
  }

  Widget observe(
    final Widget Function(T body) widget, {
    final Widget Function(String? error)? onError,
    final Widget Function(String? error)? onSystemError,
    final Widget Function(String? error)? onSessionTimeout,
    final Widget Function(String? error)? onNetworkError,
    final Widget? onLoading,
    final Widget? onEmpty,
    final bool autoEmpty = false,
  }) {
    return switch (result) {
      APIResult.success =>
        autoEmpty && (T is List) && ((body as List?)?.isEmpty ?? true) ? onEmpty ?? Container(height: 1) : widget(body as T),
      APIResult.loading => onLoading ?? Container(height: 1),
      APIResult.generalError => onError != null ? onError(message) : Container(height: 1),
      APIResult.systemError => onSystemError != null ? onSystemError(message) : Container(height: 1),
      APIResult.sessionTimeout => onSessionTimeout != null ? onSessionTimeout(message) : Container(height: 1),
      APIResult.networkError => onNetworkError != null ? onNetworkError(message) : Container(height: 1),
      APIResult.empty => onEmpty ?? Container(height: 1),
    };
  }
}
