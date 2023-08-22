import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeBloc {
  final _barcodeSubject = BehaviorSubject<String>();
  Stream<String> get barcodeStream =>
      _barcodeSubject.stream.debounceTime(const Duration(milliseconds: 1000));

  void startScanning() async {
    final stream = FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    if (stream == null) return;
    await for (var barcode in stream) {
      _barcodeSubject.add(barcode);
    }
  }

  void dispose() {
    _barcodeSubject.close();
  }
}

barcodeScanner(Function(dynamic) callback) {
  try {
    final barcodeBloc = BarcodeBloc();
    barcodeBloc.startScanning();
    final stream = barcodeBloc.barcodeStream;
    stream.listen(callback);
  } on PlatformException {
    debugPrint('Failed to get platform version.');
  }
}
