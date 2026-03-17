import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// 日本語の五十音順インデックスリストのデモ
void main() {
  runApp(const MaterialApp(home: JapaneseIndexingDemo(), debugShowCheckedModeBanner: false));
}

/// 連絡先モデルクラス
class Contact {
  final String name; // 表示名
  final String reading; // 読み仮名（ソートおよびインデックス用）

  const Contact({required this.name, required this.reading});
}

/// 1. 日本語インデックスユーティリティ
/// 読み仮名から対応する五十音の「行」を判定する機能を提供します。
class JapaneseIndexUtil {
  /// インデックスバーに表示する行のリスト
  static const List<String> indexList = ["あ", "か", "さ", "た", "な", "は", "ま", "や", "ら", "わ", "#"];

  /// 読み仮名から対応する五十音の「行」を返す
  static String getRowTag(String phonetic) {
    if (phonetic.isEmpty) return "#";
    // 最初の文字を取得
    String firstChar = phonetic.substring(0, 1);

    // 各行に対応する文字のマッピング
    // 清音、濁音、半濁音、およびカタカナを同じ「行」として扱います。
    const rowMap = {
      'あ': ['あ', 'い', 'う', 'え', 'お', 'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', 'ア', 'イ', 'ウ', 'エ', 'オ'],
      'か': ['か', 'き', 'く', 'け', 'こ', 'が', 'ぎ', 'ぐ', 'げ', 'ご', 'カ', 'キ', 'ク', 'ケ', 'コ'],
      'さ': ['さ', 'し', 'す', 'せ', 'そ', 'ざ', 'じ', 'ず', 'ぜ', 'ぞ', 'サ', 'シ', 'ス', 'セ', 'ソ'],
      'た': ['た', 'ち', 'つ', 'て', 'と', 'だ', 'ぢ', 'づ', 'で', 'ど', 'タ', 'チ', 'ツ', 'テ', 'ト'],
      'な': ['な', 'に', 'ぬ', 'ね', 'の', 'ナ', 'ニ', 'ヌ', 'ネ', 'ノ'],
      'は': ['は', 'ひ', 'ふ', 'へ', 'ほ', 'ば', 'び', 'ぶ', 'べ', 'ぼ', 'ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ'],
      'ま': ['ま', 'み', 'む', 'め', 'も', 'マ', 'ミ', 'ム', 'メ', 'モ'],
      'や': ['や', 'ゆ', 'よ', 'ゃ', 'ゅ', 'ょ', 'ヤ', 'ユ', 'ヨ'],
      'ら': ['ら', 'り', 'る', 'れ', 'ろ', 'ラ', 'リ', 'ル', 'レ', 'ロ'],
      'わ': ['わ', 'を', 'ん', 'ワ', 'ヲ', 'ン'],
    };

    for (var entry in rowMap.entries) {
      if (entry.value.contains(firstChar)) return entry.key;
    }
    return "#";
  }
}

/// 2. 汎用的な日本語インデックスリストコンポーネント
/// 任意のデータ型 T に対して、五十音順のインデックスナビゲーションを提供します。
class JapaneseIndexListView<T> extends StatefulWidget {
  /// 表示するデータのリスト
  final List<T> data;

  /// データから読み仮名を取得するための関数
  final String Function(T) phoneticProvider;

  /// 各アイテムのウィジェットを構築する関数
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// グループヘッダーを構築するオプション関数
  final Widget Function(BuildContext context, String tag)? headerBuilder;

  /// インデックスバーの各アイテムの高さ
  final double indexItemHeight;

  /// 触覚フィードバック（バイブレーション）を有効にするかどうか
  final bool enableHapticFeedback;

  const JapaneseIndexListView({
    super.key,
    required this.data,
    required this.phoneticProvider,
    required this.itemBuilder,
    this.headerBuilder,
    this.indexItemHeight = 22.0,
    this.enableHapticFeedback = false,
  });

  @override
  State<JapaneseIndexListView<T>> createState() => _JapaneseIndexListViewState<T>();
}

