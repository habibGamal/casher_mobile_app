import 'package:casher_mobile_app/tools/barcode_scanner/construct_scanner.dart';
import 'package:flutter/material.dart';

class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () => ConstructScanner.instance.playScanner(),
            child: const Text('Connect')),
      ),
    );
  }
}
