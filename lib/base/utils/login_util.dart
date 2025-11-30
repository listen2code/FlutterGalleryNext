import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:package_libs/utils/logger_util.dart';

class LoginUtil {
  static String getSSOUrl({required final String homeId, required final String scid, final Map<String, String>? paramMap}) {
    final String homeIdStr = '&homeId=$homeId';
    final String scidStr = '&scid=$scid';
    String paramStr = '';
    if (paramMap != null) {
      for (MapEntry entry in paramMap.entries) {
        paramStr += '&${entry.key}=${entry.value}';
      }
    }
    return getDirectSmtLoginUrl("$homeIdStr$paramStr$scidStr");
  }

  static String getVisitorUrl({required final String path, required final String scid, final Map<String, String>? paramMap}) {
    final String domainSmt = dotenv.env['DOMAIN_SMT'] ?? '';
    final String scidStr = '?scid=$scid';
    String paramStr = '';
    if (paramMap != null) {
      for (MapEntry entry in paramMap.entries) {
        paramStr += '&${entry.key}=${entry.value}';
      }
    }
    return '$domainSmt$path$scidStr$paramStr';
  }

  static String getDirectLoginUrl(String param) {
    var directLoginUrl = dotenv.env['DIRECT_URL'];
    var directKey = getDirectKey();
    var result = "$directLoginUrl$directKey$param";
    log(result, type: LoggerType.easy);
    return result;
  }

  static String getDirectSmtLoginUrl(String param) {
    var directLoginUrl = dotenv.env['DIRECT_SMT_URL'];
    var directKey = getDirectKey();
    var result = "$directLoginUrl$directKey$param";
    log(result, type: LoggerType.easy);
    return result;
  }

  static String getDirectKey() {
    var key = "sbxf4tuvw42rs7vzlubwkxz5z9";
    var loginId = SessionInfo().loginInfo?.userId ?? "";
    if (loginId.isEmpty) {
      return "";
    }
    var name = SessionInfo().loginInfo?.name ?? "";
    if (loginId.isEmpty) {
      return "";
    }
    var random = Random();
    // 0~65535のrandom数字作成
    var ranNum = random.nextInt(1 << 16);
    var ranNumHex = ranNum.toRadixString(16).padLeft(4, '0');
    log(ranNumHex, type: LoggerType.easy);
    var list = [loginId, name, ranNumHex, key];
    log(list, type: LoggerType.easy);
    var bytes = utf8.encode(list.join());
    var digest = sha1.convert(bytes).toString();
    log(digest, type: LoggerType.easy);
    var revLoginId = "${loginId.substring(4, 8)}${loginId.substring(0, 4)}";
    log(revLoginId, type: LoggerType.easy);
    var resultList = [];
    for (var code in revLoginId.codeUnits) {
      resultList.add(code.toRadixString(16).padLeft(2, '0'));
    }
    resultList.add(ranNumHex);
    resultList.add(digest);
    log(resultList, type: LoggerType.easy);
    return resultList.join();
  }

  static String getLoginPageRoute() {
    // todo
    // if (isCcWebMode()) {
    //   return Routes.ccwebLogin;
    // } else {
    //   return Routes.loginTop;
    // }
    return "";
  }

  static Future<bool> isAutoLogin() async {
    // var local = await ProfileUtil().loadLoginSettingInfo();
    // if ((local.autoLogin ?? false)) {
    //   return true;
    // } else {
    //   return false;
    // }
    return false;
  }
}
