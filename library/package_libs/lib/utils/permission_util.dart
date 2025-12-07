import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  PermissionUtil._private();

  static final PermissionUtil _instance = PermissionUtil._private();

  factory PermissionUtil.instance() => _instance;

  Future<bool> isGranted(Permission permission) async {
    PermissionStatus status = await permission.status;
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        return false;
      default:
        return false;
    }
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }

  Future<bool> checkCamera() async {
    try {
      if (await isGranted(Permission.camera) == false) {
        final status = await requestPermission(Permission.camera);
        if (status != PermissionStatus.granted && status != PermissionStatus.limited) {
          openAppSettings();
          return false;
        }
        return true;
      }
    } catch (e, t) {
      debugPrint("checkCamera error=$e stack=$t");
    }
    return false;
  }
}
