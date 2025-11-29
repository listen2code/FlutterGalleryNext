import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';

class SessionInfo {
  SessionInfo._private();

  static final SessionInfo _instance = SessionInfo._private();

  factory SessionInfo() => _instance;

  String? uuid;
  String? userName;
  String? lastLoginTime;
  bool? isLogin;
  String? sessionId;
  LoginEntity? loginInfo;

  bool isMember() {
    return isLogin ?? false;
  }

  bool isVisitor() {
    return isLogin ?? false;
  }

  void clearSessionInfo() {
    uuid = null;
    userName = null;
    lastLoginTime = null;
    isLogin = false;
    sessionId = null;
    loginInfo = null;
  }

  bool isSessionChanged(String newSessionId) {
    return sessionId != newSessionId;
  }
}
