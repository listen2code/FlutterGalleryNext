import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/mvvm/view/base_stateless_page.dart';
import 'package:flutter_gallery_next/base/mvvm/view_mode/view_mode.dart';
import 'package:flutter_gallery_next/base/widget/web_view/inner_web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// [author] yu
///
/// [describe] 共通ウェブビューページ
///
/// [date] 2024/05/20
class WebViewPage<VM extends ViewMode> extends BaseStatelessPage<VM> {
  WebViewPage({super.key});

  /// WebViewの制御
  final WebViewController controller = WebViewController();

  /// タイトル
  @override
  String titleString() {
    return "";
  }

  ///　ナビゲーションバーの右側にあるボタン
  @override
  List<Widget>? appBarActionWidget(BuildContext context) {
    List<Widget> result = [];
    var button = refreshButton();
    if (button != null) {
      result.add(button);
    }
    if (result.isNotEmpty) {
      return result;
    } else {
      return null;
    }
  }

  String getUrl() {
    return "";
  }

  @override
  Widget buildContent(BuildContext context) {
    List<Widget> result = [];
    result.add(webView());
    var control = controlView();
    if (control != null) {
      result.add(control);
    }
    return Stack(
      children: result,
    );
  }

  /// 更新ボタン
  Widget? refreshButton() {
    return IconButton(
      onPressed: () {
        controller.reload();
      },
      icon: const Icon(Icons.refresh_rounded),
    );
  }

  ///　ウェブビューウィジェット
  Widget webView() {
    return InnerWebView(
      urlString: getUrl(),
      webViewController: controller,
      isNeedHeartbeat: isNeedHeartbeatFlg(),
      showLoading: showLoading(),
    );
  }

  /// [describe] ハートビートAPIを呼び出すが
  ///
  /// [returnType] bool
  bool isNeedHeartbeatFlg() {
    return true;
  }

  /// ローディング表示するかどうか
  ///
  bool showLoading() {
    return false;
  }

  /// 戻るボタンと前進ボタン
  Widget? controlView() {
    return Positioned(
      right: 30,
      bottom: 30,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () async {
                if (await controller.canGoBack()) {
                  controller.goBack();
                }
              },
              icon: const Icon(Icons.arrow_back_outlined),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () async {
                if (await controller.canGoForward()) {
                  controller.goForward();
                }
              },
              icon: const Icon(Icons.arrow_forward_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
