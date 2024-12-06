import 'package:flutter/material.dart';

class CommonLoadingWidget extends StatelessWidget {
  const CommonLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 3,
      valueColor: AlwaysStoppedAnimation(Colors.white),
    );
  }
}
