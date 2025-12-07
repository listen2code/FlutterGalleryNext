import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtil {
  ImageUtil._private();

  static final ImageUtil _instance = ImageUtil._private();

  factory ImageUtil.instance() => _instance;

  Future<Uint8List?> decodeBase64ToImage(String? imageString) async {
    if (imageString == null) return null;
    try {
      return Future.value(base64Decode(imageString));
    } catch (e) {
      log('decodeBase64ToImage error: $e', type: LoggerType.error);
      return null;
    }
  }

  Future<String> encodeImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      log('encodeImageToBase64 error: $e', type: LoggerType.error);
      return '';
    }
  }

  Future<XFile?> pickImage() async {
    try {
      final XFile? file = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (file != null) {
        String fileExtension = file.path.split('.').last.toLowerCase();
        const allowedExtensions = ['jpg', 'jpeg', 'png', 'heif', 'heic'];

        if (!allowedExtensions.contains(fileExtension)) {
          log("pickImage invalid type", type: LoggerType.error);
          return null;
        }

        final fileSize = await file.length();
        log("pickImage fileSize: $fileSize bytes");
        return file;
      } else {
        log("pickImage no image");
        return null;
      }
    } catch (e) {
      log("pickImage error: $e", type: LoggerType.error);
      return null;
    }
  }

  Future<CroppedFile?> cropImage(XFile file) async {
    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "cropImage Title",
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.grey,
            dimmedLayerColor: Colors.white.withAlpha(128),
            showCropGrid: false,
            cropStyle: CropStyle.circle,
          ),
          IOSUiSettings(
            title: "cropImage Title",
            doneButtonTitle: 'ok',
            cancelButtonTitle: 'cancel',
            minimumAspectRatio: 1.0,
            cropStyle: CropStyle.circle,
          ),
        ],
      );

      if (croppedFile != null) {
        log("cropImage finish $croppedFile");
        return croppedFile;
      } else {
        log("cropImage cancel");
        return null;
      }
    } catch (e) {
      log("cropImage error: $e", type: LoggerType.error);
      return null;
    }
  }

  Future<File?> compressAndSaveImage(File file, String fileName) async {
    try {
      Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 100,
        minHeight: 100,
        quality: 70,
      );

      if (compressedImage != null) {
        File tempFile = await saveTemporaryFile(compressedImage, fileName);
        log("compressAndSaveImage size: ${await tempFile.length()} bytes");
        return tempFile;
      } else {
        log("compressAndSaveImage failed", type: LoggerType.error);
      }
    } catch (e) {
      log("compressAndSaveImage error: $e", type: LoggerType.error);
    }
    return null;
  }

  Future<File> saveTemporaryFile(Uint8List data, String fileName) async {
    String dir = (await getTemporaryDirectory()).path;
    String tempTargetPath = '$dir/$fileName';
    File tempFile = File(tempTargetPath);
    await tempFile.writeAsBytes(data);
    return tempFile;
  }

  Future<void> deleteTemporaryFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        log("deleteTemporaryFile success $filePath");
      }
    } catch (e) {
      log("deleteTemporaryFile error", type: LoggerType.error);
    }
  }
}
