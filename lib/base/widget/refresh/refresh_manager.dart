import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class RefreshManager {
  RefreshManager._private();

  factory RefreshManager.instance() => _instance;
  static final RefreshManager _instance = RefreshManager._private();

  final Header defaultHeader = ClassicHeader(
    mainAxisAlignment: MainAxisAlignment.end,
    noMoreText: ''.tr,
    failedText: ''.tr,
    messageText: ''.tr,
    dragText: "drag",
    armedText: "armed",
    processingText: "processing",
    readyText: "ready",
    processedText: "",
    succeededIcon: const Icon(null),
    showMessage: false,
    processedDuration: Duration.zero,
  );

  final Footer defaultFooter = const ClassicFooter(
    processingText: "processing",
    showMessage: false,
  );
}
