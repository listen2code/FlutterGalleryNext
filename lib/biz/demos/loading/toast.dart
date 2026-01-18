import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/base/global_navigation.dart';

class Toast {
  static void show(String message) {
    final safeContext = GlobalNavigation.navigatorKey.currentContext!;

    final overlayState = Overlay.of(safeContext);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (childContext) {
        final size = MediaQuery.of(safeContext).size;

        return Positioned(
          top: size.height * 0.8,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    // 2. Switched to withAlpha to avoid deprecation warnings
                    color: Colors.black.withAlpha(180),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);

    // 3. Auto-remove after 2 seconds with safety check
    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
