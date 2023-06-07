import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  static const String routeName = "/scanner";

  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var permission = Permission.camera.status;
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
      body: FutureBuilder(
        future: permission,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == PermissionStatus.denied) {
            Fluttertoast.showToast(
                msg:
                    "Camera permissions denied. Please allow camera access to scan entries.");
            Navigator.pop(context, null);
          }

          return Center(
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                      cutOutSize: MediaQuery.of(context).size.width * 0.75,
                      borderLength: 40,
                      borderWidth: 10,
                      borderRadius: 18,
                      cutOutBottomOffset:
                          MediaQuery.of(context).size.height * 0.075,
                      borderColor:
                          Theme.of(context).colorScheme.inversePrimary),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: Text(
                    "Point your device to a valid entry QR code.",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          color: Colors.black.withAlpha((255 * 0.5).toInt()),
                        ),
                      ],
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    DateTime? lastScan;
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      final currentScan = DateTime.now();

      if (!isScanning) {
        return;
      }

      if (lastScan == null ||
          currentScan.difference(lastScan!) > const Duration(seconds: 3)) {
        lastScan = currentScan;
      } else {
        return;
      }

      setState(() {
        this.barcode = barcode;
      });

      if (barcode.code != null && barcode.code is String) {
        isScanning = false;
        HealthEntry entry;

        try {
          Map<String, dynamic>? qrData =
              jsonDecode(barcode.code!) as Map<String, dynamic>;
          entry = HealthEntry.fromJson(qrData);
        } catch (e) {
          Fluttertoast.showToast(msg: "Invalid entry QR code.");
          isScanning = true;
          return;
        }

        controller.pauseCamera();
        Navigator.pop(context, entry);
      } else {
        isScanning = true;
        controller.resumeCamera();
      }
    });
  }
}
