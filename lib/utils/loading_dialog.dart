import 'package:flutter/material.dart';

class LoadingDialog {
  late BuildContext context;
  LoadingDialog(this.context);
  void startLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void endLoading() {
    Navigator.of(context).pop();
  }
}
