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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonCommon(
            text: 'CommonButton',
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Tap')));
            },
            options: ButtonOptions(
              width: 150,
              height: 50,
              color: Colors.white,
              textColor: Colors.black,
              fontSize: 10,
              borderColor: Colors.black,
              borderWidth: 1,
              borderRadius: BorderRadius.circular(5),
              padding: const EdgeInsets.all(10),
            ),
          ),
          ButtonCheckable(
              text: "CheckButton",
              checkOptions: ButtonOptions(
                width: 100,
                color: Colors.red
              ),
              uncheckOptions: ButtonOptions(
                width: 100,
                color: Colors.blue
              ),
              onPressed: (isChecked) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('isChecked: $isChecked')));
              },
              isChecked: true)
        ],
      ),
    );
  }
}

class ButtonCheckable extends StatefulWidget {
  final String text;
  final ValueChanged<String> onPressed;
  final ButtonOptions? checkOptions;
  final ButtonOptions? uncheckOptions;
  bool isChecked;

  ButtonCheckable({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isChecked,
    this.checkOptions,
    this.uncheckOptions,
  });

  @override
  State<ButtonCheckable> createState() => _ButtonCheckableState();
}

class _ButtonCheckableState extends State<ButtonCheckable> {
  @override
  Widget build(BuildContext context) {
    return ButtonCommon(
      text: widget.text,
      onPressed: () {
        widget.onPressed(widget.isChecked! ? 'Uncheck' : 'Check');
        setState(() {
          widget.isChecked = !widget.isChecked;
        });
      },
      options: widget.isChecked ? widget.checkOptions : widget.uncheckOptions,
    );
  }
}

class ButtonCommon extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  ButtonOptions? options;

  ButtonCommon({
    super.key,
    required this.text,
    required this.onPressed,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options?.width,
      height: options?.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(0),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                options?.color ?? Theme.of(context).primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: options?.borderRadius ?? BorderRadius.circular(0),
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: options?.borderColor ?? Theme.of(context).primaryColor,
                width: options?.borderWidth ?? 0,
              ),
            )
        ),
        child: Padding(
          padding: options?.padding ?? const EdgeInsets.all(0),
          child: Text(
            text,
            style: TextStyle(
              color: options?.textColor ?? Colors.white,
              fontSize: options?.fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonOptions {
  late final double? width;
  late final double? height;
  late final Color? color;
  late final Color? textColor;
  late final Color? borderColor;
  late final double borderWidth;
  late final double fontSize;
  late final BorderRadius? borderRadius;
  late final EdgeInsets padding;
  ButtonOptions({
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.fontSize = 14.0,
    this.borderRadius,
    this.padding = const EdgeInsets.all(0)}
  );
}
