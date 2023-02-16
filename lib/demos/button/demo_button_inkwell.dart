import 'package:flutter/material.dart';

class DemoButtonInkWell extends StatelessWidget {
  const DemoButtonInkWell({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'InkWell Demo';

    return const MaterialApp(
      title: title,
      home: ButtonInkWell(title: title),
    );
  }
}

class ButtonInkWell extends StatelessWidget {
  final String title;

  const ButtonInkWell({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: MyButton(),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    // The InkWell wraps the custom flat button widget.
    return InkWell(
      // When the user taps the button, show a snackbar.
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tap'),
        ));
      },
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text('Flat Button'),
      ),
    );
  }
}