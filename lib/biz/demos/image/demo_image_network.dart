import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/generated/r.dart';

class DemoImageNetwork extends StatelessWidget {
  const DemoImageNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Fade in images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Center(
          child: FadeInImage.assetNetwork(
            placeholder: R.imagesLoading,
            image: 'https://picsum.photos/250?image=9',
          ),
        ),
      ),
    );
  }
}
