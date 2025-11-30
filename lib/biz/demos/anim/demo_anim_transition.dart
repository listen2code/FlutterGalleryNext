import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/generated/r.dart';

class DemoAnimTransition extends StatelessWidget {
  const DemoAnimTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("DemoAnimTransition"),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const HonorPage();
                },
                fullscreenDialog: true));
          },

          /// Hero  tag 共享
          child: Hero(
            tag: "image",
            child: Image.asset(
              R.imagesLake,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}

class HonorPage extends StatelessWidget {
  const HonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
