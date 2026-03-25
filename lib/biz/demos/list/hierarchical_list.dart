import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  runApp(const MaterialApp(
    home: HierarchicalListDemo(),
    debugShowCheckedModeBanner: false,
  ));
}

class HierarchicalListDemo extends StatefulWidget {
  const HierarchicalListDemo({super.key});

  @override
  State<HierarchicalListDemo> createState() => _HierarchicalListDemoState();
}

class _HierarchicalListDemoState extends State<HierarchicalListDemo> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<TreeNode> data = [
      Level1Node(
        leftTitle: 'leftTitle1leftTitle1leftTitle1',
        leftIconColor: Colors.blue,
        rightTitle: '1200000',
        rightSubtitle1: '100000',
        rightSubtitle2: '15.5',
        hideRightOnExpand: true,
        children: [
          Level2Node(
            leftTitle: 'leftTitle11',
            leftIconColor: Colors.orange,
            rightTitle: '800',
            rightSubtitle1: '-50',
            rightSubtitle2: '-2.1',
            children: [
              Level3Node(
                leftTitle: 'leftTitle111',
                rightTitle: '500',
              ),
              Level3Node(
                leftTitle: 'leftTitle112',
                rightTitle: '300',
              ),
            ],
          ),
        ],
      ),
      Level1Node(
        leftTitle: 'leftTitle2',
        leftSubTitle: "leftSubTitle2leftSubTitle2leftSubTitle2leftSubTitle2leftSubTitle2",
        leftIconColor: Colors.purple,
        rightTitle: '500',
        rightIcon: Icons.edit,
        onTap: () => debugPrint('leftTitle2'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Hierarchical Tree List')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Data List', style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => setState(() => _isLoading = !_isLoading),
                  child: Text(_isLoading ? 'Stop Loading' : 'Start Loading'),
                ),
              ],
            ),
            HierarchicalTreeWidget(
              data: data,
              isLoading: _isLoading,
              headerLeftTopTitle: 'LeftTopTitle',
              headerRightTopTitle: 'RightTopTitle',
              headerRightBottomTitle: 'RightBottomTitle',
            ),
            const SizedBox(height: 32),
            const HierarchicalTreeWidget(
              data: [],
              isLoading: false,
              headerLeftTopTitle: 'Empty List',
              headerRightTopTitle: '-',
              noDataMessage: 'No Data available',
            ),
          ],
        ),
      ),
    );
  }
}

class HierarchicalTreeWidget extends StatelessWidget {
  final List<TreeNode> data;
  final bool isLoading;
  final int loadingItemCount;
  final String headerLeftTopTitle;
  final String headerRightTopTitle;
  final String? headerRightBottomTitle;
  final String noDataMessage;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;
  final Color? secondaryColor;
  final Color? dividerColor;
  final double levelIndent;
  final double? itemMinHeight;
  final double? itemMaxHeight;

