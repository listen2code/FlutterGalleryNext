import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gallery_next/demos/loading/global_dialog.dart';
import 'package:flutter_gallery_next/demos/loading/global_dialog_extension.dart';
import 'package:flutter_gallery_next/demos/loading/global_loading.dart';
import 'package:flutter_gallery_next/demos/loading/toast.dart';

class DemoDialogStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo dialog StatelessWidget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () async {
                  showMessageDialog(context, "message", title: "title",
                      onOkPressed: () {
                    dismissDialog(context);
                  });
                },
                child: Text("show message dialog")),
            ElevatedButton(
                onPressed: () {
                  showConfirmDialog(context, "message", title: "title",
                      onCancelPressed: () {
                    dismissDialog(context);
                  }, onOkPressed: () {
                    dismissDialog(context);
                  });
                },
                child: Text("show confirm dialog")),
            ElevatedButton(
                onPressed: () async {
                  showCustomDialog(context, (context) {
                    return Center(child: Text("custom dialog"));
                  });
                },
                child: Text("show custom dialog")),
          ],
        ),
      ),
    );
  }
}
