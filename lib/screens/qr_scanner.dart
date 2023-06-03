// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:iskolarsafe/screens/home/logs.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScanner extends StatefulWidget {
  static const String routeName = "/scanner";
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Logs.routeName);
          },
        ),
        centerTitle: true,
        title: const AppBarHeader(
          icon: Symbols.qr_code_scanner_rounded,
          title: "Scan",
          isCenter: true,
          hasAction: false,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // Handle the scanned QR code data
      print(scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