  const HierarchicalTreeWidget({
    super.key,
    required this.data,
    this.isLoading = false,
    this.loadingItemCount = 3,
    required this.headerLeftTopTitle,
    required this.headerRightTopTitle,
    this.headerRightBottomTitle,
    this.noDataMessage = 'No Data',
    this.backgroundColor,
    this.borderColor,
    this.foregroundColor,
    this.secondaryColor,
    this.dividerColor,
    this.levelIndent = 20.0,
    this.itemMinHeight,
    this.itemMaxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? Colors.white;
    final effectiveForegroundColor = foregroundColor ?? Colors.black;
    final effectiveSecondaryColor = secondaryColor ?? Colors.grey;
    final effectiveDividerColor = dividerColor ?? Colors.grey.shade200;

    final List<TreeNode> displayData = isLoading
        ? List.generate(
            loadingItemCount,
            (_) => TreeNode(
              leftTitle: 'XXXXXXXXXXXXX',
              leftSubTitle: 'XXXXXXXXXXXXX',
              rightTitle: '0000',
              rightUnit: 'X',
              rightSubtitle1: "XX",
              rightSubtitle2: "XX",
              leftIconColor: Colors.grey,
              leftPadding: 16.0,
              minHeight: 60,
            ),
          )
        : data;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ListHeader(
            leftTitle: headerLeftTopTitle,
            rightTopTitle: headerRightTopTitle,
            rightBottomTitle: headerRightBottomTitle,
            backgroundColor: effectiveBgColor,
            foregroundColor: effectiveForegroundColor,
            secondaryColor: effectiveSecondaryColor,
          ),
          Divider(height: 1, thickness: 1, color: effectiveDividerColor),
          if (!isLoading && data.isEmpty)
            _buildEmptyState(effectiveSecondaryColor)
          else
            Flexible(
              child: Skeletonizer(
                enabled: isLoading,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayData.length,
                  itemBuilder: (context, index) {
                    return _TreeNodeWidget(
                      node: displayData[index],
                      foregroundColor: effectiveForegroundColor,
                      secondaryColor: effectiveSecondaryColor,
                      dividerColor: effectiveDividerColor,
                      level: 0,
                      levelIndent: levelIndent,
                      defaultMinHeight: itemMinHeight,
                      defaultMaxHeight: itemMaxHeight,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Text(noDataMessage, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 14)),
    );
  }
}

class _ListHeader extends StatelessWidget {
  final String leftTitle;
  final String rightTopTitle;
  final String? rightBottomTitle;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color secondaryColor;

  const _ListHeader({
    required this.leftTitle,
    required this.rightTopTitle,
    this.rightBottomTitle,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(leftTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: foregroundColor))),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(rightTopTitle,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: foregroundColor)),
              if (rightBottomTitle != null)
                Text(rightBottomTitle!, style: TextStyle(fontSize: 12, color: secondaryColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TreeNodeWidget extends StatefulWidget {
  final TreeNode node;
  final Color foregroundColor;
  final Color secondaryColor;
  final Color dividerColor;
  final int level;
  final double levelIndent;
  final double? defaultMinHeight;
  final double? defaultMaxHeight;

  const _TreeNodeWidget({
    required this.node,
    required this.foregroundColor,
    required this.secondaryColor,
    required this.dividerColor,
    this.level = 0,
    this.levelIndent = 20.0,
    this.defaultMinHeight,
    this.defaultMaxHeight,
  });

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool hasChildren = widget.node.children.isNotEmpty;
    final bool shouldHideRight = hasChildren && _isExpanded && widget.node.hideRightOnExpand;

    final double calculatedLeftPadding =
        widget.node.leftPadding ?? (16.0 + widget.level * widget.levelIndent);
    final double calculatedDividerPadding = widget.node.dividerLeftPadding ?? calculatedLeftPadding;

    final EdgeInsets effectivePadding = widget.node.padding ??
        EdgeInsets.only(
          left: calculatedLeftPadding,
          right: 12.0,
          top: 10.0,
          bottom: 10.0,
        );

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (hasChildren) {
                setState(() => _isExpanded = !_isExpanded);
              } else if (widget.node.rightIcon != null) {
                widget.node.onTap?.call();
              }
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: widget.node.minHeight ?? widget.defaultMinHeight ?? 50,
                maxHeight: widget.node.maxHeight ?? widget.defaultMaxHeight ?? double.infinity,
              ),
              child: Padding(
                padding: effectivePadding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLeftArea(hasChildren),
                    const SizedBox(width: 12),
                    _buildRightArea(shouldHideRight, constraints),
                    if (widget.node.rightIcon != null) ...[
                      const SizedBox(width: 8),
                      Opacity(
                        opacity: shouldHideRight ? 0.0 : 1.0,
                        child: IgnorePointer(
                          ignoring: shouldHideRight,
                          child: GestureDetector(
                              onTap: widget.node.onTap,
                              child: Icon(widget.node.rightIcon, size: 20, color: widget.secondaryColor)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: calculatedDividerPadding),
            child: Divider(height: 1, thickness: 1, color: widget.dividerColor),
          ),
          if (hasChildren && _isExpanded)
            ...widget.node.children.map((child) => _TreeNodeWidget(
                  node: child,
                  foregroundColor: widget.foregroundColor,
                  secondaryColor: widget.secondaryColor,
                  dividerColor: widget.dividerColor,
                  level: widget.level + 1,
                  levelIndent: widget.levelIndent,
                  defaultMinHeight: widget.defaultMinHeight,
                  defaultMaxHeight: widget.defaultMaxHeight,
                )),
        ],
      );
    });
  }

  Expanded _buildLeftArea(bool hasChildren) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.node.leftIconColor != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Container(
                    width: widget.node.leftIconSize ?? 8,
                    height: widget.node.leftIconSize ?? 8,
                    decoration: BoxDecoration(color: widget.node.leftIconColor, shape: BoxShape.circle),
                  ),
                ),
              if (widget.node.leftIconColor != null) const SizedBox(width: 8),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.node.leftTitle,
                        style: widget.node.leftTitleStyle ??
                            TextStyle(fontSize: 15, color: widget.foregroundColor),
                        softWrap: true,
                        maxLines: widget.node.leftMaxLine,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hasChildren) ...[
                      const SizedBox(width: 4),
                      Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 18, color: widget.secondaryColor),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (widget.node.leftSubTitle != null)
            Padding(
              padding: EdgeInsets.only(
                  left: (widget.node.leftIconColor != null) ? (widget.node.leftIconSize ?? 8) + 8 : 0,
                  top: 2),
              child: Text(
                widget.node.leftSubTitle!,
                style: widget.node.leftSubTitleStyle ?? TextStyle(fontSize: 12, color: widget.secondaryColor),
                softWrap: true,
                maxLines: widget.node.leftSubMaxLine,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Flexible _buildRightArea(bool shouldHideRight, BoxConstraints constraints) {
    return Flexible(
      fit: FlexFit.loose,
      child: Opacity(
        opacity: shouldHideRight ? 0.0 : 1.0,
        child: IgnorePointer(
          ignoring: shouldHideRight,
          child: Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth / 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (widget.node.rightTitle != null)
                          Text(widget.node.rightTitle!,
                              style: widget.node.rightTitleStyle ??
                                  TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: widget.foregroundColor)),
                        if (widget.node.rightUnit != null)
                          Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(widget.node.rightUnit!,
                                  style: TextStyle(fontSize: 11, color: widget.foregroundColor))),
                      ],
                    ),
                  ),
                  if (widget.node.rightSubtitle1 != null || widget.node.rightSubtitle2 != null)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: _buildRightSubtitles(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightSubtitles() {
    final s1 = widget.node.rightSubtitle1;
    final unit1 = widget.node.rightSubUnit1 ?? '';
    final s2 = widget.node.rightSubtitle2;
    final unit2 = widget.node.rightSubUnit2 ?? '';

    if (!widget.node.showStatusColors) {
      return Text(
        '${s1 ?? ''}$unit1(${s2 ?? ''}$unit2)',
        style: widget.node.rightSubtitleStyle ?? TextStyle(fontSize: 11, color: widget.secondaryColor),
      );
    }

    final double val1 = double.tryParse(s1 ?? '0') ?? 0;
    final double val2 = double.tryParse(s2 ?? '0') ?? 0;

    final Color color1 = val1 > 0 ? Colors.red : (val1 < 0 ? Colors.green : widget.secondaryColor);
    final String prefix1 = val1 > 0 ? '+' : '';
    final Color color2 = val2 > 0 ? Colors.red : (val2 < 0 ? Colors.green : widget.secondaryColor);
    final String prefix2 = val2 > 0 ? '+' : '';

    return RichText(
      text: TextSpan(
        style: widget.node.rightSubtitleStyle ?? TextStyle(fontSize: 11, color: widget.secondaryColor),
        children: [
          if (s1 != null) TextSpan(text: '$prefix1$s1円', style: TextStyle(color: color1)),
          if (s2 != null) ...[
            const TextSpan(text: '('),
            TextSpan(text: '$prefix2$s2$unit2', style: TextStyle(color: color2)),
            const TextSpan(text: ')'),
          ],
        ],
      ),
    );
  }
}

/// ツリー構造の各ノードのデータを保持するクラス
class TreeNode {
  /// 左側に表示されるメインタイトル
  final String leftTitle;

  /// 左側のタイトルの下に表示されるサブタイトル（説明文など）
  final String? leftSubTitle;

  /// 子ノードのリスト
  final List<TreeNode> children;

  /// 左側のアイコン（またはドット）の色
  final Color? leftIconColor;

  /// 左側のアイコン（またはドット）のサイズ
  final double? leftIconSize;

  /// 右側に表示されるメインの数値やタイトル
  final String? rightTitle;

  /// 右側のメインタイトルの単位（例：'円'）
  final String? rightUnit;

  /// 右側のサブタイトル1（数値など）
  final String? rightSubtitle1;

  /// 右側のサブタイトル1の単位（例：'円'）
  final String? rightSubUnit1;

  /// 右側のサブタイトル2（騰落率など）
  final String? rightSubtitle2;

  /// 右側のサブタイトル2の単位（例：'%'）
  final String? rightSubUnit2;

  /// 右端に表示されるアイコン（詳細矢印や編集アイコンなど）
  final IconData? rightIcon;

  /// アイテムまたは右側アイコンがタップされた際のコールバック
  final VoidCallback? onTap;

  /// アイテム全体のパディング（個別に設定したい場合に使用）
  final EdgeInsets? padding;

  /// 左側のパディング（階層に応じたインデント幅）
  final double? leftPadding;

  /// 区切り線（Divider）の左側のパディング
  final double? dividerLeftPadding;

  /// 左側タイトルのテキストスタイル
  final TextStyle? leftTitleStyle;

  /// 左側サブタイトルのテキストスタイル
  final TextStyle? leftSubTitleStyle;

  /// 右側タイトルのテキストスタイル
  final TextStyle? rightTitleStyle;

  /// 右側サブタイトルのテキストスタイル
  final TextStyle? rightSubtitleStyle;

  /// 左側タイトルの最大行数（デフォルトは2）
  final int leftMaxLine;

  /// 左側サブタイトルの最大行数（デフォルトは2）
  final int leftSubMaxLine;

  /// 展開時に右側の情報を非表示にするかどうか
  final bool hideRightOnExpand;

  /// 数値の正負に応じて色（赤/緑）と符号（+/-）を表示するかどうか
  final bool showStatusColors;

  /// アイテムの最小高さ
  final double? minHeight;

  /// アイテムの最大高さ
  final double? maxHeight;

  TreeNode({
    required this.leftTitle,
    this.leftSubTitle,
    this.children = const [],
    this.leftIconColor,
    this.leftIconSize,
    this.rightTitle,
    this.rightUnit = '円',
    this.rightSubtitle1,
    this.rightSubUnit1 = '円',
    this.rightSubtitle2,
    this.rightSubUnit2 = '%',
    this.rightIcon,
    this.onTap,
    this.padding,
    this.leftPadding,
    this.dividerLeftPadding,
    this.leftTitleStyle,
    this.leftSubTitleStyle,
    this.rightTitleStyle,
    this.rightSubtitleStyle,
    this.leftMaxLine = 2,
    this.leftSubMaxLine = 2,
    this.hideRightOnExpand = false,
    this.showStatusColors = true,
    this.minHeight = 56,
    this.maxHeight,
  });
}

/// 第一層のノードクラス
class Level1Node extends TreeNode {
  Level1Node({
    required super.leftTitle,
    super.leftSubTitle,
    super.children,
    super.leftIconColor,
    super.rightTitle,
    super.rightSubtitle1,
    super.rightSubtitle2,
    super.rightIcon,
    super.onTap,
    super.hideRightOnExpand,
  }) : super(
          leftPadding: 16.0,
          dividerLeftPadding: 0.0,
          leftTitleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          minHeight: 50,
        );
}

/// 第二層のノードクラス
class Level2Node extends TreeNode {
  Level2Node({
    required super.leftTitle,
    super.leftSubTitle,
    super.children,
    super.leftIconColor,
    super.rightTitle,
    super.rightSubtitle1,
    super.rightSubtitle2,
    super.rightIcon,
    super.onTap,
  }) : super(
          leftIconSize: 6,
          leftPadding: 32.0,
          dividerLeftPadding: 32.0,
          leftTitleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          minHeight: 50,
        );
}

/// 第三層のノードクラス
class Level3Node extends TreeNode {
  Level3Node({
    required super.leftTitle,
    super.leftSubTitle,
    super.rightTitle,
    super.rightSubtitle1,
    super.rightSubtitle2,
    super.rightIcon,
    super.onTap,
  }) : super(
          leftPadding: 56.0,
          dividerLeftPadding: 32.0,
          leftTitleStyle: const TextStyle(fontSize: 13),
          minHeight: 50,
        );
}