class _JapaneseIndexListViewState<T> extends State<JapaneseIndexListView<T>> {
  /// リストのスクロール制御用
  final ItemScrollController _scrollController = ItemScrollController();

  /// 現在の表示位置を監視するためのリスナー
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  /// 各「行」タグとその開始インデックスのマップ
  final Map<String, int> _tagMap = {};

  /// ソート済みのデータリスト
  late List<T> _sortedData;

  /// 現在選択されている（またはタッチされている）タグ
  String _activeTag = "";

  /// 中央のオーバーレイを表示するかどうか
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _prepareData();
  }

  @override
  void didUpdateWidget(JapaneseIndexListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // データが変更された場合に再ソートとインデックスの再構築を行う
    if (oldWidget.data != widget.data) _prepareData();
  }

  /// データのソートとインデックスマップの作成
  void _prepareData() {
    _sortedData = List.from(widget.data);
    _tagMap.clear();

    // 読み仮名順にソート
    _sortedData.sort((a, b) {
      return widget.phoneticProvider(a).compareTo(widget.phoneticProvider(b));
    });

    // 各行の開始位置をマップに保存
    for (int i = 0; i < _sortedData.length; i++) {
      String tag = JapaneseIndexUtil.getRowTag(widget.phoneticProvider(_sortedData[i]));
      if (!_tagMap.containsKey(tag)) _tagMap[tag] = i;
    }
  }

  /// インデックスバーがタッチまたはスライドされた際の処理
  void _onIndexTouch(String tag) {
    if (_tagMap.containsKey(tag)) {
      final int targetIndex = _tagMap[tag]!;

      // 無駄なスクロール（ガタつき）を防ぐための判定ロジック
      bool shouldJump = true;
      final positions = _itemPositionsListener.itemPositions.value;

      if (positions.isNotEmpty) {
        // ターゲットとなるアイテムの現在の表示状態を確認
        final targetPos = positions.where((p) => p.index == targetIndex).toList();
        if (targetPos.isNotEmpty) {
          final item = targetPos.first;
          // すでにターゲットが最上部にある場合はジャンプ不要
          if (item.itemLeadingEdge == 0) {
            shouldJump = false;
          } else {
            // リストが最下部まで到達しているか確認
            final lastVisibleItem = positions.reduce((a, b) => a.index > b.index ? a : b);
            if (lastVisibleItem.index == _sortedData.length - 1 && lastVisibleItem.itemTrailingEdge <= 1.0) {
              // すでにリストの末尾が表示されており、ターゲットも画面内にある場合は
              // 無理にスクロールさせない（不自然な跳ね返りを防ぐ）
              shouldJump = false;
            }
          }
        }
      }

      // 状態に変更がない場合は処理をスキップ（フラッシュ防止）
      if (_activeTag == tag && _showOverlay && !shouldJump) return;

      // 必要に応じてターゲットインデックスへジャンプ
      if (shouldJump) {
        _scrollController.jumpTo(index: targetIndex);
      }

      // 設定に基づいて触覚フィードバックを実行
      if (widget.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }

      setState(() {
        _activeTag = tag;
        _showOverlay = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // メインの連絡先リスト
        ScrollablePositionedList.builder(
          itemCount: _sortedData.length,
          itemScrollController: _scrollController,
          itemPositionsListener: _itemPositionsListener,
          itemBuilder: (context, index) {
            final item = _sortedData[index];
            final String phonetic = widget.phoneticProvider(item);
            final String tag = JapaneseIndexUtil.getRowTag(phonetic);

            // 前のアイテムと「行」が異なる場合にのみヘッダーを表示
            final bool isFirstInGroup = index == 0 ||
                JapaneseIndexUtil.getRowTag(widget.phoneticProvider(_sortedData[index - 1])) != tag;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFirstInGroup) widget.headerBuilder?.call(context, tag) ?? _defaultHeader(tag),
                widget.itemBuilder(context, item),
              ],
            );
          },
        ),
        // 右側のインデックスバー（ナビゲーション）
        Align(
          alignment: Alignment.centerRight,
          child: _IndexBar(
            onTouch: _onIndexTouch,
            onTouchEnd: () => setState(() => _showOverlay = false),
            tagMap: _tagMap,
            itemHeight: widget.indexItemHeight,
          ),
        ),
        // タッチ操作中に中央に表示される大きなタグプレビュー
        if (_showOverlay) _buildCenterOverlay(),
      ],
    );
  }

  /// デフォルトのグループヘッダーウィジェット
  Widget _defaultHeader(String tag) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey[100],
        child: Text(
          tag,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
      );

  /// 中央のプレビュー用オーバーレイウィジェット
  Widget _buildCenterOverlay() => Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
          alignment: Alignment.center,
          child: Text(
            _activeTag,
            style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
}

