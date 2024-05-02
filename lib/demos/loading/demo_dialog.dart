import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gallery_next/demos/loading/toast.dart';

class DemoDialog extends StatefulWidget {
  const DemoDialog({Key? key}) : super(key: key);

  @override
  State<DemoDialog> createState() => _DemoDialogState();
}

class _DemoDialogState extends State<DemoDialog> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   showDialog(context: context, builder: (BuildContext context){
    //     return Center(
    //       child: CircularProgressIndicator(color: Colors.white,),
    //     );
    //   });
    //   Future.delayed(const Duration(seconds: 1), (){
    //     Navigator.of(context).pop();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo dialog'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Toast.show(context, "toast");
                },
                child: Text("toast by overlay")),
            ElevatedButton(
                onPressed: () {
                  Future dialogFuture = showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      });
                  print("dialogFuture=${dialogFuture}");
                  Future.delayed(const Duration(seconds: 10), () {
                    Navigator.of(context).pop();
                  });
                },
                child: Text("loading by showDialog")),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          backgroundColor: Colors.grey,
                          title: Center(child: Text("title")),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  width: 1, color: Colors.white)),
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: Center(child: Text("content")),
                                  )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 5),
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: Text("cancel")),
                                      SizedBox(width: 5),
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: Text("confirm")),
                                      SizedBox(width: 5),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("ok")),
                                      SizedBox(width: 5),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      });
                },
                child: Text("diy by simpleDialog1")),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          backgroundColor: Colors.grey,
                          title: Center(child: Text("title")),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  width: 1, color: Colors.white)),
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: Center(child: Text("content")),
                                  )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text("cancel"))),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("ok"))),
                                      SizedBox(width: 10),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      });
                },
                child: Text("diy by simpleDialog2")),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          backgroundColor: Colors.grey,
                          title: Center(child: Text("title")),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  width: 1, color: Colors.white)),
                          children: [
                            Container(
                              width: 300,
                              height: 200,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: Center(child: Text("content")),
                                  )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text("cancel"))),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text("confirm"))),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("ok"))),
                                      SizedBox(width: 10),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      });
                },
                child: Text("diy by simpleDialog3")),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(
                              child: Text(
                                  "titletitletitletitletitletitletitletitletitletitletitletitle")),
                          content: const SizedBox(
                            height: 100,
                            width: 100,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                  "contentcontentcontentcontentcontentcontentcontentcontentcontentconten"),
                            ),
                          ),
                          actions: [
                            Center(
                              child: SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("ok")),
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Text("diy by AlertDialog1")),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(child: Text("title")),
                          content: const SizedBox(
                            height: 100,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text("content"),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {}, child: Text("cancel")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("ok")),
                              ],
                            )
                          ],
                        );
                      });
                },
                child: Text("diy by AlertDialog2")),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(child: Text("title")),
                          content: const SizedBox(
                            height: 100,
                            width: 100,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text("content"),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {}, child: Text("cancel")),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {}, child: Text("confirm")),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("ok")),
                              ],
                            )
                          ],
                        );
                      });
                },
                child: Text("diy by AlertDialog3")),
          ],
        ),
      ),
    );
  }
}
