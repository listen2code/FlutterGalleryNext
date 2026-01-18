import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/generated/r.dart';

class DemoAnimTransitionPage extends StatelessWidget {
  const DemoAnimTransitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Anim Transition"),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const BigImagePage();
                },
                fullscreenDialog: true,
              ),
            );
          },
          child: Hero(
            tag: "image",
            child: Image.asset(R.imagesLake, fit: BoxFit.cover, width: 100, height: 100),
          ),
        ),
      ),
    );
  }
}

class BigImagePage extends StatelessWidget {
  const BigImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          alignment: Alignment.center,
          child: Hero(
            tag: "image",
            child: Image.asset(
              R.imagesLake,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
