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
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonCommon(
                text: 'DefaultButton',
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Tap')));
                },
            ),
            ButtonCommon(
              text: 'CommonButton',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Tap')));
              },
              options: ButtonOptions(
                width: 100,
                height: 40,
                color: Colors.white,
                textColor: Colors.black,
                fontSize: 10,
                borderColor: Colors.black,
                borderWidth: 0.5,
                borderRadius: BorderRadius.circular(5),
                padding: const EdgeInsets.all(10),
              ),
            ),
            ButtonCheckable(
                text: "CheckButton",
                isChecked: false,
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
                })
          ],
        )
      ),
    );
  }
}

class ButtonCheckable extends StatefulWidget {
  final String text;
  final ValueChanged<bool> onPressed;
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
        widget.onPressed(widget.isChecked);
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
  ButtonOptions defaultOptions = ButtonOptions();

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
            elevation: MaterialStateProperty.all<double>(options?.elevation ?? defaultOptions.elevation),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(0),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                options?.color ?? Theme.of(context).primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: options?.borderRadius ?? defaultOptions.borderRadius,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: options?.borderColor ?? defaultOptions.borderColor,
                width: options?.borderWidth ?? defaultOptions.borderWidth,
              ),
            )
        ),
        child: Padding(
          padding: options?.padding ?? defaultOptions.padding,
          child: Text(
            text,
            style: TextStyle(
              color: options?.textColor ?? defaultOptions.textColor,
              fontSize: options?.fontSize ?? defaultOptions.fontSize,
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
  late final Color color;
  late final Color textColor;
  late final Color borderColor;
  late final double elevation;
  late final double borderWidth;
  late final double fontSize;
  late final BorderRadius borderRadius;
  late final EdgeInsets padding;
  ButtonOptions({
    this.width,
    this.height,
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.borderColor = Colors.white,
    this.elevation = 0.0,
    this.borderWidth = 0.0,
    this.fontSize = 14.0,
    this.borderRadius = BorderRadius.zero,
    this.padding = const EdgeInsets.all(5)}
  );
}
