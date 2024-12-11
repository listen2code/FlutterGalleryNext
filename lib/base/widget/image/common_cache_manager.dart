import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CommonCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'CommonCachedImageData';

  static final CommonCacheManager _instance = CommonCacheManager._();

  factory CommonCacheManager() {
    return _instance;
  }

  CommonCacheManager._()
      : super(Config(key,
            stalePeriod: const Duration(days: 30), maxNrOfCacheObjects: 200));
}
