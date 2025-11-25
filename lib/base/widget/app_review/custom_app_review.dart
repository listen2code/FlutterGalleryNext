import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class CustomAppReview {
  static void requestReview() async {
    debugPrint('requestReview');
    if (await InAppReview.instance.isAvailable()) {
      debugPrint('requestReview isAvailable=true');
      await InAppReview.instance.requestReview();
    }
  }
}
