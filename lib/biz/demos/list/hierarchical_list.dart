import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HierarchicalListDemo(),
    debugShowCheckedModeBanner: false,
  ));
}

class HierarchicalListDemo extends StatelessWidget {
  const HierarchicalListDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TreeNode> data = [
      TreeNode(
        leftTitle: 'Electronics',
        subTitle: 'Devices and gadgets',
        leftIconColor: Colors.blue,
        rightTitle: '1200',
        rightUnit: '円',
        rightSubtitle1: '100',
        rightSubtitle2: '5.5',
        rightSubUnit: '%',
        children: [
          TreeNode(
            leftTitle: 'Computers',
            leftIconColor: Colors.orange,
            leftIconSize: 6,
            rightTitle: '800',
            rightUnit: '円',
            rightSubtitle1: '50',
            rightSubtitle2: '2.1',
            rightSubUnit: '%',
            children: [
              TreeNode(leftTitle: 'Laptops', rightTitle: '500', rightUnit: '円'),
              TreeNode(leftTitle: 'Desktops', rightTitle: '300', rightUnit: '円'),
            ],
          ),
          TreeNode(
            leftTitle: 'Smartphones',
            leftIconColor: Colors.green,
            rightTitle: '400',
            rightUnit: '円',
            rightIcon: Icons.chevron_right,
          ),
        ],
      ),
      TreeNode(
        leftTitle: 'Clothing',
        leftIconColor: Colors.purple,
        rightTitle: '500',
        rightUnit: '円',
        rightSubtitle1: '20',
        rightSubtitle2: '1.2',
        rightSubUnit: '%',
        rightIcon: Icons.edit,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Hierarchical Tree List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HierarchicalTreeWidget(
          data: data,
          headerLeftTitle: 'Department List',
          headerRightTopTitle: 'Total Items: 128',
          headerRightBottomTitle: 'Updated: Just now',
          accentColor: Colors.blueAccent,
        ),
      ),
    );
  }
}

class HierarchicalTreeWidget extends StatelessWidget {
  final List<TreeNode> data;
  final String headerLeftTitle;
  final String headerRightTopTitle;
  final String? headerRightBottomTitle;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;
  final Color? accentColor;
  final Color? secondaryColor;

  const HierarchicalTreeWidget({
    super.key,
    required this.data,
    required this.headerLeftTitle,
    required this.headerRightTopTitle,
    this.headerRightBottomTitle,
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

    return Container(
      decoration: containerDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ListHeader(
            leftTitle: headerLeftTitle,
            rightTopTitle: headerRightTopTitle,
            rightBottomTitle: headerRightBottomTitle,
            backgroundColor: effectiveBgColor,
            foregroundColor: effectiveForegroundColor,
            secondaryColor: effectiveSecondaryColor,
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _TreeNodeWidget(
                  node: data[index],
                  depth: 0,
                  foregroundColor: effectiveForegroundColor,
                  accentColor: effectiveAccentColor,
                  secondaryColor: effectiveSecondaryColor,
                );
              },
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
          Text(
            leftTitle,
            style: leftTitleStyle ??
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
          ),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            if (hasChildren) {
              setState(() {
                _isExpanded = !_isExpanded;
              });
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.node.leftIconColor != null) ...[
                            Container(
                              width: widget.node.leftIconSize ?? (widget.depth == 0 ? 8 : 6),
                              height: widget.node.leftIconSize ?? (widget.depth == 0 ? 8 : 6),
                              decoration: BoxDecoration(
                                color: widget.node.leftIconColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              widget.node.leftTitle,
                              style: TextStyle(
                                fontWeight: widget.depth == 0 ? FontWeight.bold : FontWeight.normal,
                                color: widget.foregroundColor,
                                fontSize: 16 - (widget.depth * 1.0),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasChildren) ...[
                            const SizedBox(width: 4),
                            Icon(
                              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              size: 18,
                              color: widget.secondaryColor,
                            ),
                          ],
                        ],
                      ),
                      if (widget.node.subTitle != null)
                        Padding(
                          padding: EdgeInsets.only(
                            left: (widget.node.leftIconColor != null)
                                ? (widget.node.leftIconSize ?? (widget.depth == 0 ? 8 : 6)) + 8
                                : 0,
                            top: 2,
                          ),
                          child: Text(
                            widget.node.subTitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.secondaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
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
                    if (widget.node.rightSubtitle1 != null || widget.node.rightSubtitle2 != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.node.rightSubtitle1 != null)
                            Text(
                              '${widget.node.rightSubtitle1}円',
                              style: TextStyle(fontSize: 11, color: widget.secondaryColor),
                            ),
                          if (widget.node.rightSubtitle2 != null)
                            Text(
                              '(${widget.node.rightSubtitle2}${widget.node.rightSubUnit ?? ''})',
                              style: TextStyle(fontSize: 11, color: widget.secondaryColor),
                            ),
                        ],
                      ),
                  ],
                ),
                if (widget.node.rightIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    widget.node.rightIcon,
                    size: 20,
                    color: widget.secondaryColor,
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
  }
}

class TreeNode {
  final String leftTitle;
  final String? subTitle;
  final List<TreeNode> children;
  final Color? leftIconColor;
  final double? leftIconSize;
  final String? rightTitle;
  final String? rightUnit;
  final String? rightSubtitle1;
  final String? rightSubtitle2;
  final String? rightSubUnit;
  final IconData? rightIcon;

  TreeNode({
    required this.leftTitle,
    this.subTitle,
    this.children = const [],
    this.leftIconColor,
    this.leftIconSize,
    this.rightTitle,
    this.rightUnit,
    this.rightSubtitle1,
    this.rightSubtitle2,
    this.rightSubUnit,
    this.rightIcon,
  });
}
