import 'dart:async';
import 'dart:io';

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
  /// アプリ内課金のメインエントリポイント（シングルトン）。
  /// 全てのストア操作（商品取得、購入、リストア）はこのインスタンスを通じて行います。
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  /// [StreamSubscription]
  /// 購入状態の更新を監視するためのサブスクリプション。
  /// アプリ起動中はずっと監視し、dispose 時に必ず cancel する必要があります。
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  /// [ProductDetails]
  /// ストア（App Store/Google Play）から取得した「商品情報」のリスト。
  /// タイトル、説明、価格（通貨記号付き）などが含まれます。
  List<ProductDetails> _products = [];

  /// [PurchaseDetails]
  /// 過去の購入履歴や現在の購入状態を保持するオブジェクト。
  List<PurchaseDetails> _purchases = [];

  /// 読み込み中フラグ
  bool _loading = true;

  /// ストアが利用可能かどうか（決済権限やストアの有効性）
  bool _isAvailable = false;

  /// エラーメッセージ保持用
  String? _errorMessage;

  /// 【編集が必要】実際にストアで登録したプロダクトIDを指定してください。
  /// ここが間違っていると商品は表示されません。
  static const Set<String> _productIds = {
    'subscription_1', // サブスクリプション例
    'subscription_2',
    'good_1', // 消耗品例
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
        _errorMessage = 'ストアに接続できません。通信環境やデバイスの設定を確認してください。';
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

    if (productDetailResponse.notFoundIDs.isNotEmpty) {
      debugPrint('Warning: IDs not found: ${productDetailResponse.notFoundIDs}');
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _loading = false;
    });
  }

  /// 3. 購入ステータスが変化した時のリスナー
  /// 購入ボタンを押した後、またはアプリ起動時に未完了の決済がある場合に呼ばれます。
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
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
        }

        /// [PurchaseStatus.purchased] / [PurchaseStatus.restored]
        /// 購入成功、またはリストア（再取得）成功。
        else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _deliverProduct(purchaseDetails);
        }

        /// [pendingCompletePurchase] & [completePurchase]
        /// 【最重要】決済完了をストアに通知します。
        /// これを行わないと、ストア側で「未完了の購入」として残り、
        /// 数日後に自動返金されたり、次の購入ができなくなります。
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// 4. 購入処理の開始（ボタン押下時）
  void _buyProduct(ProductDetails product) {
    /// [PurchaseParam]
    /// 購入に必要なパラメータ。商品詳細情報をラップします。
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      // Android 特有の追加パラメータが必要な場合はここで設定
      purchaseParam = PurchaseParam(productDetails: product);
    } else {
      // iOS 特有の追加パラメータ
      purchaseParam = PurchaseParam(productDetails: product);
    }

    /// [buyConsumable] / [buyNonConsumable]
    /// - Consumable (消耗品): 何回でも買えるもの（コイン、石など）。
    /// - Non-Consumable (非消耗品): 一回買えば永久に有効なもの（広告削除、機能解放）。
    if (product.id == 'good_1') {
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } else {
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  /// 商品の付与処理
  void _deliverProduct(PurchaseDetails purchaseDetails) {
    debugPrint('Product Delivered: ${purchaseDetails.productID}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('購入が完了しました: ${purchaseDetails.productID}')),
    );
  }

  void _handleError(IAPError error) {
    debugPrint('Purchase Error: ${error.message} (Code: ${error.code})');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('エラーが発生しました: ${error.message}')),
    );
  }

  void _showPendingUI() {
    debugPrint('Purchase Pending...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In App Purchase Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: initStoreInfo,
            tooltip: '再読み込み',
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              /// [restorePurchases]
              /// iOS で必須の機能。過去の非消耗品の購入履歴を復元します。
              _inAppPurchase.restorePurchases();
            },
            tooltip: '購入情報の復元',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('ストアから商品情報を取得中...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: initStoreInfo, child: const Text('リトライ')),
            ],
          ),
        ),
      );
    }

    if (!_isAvailable) {
      return const Center(child: Text('このデバイスでは決済が利用できません。'));
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('表示できる商品がありません。'),
            const SizedBox(height: 8),
            const Text(
              '注: ストアコンソールで設定した ID と\nコード内の ID が一致しているか確認してください。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('現在の検索対象 ID: $_productIds', style: const TextStyle(fontSize: 10)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: initStoreInfo, child: const Text('再読み込み')),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(product.id, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(product.currencyCode),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _buyProduct(product),
              child: Text(product.price), // ストアで設定された通貨で表示されます
            ),
          ),
        );
      },
    );
  }
}
