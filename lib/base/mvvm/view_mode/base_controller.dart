import 'package:get/get.dart';

abstract class BaseController extends SuperController<String> {
  @override
  void onResumed() {}

  @override
  void onPaused() {}

  @override
  void onInactive() {}

  @override
  void onDetached() {}

  @override
  void onHidden() {}
}
