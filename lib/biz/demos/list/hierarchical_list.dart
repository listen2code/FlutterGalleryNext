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
    EdgeInsets level1Padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    EdgeInsets level2Padding = const EdgeInsets.only(left: 36, right: 12, top: 10, bottom: 10);
    EdgeInsets level3Padding = const EdgeInsets.only(left: 60, right: 12, top: 8, bottom: 8);
    TextStyle level1LeftTitleStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    TextStyle level2LeftTitleStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    TextStyle level3LeftTitleStyle = const TextStyle(fontSize: 13);

    final List<TreeNode> data = [
      TreeNode(
        leftTitle: 'leftTitle1leftTitle1leftTitle1',
        leftIconColor: Colors.blue,
        padding: level1Padding,
        leftTitleStyle: level1LeftTitleStyle,
        rightTitle: '1200000',
        rightSubtitle1: '100000',
        rightSubtitle2: '15.5',
        children: [
          TreeNode(
            leftTitle: 'leftTitle11',
            leftIconColor: Colors.orange,
            leftIconSize: 6,
            padding: level2Padding,
            leftTitleStyle: level2LeftTitleStyle,
            rightTitle: '800',
            rightSubtitle1: '-50',
            rightSubtitle2: '-2.1',
            children: [
              TreeNode(
                leftTitle: 'leftTitle111',
                padding: level3Padding,
                leftTitleStyle: level3LeftTitleStyle,
                rightTitle: '500',
              ),
              TreeNode(
                leftTitle: 'leftTitle112',
                padding: level3Padding,
                leftTitleStyle: level3LeftTitleStyle,
                rightTitle: '300',
              ),
            ],
          ),
        ],
      ),
      TreeNode(
        leftTitle: 'leftTitle2',
        leftSubTitle: "leftSubTitle2leftSubTitle2leftSubTitle2leftSubTitle2leftSubTitle2",
        leftIconColor: Colors.purple,
        padding: level1Padding,
        leftTitleStyle: level1LeftTitleStyle,
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
              accentColor: Colors.indigo,
            ),
            const SizedBox(height: 32),
            const HierarchicalTreeWidget(
              data: [],
              isLoading: false,
              headerLeftTopTitle: 'Empty List',
              headerRightTopTitle: '-',
              noDataMessage: 'No Data available',
              accentColor: Colors.grey,
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
  final Color? accentColor;
  final Color? secondaryColor;

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
    this.accentColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? Colors.white;
    final effectiveBorderColor = borderColor ?? Colors.grey.shade300;
    final effectiveForegroundColor = foregroundColor ?? Colors.black;
    final effectiveSecondaryColor = secondaryColor ?? Colors.grey;
    final effectiveAccentColor = accentColor ?? Colors.blue;

    final List<TreeNode> displayData = isLoading
        ? List.generate(
            loadingItemCount,
            (_) => TreeNode(
              leftTitle: 'leftTitle',
              leftSubTitle: 'subTitle',
              rightTitle: '0000',
              rightUnit: '円',
              leftIconColor: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          )
        : data;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: effectiveBorderColor),
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
          const Divider(height: 1),
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

  const _TreeNodeWidget({required this.node, required this.foregroundColor, required this.secondaryColor});

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool hasChildren = widget.node.children.isNotEmpty;
    final bool shouldHideRight = hasChildren && _isExpanded && widget.node.hideRightOnExpand;

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
            child: Padding(
              padding: widget.node.padding ?? const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.node.leftIconColor != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Container(
                                  width: widget.node.leftIconSize ?? 8,
                                  height: widget.node.leftIconSize ?? 8,
                                  decoration:
                                      BoxDecoration(color: widget.node.leftIconColor, shape: BoxShape.circle),
                                ),
                              ),
                            if (widget.node.leftIconColor != null) const SizedBox(width: 8),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                left: (widget.node.leftIconColor != null)
                                    ? (widget.node.leftIconSize ?? 8) + 8
                                    : 0,
                                top: 2),
                            child: Text(
                              widget.node.leftSubTitle!,
                              style: widget.node.leftSubTitleStyle ??
                                  TextStyle(fontSize: 12, color: widget.secondaryColor),
                              softWrap: true,
                              maxLines: widget.node.leftSubMaxLine,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
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
                                                style:
                                                    TextStyle(fontSize: 11, color: widget.foregroundColor))),
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
                  ),
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
          if (hasChildren && _isExpanded)
            ...widget.node.children.map((child) => _TreeNodeWidget(
                node: child, foregroundColor: widget.foregroundColor, secondaryColor: widget.secondaryColor)),
        ],
      );
    });
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

class TreeNode {
  final String leftTitle;
  final String? leftSubTitle;
  final List<TreeNode> children;
  final Color? leftIconColor;
  final double? leftIconSize;
  final String? rightTitle;
  final String? rightUnit;
  final String? rightSubtitle1;
  final String? rightSubUnit1;
  final String? rightSubtitle2;
  final String? rightSubUnit2;
  final IconData? rightIcon;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final TextStyle? leftTitleStyle;
  final TextStyle? leftSubTitleStyle;
  final TextStyle? rightTitleStyle;
  final TextStyle? rightSubtitleStyle;
  final int leftMaxLine;
  final int leftSubMaxLine;
  final bool hideRightOnExpand;
  final bool showStatusColors;

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
    this.leftTitleStyle,
    this.leftSubTitleStyle,
    this.rightTitleStyle,
    this.rightSubtitleStyle,
    this.leftMaxLine = 2,
    this.leftSubMaxLine = 2,
    this.hideRightOnExpand = true,
    this.showStatusColors = true,
  });
}
