import 'package:flutter/material.dart';

class DemoTextTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DemoTextTag"),
      ),
      body: Wrap(children: <Widget>[
        TagItem("Start"),
        for (var item in tags) TagItem(item),
        TagItem("End"),
      ]),
    );
  }
}

class TagItem extends StatelessWidget {
  final String text;

  TagItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.blueAccent.withAlpha(60),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Text(text),
    );
  }
}

const List<String> tags = [
  "FFFFFFF",
  "TTTTTT",
  "LL",
  "JJJJJJJJ",
  "PPPPP",
  "OOOOOOOOOOOO",
  "9999999",
  "*&",
  "5%%%%%",
  "¥¥¥¥¥¥",
  "UUUUUUUUUU",
  "))@@@@@@"
];
