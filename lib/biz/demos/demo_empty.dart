import 'package:flutter/material.dart';

class DemoEmpty extends StatefulWidget {
  final String? title;

  const DemoEmpty({Key? key, this.title}) : super(key: key);

  @override
  State<DemoEmpty> createState() => _DemoEmptyState();
}

class _DemoEmptyState extends State<DemoEmpty> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(widget.title ?? 'empty'),
    );
  }
}
