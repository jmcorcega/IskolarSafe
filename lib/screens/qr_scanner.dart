import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:iskolarsafe/screens/home/logs.dart';
import 'package:iskolarsafe/models/user_model.dart';

class QRScanner extends StatefulWidget {
  static const String routeName = "/scanner";
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  bool isScanning = true;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

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
              overlay: QrScannerOverlayShape(
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                  borderLength: 20,
                  borderWidth: 10,
                  borderRadius: 10,
                  borderColor: Theme.of(context).colorScheme.primary),
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

    controller.scannedDataStream.listen((barcode) {
      if (!isScanning) {
        return;
      }
      setState(() {
        this.barcode = barcode;
      });

      if (barcode.code != null) {
        isScanning = false;
        controller.pauseCamera();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => buildResult(context),
        ).then((_) {
          isScanning = true;
          controller.resumeCamera();
        });
      }
    });
  }

  Widget buildResult(BuildContext context) {
    return AlertDialog(
      content: Text("${barcode!.code}"),
      actions: <Widget>[
        TextButton(
          child: Text("Back"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