/// 3. インデックスバーコンポーネント
/// ユーザーのドラッグやタップ操作を検知し、タグの切り替えを通知します。
class _IndexBar extends StatelessWidget {
  final Function(String) onTouch;
  final VoidCallback onTouchEnd;
  final Map<String, int> tagMap;
  final double itemHeight;

  const _IndexBar({
    required this.onTouch,
    required this.onTouchEnd,
    required this.tagMap,
    required this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // タッチ位置からどのタグの上に指があるかを計算
        int index = (details.localPosition.dy / itemHeight).floor();
        if (index >= 0 && index < JapaneseIndexUtil.indexList.length) {
          onTouch(JapaneseIndexUtil.indexList[index]);
        }
      },
      onVerticalDragEnd: (_) => onTouchEnd(),
      onTapDown: (details) {
        int index = (details.localPosition.dy / itemHeight).floor();
        if (index >= 0 && index < JapaneseIndexUtil.indexList.length) {
          onTouch(JapaneseIndexUtil.indexList[index]);
        }
      },
      onTapUp: (_) => onTouchEnd(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.transparent, // タッチ判定領域を確保するために必要
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: JapaneseIndexUtil.indexList.map((tag) {
            final bool hasData = tagMap.containsKey(tag);
            return SizedBox(
              height: itemHeight,
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  // データが存在するタグは強調表示、存在しないものは薄く表示
                  color: hasData ? Colors.blueAccent : Colors.grey[300],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// 4. 利用例（呼び出し側ウィジェット）
class JapaneseIndexingDemo extends StatelessWidget {
  const JapaneseIndexingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // デモ用のデータリスト
    final List<Contact> contacts = [
      const Contact(name: "安倍 晋三", reading: "あべ しんぞう"),
      const Contact(name: "伊藤 博文", reading: "いとう ひろぶみ"),
      const Contact(name: "上野 樹里", reading: "うえの じゅり"),
      const Contact(name: "加藤 剛", reading: "かとう ごう"),
      const Contact(name: "木村 拓哉", reading: "きむら たくや"),
      const Contact(name: "佐藤 健", reading: "さとう たける"),
      const Contact(name: "鈴木 亮平", reading: "すずき りょうへい"),
      const Contact(name: "田中 圭", reading: "たなか けい"),
      const Contact(name: "中島 美嘉", reading: "なかじま みか"),
      const Contact(name: "橋本 環奈", reading: "はしもと かんな"),
      const Contact(name: "本田 翼", reading: "ほんだ つばさ"),
      const Contact(name: "松本 潤", reading: "まつもと じゅん"),
      const Contact(name: "山崎 賢人", reading: "やまざき けんと"),
      const Contact(name: "渡辺 謙", reading: "わたなべ けん"),
      const Contact(name: "Apple Store", reading: "apple store"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("日本語インデックスリスト"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: JapaneseIndexListView<Contact>(
        data: contacts,
        // データオブジェクトから読み仮名を取得する方法を指定
        phoneticProvider: (item) => item.reading,
        // リストアイテムの見た目を定義
        itemBuilder: (context, item) => ListTile(
          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () => print("Selected: ${item.name}"),
        ),
        // 必要に応じてグループヘッダーのデザインをカスタマイズ可能
        headerBuilder: (context, tag) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: Colors.blueAccent.withOpacity(0.05),
          child: Text(
            tag,
            style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        // フィードバックが必要な場合は true に設定
        enableHapticFeedback: false,
      ),
    );
  }
}
