import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:package_libs/utils/logger_util.dart';

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

  void setSessionInfo(LoginEntity? info) {
    isLogin = true;
    loginInfo = info;
  }

  void clearSessionInfo() {
    isLogin = false;
    uuid = null;
    userName = null;
    lastLoginTime = null;
    sessionId = null;
    loginInfo = null;
  }

  bool isSessionChanged(String? newSessionId) {
    LoggerUtil.log("isSessionChanged oldSessionId=$sessionId newSessionId=$newSessionId");
    return sessionId != newSessionId;
  }

  bool isEmpty() {
    return sessionId?.isEmpty ?? true;
  }
}
