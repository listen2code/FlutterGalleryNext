import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

class AppLinksUtil {
  static final AppLinksUtil _instance = AppLinksUtil._internal();

  factory AppLinksUtil() {
    return _instance;
  }

  AppLinksUtil._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  final _uriStreamController = StreamController<Uri>.broadcast();

  Stream<Uri> get uriLinkStream => _uriStreamController.stream;

  /// Initializes the app link listener.
  Future<void> init() async {
    if (_linkSubscription != null) {
      debugPrint('AppLinksUtil is already initialized.');
      return;
    }

    // Listen for incoming links when the app is already running.
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('Received new URI through stream: $uri');
        _uriStreamController.add(uri);
      },
      onError: (err) {
        debugPrint('Error listening to app links: $err');
      },
    );

    // Handle the initial link that the app was opened with.
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('Received initial URI: $initialUri');
        _uriStreamController.add(initialUri);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _uriStreamController.close();
  }
}
