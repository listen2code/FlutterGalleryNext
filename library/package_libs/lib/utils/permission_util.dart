import 'package:package_libs/utils/logger_util.dart';
import 'package:permission_handler/permission_handler.dart';

extension PermissionStatusX on PermissionStatus {
  bool get isGrantedOrLimited => isGranted || isLimited;
}

class PermissionUtil {
  PermissionUtil._private();

  static final PermissionUtil _instance = PermissionUtil._private();

  static PermissionUtil get instance => _instance;

  Future<bool> isGranted(Permission permission) async {
    PermissionStatus status = await permission.status;
    return status.isGrantedOrLimited;
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  Future<bool> checkPermission(Permission permission) async {
    try {
      if (await isGranted(permission)) {
        return true;
      }
      final status = await requestPermission(permission);
      if (status.isGrantedOrLimited) {
        return true;
      } else {
        openAppSettings();
        return false;
      }
    } catch (e, t) {
      LoggerUtil.error("checkPermission error", error: e, stackTrace: t);
      return false;
    }
  }

  Future<bool> checkCamera() async {
    return await checkPermission(Permission.camera);
  }
}
