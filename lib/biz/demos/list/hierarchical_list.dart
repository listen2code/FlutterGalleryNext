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
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<TreeNode> data = [
      TreeNode(
        leftTitle: 'leftTitle1leftTitle1leftTitle1',
        leftIconColor: Colors.blue,
        rightTitle: '1200',
        rightUnit: '円',
        rightSubtitle1: '100000',
        rightSubtitle2: '15.5',
        rightSubUnit: '%',
        children: [
          TreeNode(
            leftTitle: 'leftTitle11',
            leftIconColor: Colors.orange,
            leftIconSize: 6,
            rightTitle: '800',
            rightUnit: '円',
            rightSubtitle1: '50',
            rightSubtitle2: '2.1',
            rightSubUnit: '%',
            children: [
              TreeNode(leftTitle: 'leftTitle111', rightTitle: '500', rightUnit: '円'),
              TreeNode(leftTitle: 'leftTitle112', rightTitle: '300', rightUnit: '円'),
            ],
          ),
          TreeNode(
            leftTitle: 'leftTitle12',
            leftIconColor: Colors.green,
            rightTitle: '400',
            rightUnit: '円',
            rightIcon: Icons.chevron_right,
            onTap: () => debugPrint('leftTitle12'),
          ),
        ],
      ),
      TreeNode(
        leftTitle: 'leftTitle2',
        leftSubTitle: "leftSubTitle2leftSubTitle2leftSubTitle2leftSubTitle2",
        leftIconColor: Colors.purple,
        rightTitle: '500',
        rightUnit: '円',
        rightIcon: Icons.chevron_right,
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

    final BoxDecoration containerDecoration = BoxDecoration(
      color: effectiveBgColor,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(
        color: effectiveBorderColor,
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final List<TreeNode> displayData = isLoading
        ? List.generate(
            loadingItemCount,
            (_) => TreeNode(
              leftTitle: 'leftTitle',
              leftSubTitle: 'subTitle',
              rightTitle: '0000',
              rightUnit: '円',
              rightSubtitle1: '000',
              rightSubtitle2: '0.0',
              rightSubUnit: '%',
              leftIconColor: Colors.grey,
            ),
          )
        : data;

    return Container(
      decoration: containerDecoration,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 16.0),
              child: Center(
                child: Text(
                  noDataMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: effectiveSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            )
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
                      depth: 0,
                      foregroundColor: effectiveForegroundColor,
                      accentColor: effectiveAccentColor,
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
}

class _ListHeader extends StatelessWidget {
  final String leftTitle;
  final String rightTopTitle;
  final String? rightBottomTitle;
  final TextStyle? leftTitleStyle;
  final TextStyle? rightTopTitleStyle;
  final TextStyle? rightBottomTitleStyle;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color secondaryColor;

  const _ListHeader({
    required this.leftTitle,
    required this.rightTopTitle,
    this.rightBottomTitle,
    this.leftTitleStyle,
    this.rightTopTitleStyle,
    this.rightBottomTitleStyle,
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
            child: Text(
              leftTitle,
              style: leftTitleStyle ??
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: foregroundColor,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rightTopTitle,
                style: rightTopTitleStyle ??
                    TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: foregroundColor,
                    ),
              ),
              if (rightBottomTitle?.isNotEmpty ?? false) ...[
                const SizedBox(height: 2),
                Text(
                  rightBottomTitle!,
                  style: rightBottomTitleStyle ??
                      TextStyle(
                        fontSize: 12,
                        color: secondaryColor,
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TreeNodeWidget extends StatefulWidget {
  final TreeNode node;
  final int depth;
  final Color foregroundColor;
  final Color accentColor;
  final Color secondaryColor;

  const _TreeNodeWidget({
    required this.node,
    required this.depth,
    required this.foregroundColor,
    required this.accentColor,
    required this.secondaryColor,
  });

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool hasChildren = widget.node.children.isNotEmpty;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (hasChildren) {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              } else if (widget.node.rightIcon != null && widget.node.onTap != null) {
                widget.node.onTap!();
              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0 + (widget.depth * 20.0),
                right: 12.0,
                top: 10.0,
                bottom: 10.0,
              ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.node.leftIconColor != null) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Container(
                                  width: widget.node.leftIconSize ?? (widget.depth == 0 ? 8 : 6),
                                  height: widget.node.leftIconSize ?? (widget.depth == 0 ? 8 : 6),
                                  decoration: BoxDecoration(
                                    color: widget.node.leftIconColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.node.leftTitle,
                                      style: TextStyle(
                                        fontWeight: widget.depth == 0 ? FontWeight.bold : FontWeight.normal,
                                        color: widget.foregroundColor,
                                        fontSize: 16 - (widget.depth * 1.0),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  if (hasChildren) ...[
                                    const SizedBox(width: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Icon(
                                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 18,
                                        color: widget.secondaryColor,
                                      ),
                                    ),
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
                                  ? (widget.node.leftIconSize ?? (widget.depth == 0 ? 8 : 6)) + 8
                                  : 0,
                              top: 2,
                            ),
                            child: Text(
                              widget.node.leftSubTitle!,
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.secondaryColor,
                              ),
                              softWrap: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth / 3,
                        ),
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
                                    Text(
                                      widget.node.rightTitle!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: widget.foregroundColor,
                                      ),
                                    ),
                                  if (widget.node.rightUnit != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        widget.node.rightUnit!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: widget.foregroundColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (widget.node.rightSubtitle1 != null || widget.node.rightSubtitle2 != null)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${widget.node.rightSubtitle1 ?? ''}円(${widget.node.rightSubtitle2 ?? ''}${widget.node.rightSubUnit ?? ''})',
                                  style: TextStyle(fontSize: 11, color: widget.secondaryColor),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (widget.node.rightIcon != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.node.onTap,
                      child: Icon(
                        widget.node.rightIcon,
                        size: 20,
                        color: widget.secondaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (hasChildren && _isExpanded)
            ...widget.node.children.map((child) => _TreeNodeWidget(
                  node: child,
                  depth: widget.depth + 1,
                  foregroundColor: widget.foregroundColor,
                  accentColor: widget.accentColor,
                  secondaryColor: widget.secondaryColor,
                )),
        ],
      );
    });
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
  final String? rightSubtitle2;
  final String? rightSubUnit;
  final IconData? rightIcon;
  final VoidCallback? onTap;

  TreeNode({
    required this.leftTitle,
    this.leftSubTitle,
    this.children = const [],
    this.leftIconColor,
    this.leftIconSize,
    this.rightTitle,
    this.rightUnit,
    this.rightSubtitle1,
    this.rightSubtitle2,
    this.rightSubUnit,
    this.rightIcon,
    this.onTap,
  });
}
