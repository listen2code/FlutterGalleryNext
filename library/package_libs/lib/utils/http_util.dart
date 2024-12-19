class HttpUtil {
  static const int http200 = 200;
  static const String noInternetConnection = "No Internet connection";

  static bool isSuccess(int? statusCode) {
    if (statusCode == http200) {
      return true;
    } else {
      return false;
    }
  }
}

enum APIResult {
  success,
  loading,
  empty,
  generalError,
  systemError,
  sessionTimeout,
  networkError,
}

extension APIResultExtension on APIResult {
  static const Map<APIResult, String> _codeMap = {
    APIResult.loading: "-1",
    APIResult.success: "0",
    APIResult.generalError: "1",
    APIResult.systemError: "2",
    APIResult.sessionTimeout: "3",
    APIResult.networkError: "98",
    APIResult.empty: "99",
  };

  static final Map<APIResult, String> _nameMap = {
    APIResult.loading: "loading",
    APIResult.success: "successful",
    APIResult.generalError: "generalError",
    APIResult.systemError: "systemError",
    APIResult.sessionTimeout: "sessionTimeout",
    APIResult.networkError: "networkError",
    APIResult.empty: "blank",
  };

  String? get code => _codeMap[this];

  String? get name => _nameMap[this];

  static APIResult fromCode(String code) {
    APIResult result = APIResult.empty;
    _codeMap.forEach((key, value) {
      if (value == code) {
        result = key;
      }
    });
    return result;
  }

  static APIResult fromName(String name) {
    APIResult result = APIResult.empty;
    _nameMap.forEach((key, value) {
      if (value == name) {
        result = key;
      }
    });
    return result;
  }
}
