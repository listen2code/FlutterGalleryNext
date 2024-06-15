class SessionInfo {
  SessionInfo._private();

  static final SessionInfo _instance = SessionInfo._private();

  factory SessionInfo() => _instance;

  String? uuid;
  String? userName;
  String? lastLoginTime;
  bool? isLogin;

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
  }
}
