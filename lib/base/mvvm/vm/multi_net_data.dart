import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:package_base/scope_extension.dart';
import 'package:package_libs/utils/http_util.dart';

// todo fix net[0]
class MultiNetData {
  int _size = 0;
  Object? _netData;
  Object? _errorData;

  get $netData => _netData;

  set _$netData(values) {
    if (values is List<ResponseEntity>) {
      _size = values.length;
      _errorData = values.firstWhereOrNull((it) {
        return it.result == APIResult.generalError ||
            it.result == APIResult.systemError ||
            it.result == APIResult.sessionTimeout ||
            it.result == APIResult.networkError;
      });
    } else if (values is ResponseEntity) {
      _size = 1;
      _errorData = values.let((it) => (it.result == APIResult.generalError ||
              it.result == APIResult.systemError ||
              it.result == APIResult.sessionTimeout ||
              it.result == APIResult.networkError)
          ? it
          : null);
    }
    _netData = values;
  }

  operator [](int index) {
    if (index > _size - 1 || $netData == null) {
      return null;
    } else {
      if (index == 0 && _size == 1) {
        return $netData;
      }
      return $netData[index];
    }
  }

  get errorData => _errorData;

  MultiNetData(this._netData) {
    _$netData = _netData;
  }
}
