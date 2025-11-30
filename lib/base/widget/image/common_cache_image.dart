import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';
import 'package:flutter_gallery_next/base/widget/image/common_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_base/strings_util.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/proxy/proxy_util.dart';

class CommonCacheImage extends StatelessWidget {
  final String imageUrl;

  final double? width;

  final double? height;

  final int? memCacheWidth;

  final int? memCacheHeight;

  final int? maxWidthDiskCache;

  final int? maxHeightDiskCache;

  final Widget Function(BuildContext context, String url)? onLoading;

  final Widget Function(BuildContext context, String url, Object error)? onError;

  final BaseCacheManager? cacheManager;

  final BoxFit? fit;

  final Color? color;

  final BlendMode? colorBlendMode;

  final ValueChanged<({int width, int height})>? sizeCallBack;

  const CommonCacheImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.cacheManager,
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.onLoading,
    this.onError,
    this.fit,
    this.color,
    this.colorBlendMode,
    this.sizeCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProxyUtil.instance().findProxyAsync(Uri.parse(imageUrl)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _loadImage();
        }
        return _initLoading(context, imageUrl);
      },
    );
  }

  Widget _loadImage() {
    if (imageUrl.isSvg == true) {
      return SvgPicture.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        placeholderBuilder: (context) => _initLoading(context, imageUrl),
      );
    }
    return CachedNetworkImage(
      cacheManager: cacheManager ?? CommonCacheManager(),
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      placeholder: (context, url) => _initLoading(context, url),
      errorWidget: (context, url, error) => _initError(context, url, error),
      imageBuilder: sizeCallBack == null
          ? null
          : (context, imageProvider) {
              imageProvider.resolve(const ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, _) {
                sizeCallBack?.call(
                  (width: info.image.width, height: info.image.height),
                );
              }));
              return Image(image: imageProvider, width: width, height: height, fit: fit, color: color);
            },
      errorListener: (e) {
        if (e is SocketException) {
          LoggerUtil.error(
            'CommonCachedImage SocketException: address=${e.address} and message=${e.message}, imageUrl=$imageUrl',
          );
        } else {
          LoggerUtil.error(
            'CommonCachedImage Exception: ${e.toString()}, imageUrl=$imageUrl',
          );
        }
      },
    );
    ;
  }

  Widget _initLoading(BuildContext context, String url) {
    if (null == onLoading) {
      return SizedBox(height: height, width: width, child: ColoredBox(color: ThemeColors.grey200));
    } else {
      return onLoading!(context, url);
    }
  }

  Widget _initError(BuildContext context, String url, Object error) {
    if (null == onError) {
      return SizedBox(height: height, width: width, child: ColoredBox(color: ThemeColors.grey200));
    } else {
      return onError!(context, url, error);
    }
  }
}
