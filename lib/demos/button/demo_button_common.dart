import 'package:flutter/material.dart';


void main() {
  runApp(const DemoButtonCommon());
}

class DemoButtonCommon extends StatelessWidget {
  const DemoButtonCommon({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Common Button Demo';

    return const MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: ButtonCommon(
          width: 150,
          height: 50,
          text: 'CommonButton',
          color: Colors.white,
          textColor: Colors.black,
          fontSize: 10,
          borderColor: Colors.black,
          borderWidth: 1,
          borderRadius: BorderRadius.circular(5),
          padding: EdgeInsets.all(10),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tap')));
          },
        ),
      ),
    );
  }
}

class ButtonCommon extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;
  final double fontSize;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const ButtonCommon({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.textColor = Colors.white,
    this.borderColor,
    this.borderWidth = 0.0,
    this.fontSize = 14.0,
    this.borderRadius,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(0),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(color ?? Theme.of(context).primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(0),
            ),
          ),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(
              color: borderColor?? Theme.of(context).primaryColor,
              width: borderWidth,
            ),
          )
        ),
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
