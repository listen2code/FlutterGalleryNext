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
