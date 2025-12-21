import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/loading/global_dialog_extension.dart';
import 'package:flutter_gallery_next/biz/demos/loading/global_loading.dart';
import 'package:flutter_gallery_next/biz/demos/loading/toast.dart';

class DemoDialog extends StatefulWidget {
  const DemoDialog({Key? key}) : super(key: key);

  @override
  State<DemoDialog> createState() => _DemoDialogState();
}

class _DemoDialogState extends State<DemoDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showMessageDialog("dialog show initState");
    });
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      });
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                  });
                },
                child: Text("loading by showDialog")),
            ElevatedButton(
                onPressed: () async {
                  GlobalLoading.showLoading();
                },
                child: Text("loading by global loading")),
            ElevatedButton(
                onPressed: () async {
                  showMessageDialog("message", title: "title", onOkPressed: () {
                    dismissDialog();
                  });
                },
                child: Text("show message dialog")),
            ElevatedButton(
                onPressed: () async {
                  showConfirmDialog("message", title: "title", onCancelPressed: () {
                    dismissDialog();
                  }, onOkPressed: () {
                    dismissDialog();
                  });
                },
                child: Text("show confirm dialog")),
            ElevatedButton(
                onPressed: () async {
                  showCustomDialog(Center(child: Text("custom dialog")));
                },
                child: Text("show custom dialog")),
            ElevatedButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      width: 200,
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(width: 200, color: Colors.green, child: Text("data1")),
                          SizedBox(
                            height: 10,
                          ),
                          Container(width: 200, color: Colors.green, child: Text("data2")),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text("show bottom sheet dialog"),
            ),
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
                          borderRadius: BorderRadius.circular(10.0), side: const BorderSide(width: 1, color: Colors.white)),
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                child: Center(
                                  child: Text("content"),
                                ),
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 10),
                                  Expanded(child: ElevatedButton(onPressed: () {}, child: Text("cancel"))),
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
                  },
                );
              },
              child: Text("diy by simpleDialog2"),
            ),
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
                              ElevatedButton(onPressed: () {}, child: Text("cancel")),
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
              child: Text("diy by AlertDialog2"),
            ),
          ],
        ),
      ),
    );
  }
}
