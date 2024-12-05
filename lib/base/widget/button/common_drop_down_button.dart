import 'package:flutter/material.dart';

class CommonDropDown extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  final Function(String title, int index) selectCallBack;

  final double pageWidth;

  final Color? backGroundColor;

  final Icon iconExpand;

  final Icon iconClose;

  final Decoration? titleDecoration;

  final double titleHeight;

  final EdgeInsetsGeometry? titlePadding;

  final TextStyle titleTextStyle;

  final int? defaultCode;

  final Offset offset;

  final double maxHeight;

  final double menuHeight;

  final TextStyle menuTextStyle;

  final BoxBorder? menuBorder;

  const CommonDropDown({
    super.key,
    required this.data,
    required this.selectCallBack,
    this.pageWidth = double.infinity,
    this.backGroundColor = Colors.white,
    this.iconExpand = const Icon(Icons.arrow_drop_up),
    this.iconClose = const Icon(Icons.arrow_drop_down),
    this.titleDecoration,
    this.titleHeight = 40,
    this.titlePadding = const EdgeInsets.only(left: 5),
    this.titleTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    ),
    this.defaultCode,
    this.offset = const Offset(0, 40),
    this.maxHeight = 200.0,
    this.menuHeight = 40,
    this.menuTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12.0,
    ),
    this.menuBorder,
  });

  @override
  State<CommonDropDown> createState() => _CommonDropDownState();
}

class _CommonDropDownState extends State<CommonDropDown> {
  String _selectedString = "";

  late bool _isExpand;

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      if (widget.defaultCode != null) {
        _selectedString = widget.data.firstWhere(
            (element) => element["code"] == widget.defaultCode)["name"];
      } else {
        _selectedString = widget.data[0]["name"];
      }
    }
    _isExpand = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
        maxWidth: widget.pageWidth,
      ),
      offset: widget.offset,
      popUpAnimationStyle: AnimationStyle.noAnimation,
      color: widget.backGroundColor,
      onOpened: () {
        setState(() {
          _isExpand = true;
        });
      },
      onCanceled: () {
        setState(() {
          _isExpand = false;
        });
      },
      child: Container(
        width: widget.pageWidth,
        height: widget.titleHeight,
        alignment: Alignment.centerLeft,
        padding: widget.titlePadding,
        decoration: widget.titleDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedString, style: widget.titleTextStyle),
            _isExpand ? widget.iconExpand : widget.iconClose,
          ],
        ),
      ),
      itemBuilder: (context) {
        return widget.data.map((e) {
          return PopupMenuItem(
            padding: const EdgeInsets.all(0),
            height: widget.menuHeight,
            child: Container(
              width: widget.pageWidth,
              height: widget.menuHeight,
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border: widget.menuBorder ??
                    const Border(
                      left: BorderSide(color: Color(0xFFC6C8CA), width: 0.2),
                      right: BorderSide(color: Color(0xFFC6C8CA), width: 0.2),
                      bottom: BorderSide(color: Color(0xFFC6C8CA), width: 0.2),
                    ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                e['name'],
                style: widget.menuTextStyle,
              ),
            ),
            onTap: () {
              setState(() {
                _selectedString = e['name'];
                widget.selectCallBack(e['name'], e['code']);
              });
            },
          );
        }).toList();
      },
    );
  }
}
