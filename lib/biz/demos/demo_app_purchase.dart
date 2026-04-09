import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// アプリ内課金（in_app_purchase）のデモ画面
///
/// 【重要】このデモを動作させるための事前準備：
/// 1. Android: Google Play Console で商品 ID を登録し、テストユーザーを設定する。
///    AndroidManifest.xml に <uses-permission android:name="com.android.vending.BILLING" /> を追加。
/// 2. iOS: App Store Connect で商品 ID を登録し、課金アイテム（Consumable/Non-Consumable）を作成する。
///    Xcode の 'In-App Purchase' Capability を有効にする。
/// 3. 実機でのテストを推奨（iOS シミュレーターでは動作しません）。
void main() {
  runApp(const MaterialApp(
    home: DemoAppPurchase(),
    debugShowCheckedModeBanner: false,
  ));
}

class DemoAppPurchase extends StatefulWidget {
  const DemoAppPurchase({super.key});

  @override
  State<DemoAppPurchase> createState() => _DemoAppPurchaseState();
}

class _DemoAppPurchaseState extends State<DemoAppPurchase> {
  /// [InAppPurchase.instance]
  /// アプリ内課金のメインエントリポイント。
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  /// [StreamSubscription]
  /// 購入状態の更新を監視するためのサブスクリプション。
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  /// [ProductDetails]
  /// ストアから取得した商品情報のリスト。
  List<ProductDetails> _products = [];

  /// [PurchaseDetails]
  /// 今回のセッションで検証・付与が完了した購入情報のリスト。
  final List<PurchaseDetails> _purchases = [];

  bool _loading = true;
  bool _isAvailable = false;
  String? _errorMessage;

  /// 【設定】ストアで登録したすべてのプロダクトID
  static const Set<String> _productIds = {
    'good_1',
    'subscription_1',
    'subscription_11',
    'subscription_2',
    'subscription_21',
  };

  /// 【設定】消耗品（何度も買えるアイテム）のIDリスト
  /// ここに含まれないIDはすべて非消耗品（またはサブスク）として扱われます。
  static const Set<String> _consumableIds = {
    'good_1',
  };

