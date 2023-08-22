import 'package:casher_mobile_app/helpers/barcode_scanner.dart';
import 'package:casher_mobile_app/helpers/qr_scanner.dart';
import 'package:casher_mobile_app/tools/barcode_scanner/scanner_connector.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ConstructScanner {
  static final ConstructScanner _instance = ConstructScanner();
  static ConstructScanner get instance => _instance;
  connect() async {
    final connector = Connector.instance;
    await connector.init();
    final isConnected = await connector.tryConnect();
    if (!isConnected) {
      final String credentials = await qrScanner();
      await connector.reInit(credentials);
    }
    return connector;
  }

  playScanner() async {
    final connector = await connect();
    try {
      barcodeScanner((barcode) async {
        await connector.request(barcode);
        await Vibration.vibrate(duration: 500);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