  @override
  void initState() {
    super.initState();

    /// 1. 購入ストリームの監視を開始
    /// アプリ起動時にすぐ開始するのがベストプラクティスです。
    /// 未完了の購入（保留中）がアプリ再起動時に通知されるためです。
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      debugPrint('Purchase Stream Error: $error');
    });

    initStoreInfo();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// 2. ストア情報の初期化と商品リストの取得
  Future<void> initStoreInfo() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    /// [isAvailable]
    /// デバイスが支払いをサポートしているか、ストアに接続可能かを確認します。
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _loading = false;
        _errorMessage = 'ストアに接続できません。';
      });
      return;
    }

    /// [queryProductDetails]
    /// 指定した ID セットに基づいて、ストアから詳細な商品情報を取得します。
    /// ここで有効な ID が一つも見つからない場合、UI は空になります。
    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_productIds);

    if (productDetailResponse.error != null) {
      setState(() {
        _errorMessage = productDetailResponse.error?.message;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _loading = false;
    });
  }

  /// 3. 購入ステータスが変化した時のリスナー
  /// 購入ボタンを押した後、またはアプリ起動時に未完了の決済がある場合に呼ばれます。
  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      /// [PurchaseStatus.pending]
      /// 決済処理中（ユーザーの承認待ちなど）。ローディングを表示するなどの処理を行います。
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
      } else {
        /// [PurchaseStatus.error]
        /// 決済失敗（キャンセル、カードエラー、通信エラーなど）。
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          /// [PurchaseStatus.purchased] / [PurchaseStatus.restored]
          /// 購入成功、またはリストア（再取得）成功。
          // サーバ検証と付与
          bool deliverSuccess = await _deliverProduct(purchaseDetails);

          if (deliverSuccess) {
            // 検証成功時のみ completePurchase を呼び、トランザクションを終了させる
            if (purchaseDetails.pendingCompletePurchase) {
              // 検証成功、または既に他プラットフォームで処理済みの場合は completePurchase を呼んでキューを消去
              await _inAppPurchase.completePurchase(purchaseDetails);
              debugPrint('Transaction Finished: ${purchaseDetails.productID}');
            }
          } else {
            // 一時的なエラー（タイムアウト等）の場合はリトライを期待して保留
            debugPrint('Delivery Failed: Retry on next launch.');
          }
        }

        /// [pendingCompletePurchase] & [completePurchase]
        /// 【最重要】決済完了をストアに通知します。
        /// これを行わないと、ストア側で「未完了の購入」として残り、
        /// 数日後に自動返金されたり、次の購入ができなくなります。
        // 失敗したトランザクションもキューから消去する必要がある
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      }
    }
  }

  /// 4. 購入処理の開始（消耗品かどうかの自動判別付き）
  void _buyProduct(ProductDetails product) {
    /// [PurchaseParam]
    /// 購入に必要なパラメータ。商品詳細情報をラップします。
    late PurchaseParam purchaseParam;
    purchaseParam = PurchaseParam(productDetails: product);

    /// IDリストに含まれているか、特定の接頭辞を持つ場合は消耗品とみなす
    final bool isConsumable = _consumableIds.contains(product.id) || product.id.startsWith('good_');

    if (isConsumable) {
      // 消耗品として購入（Androidでは自動的にconsumeされる）
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } else {
      // 非消耗品・サブスクリプションとして購入
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  /// サーバ検証ロジック
  Future<bool> _deliverProduct(PurchaseDetails purchaseDetails) async {
    final String productId = purchaseDetails.productID;
    // サーバー検証用のトークン/レシート
    final String? token = purchaseDetails.verificationData.serverVerificationData;

    debugPrint('Verifying $productId with token: ${token?.substring(0, 5)}...');

    try {
      await Future.delayed(const Duration(seconds: 1)); // ネットワーク擬似遅延

      // ここで自社サーバの検証結果を判定
      bool isVerified = true;

      if (isVerified) {
        setState(() {
          if (!_purchases.any((p) => p.productID == productId)) {
            _purchases.add(purchaseDetails);
          }
        });
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 決済エラーのハンドリング
  void _handleError(IAPError error) {
    debugPrint('IAP Error: [${error.code}] ${error.message}');

    // 1. ユーザーによるキャンセルは無視する (iOS: purchase_cancelled, Android: 1)
    if (error.code == 'purchase_cancelled' || error.code == '1' || error.code == 'payment_cancelled') {
      debugPrint('User cancelled the purchase.');
      return;
    }

    String displayMessage = '決済エラーが発生しました。';
    if (error.code == 'payment_not_allowed') {
      displayMessage =
      'このデバイスではアプリ内課金が許可されていません。ペアレンタルコントロールの設定を確認してください。';
    } else if (error.code == 'billing_unavailable') {
      displayMessage = 'ストアサービスが利用できません。アカウントの設定を確認してください。';
    } else if (error.code == '7') {
      // ITEM_ALREADY_OWNED (Android)
      displayMessage = 'この商品は既に所有しています。購入情報を復元してください。';
    }

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('決済エラー'),
            content: Text(displayMessage),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
    );
  }

  void _showPendingUI() {
    debugPrint('Processing...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In App Purchase Demo'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: initStoreInfo),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => _inAppPurchase.restorePurchases(),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (!_isAvailable) return const Center(child: Text('ストアが利用できません'));
    if (_products.isEmpty) return const Center(child: Text('商品が見つかりません'));

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final bool alreadyPurchased = _purchases.any((p) => p.productID == product.id);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(product.id, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(product.description),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: alreadyPurchased ? Colors.grey : Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: alreadyPurchased ? null : () => _buyProduct(product),
              child: Text(alreadyPurchased ? '購入済み' : product.price),
            ),
          ),
        );
      },
    );
  }
}
