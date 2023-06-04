import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
            Navigator.pushNamed(
              context,
              QRScanner.routeName,
              // Pass the userInfo parameter
            );
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

        Map<String, dynamic>? qrData;
        Map<String, dynamic> userInfo;
        try {
          qrData = jsonDecode(barcode.code!) as Map<String, dynamic>;
        } catch (e) {
          print("Failed to decode qrcode: $e");
        }

        if (qrData != null) {
          userInfo = qrData['userInfo'];
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) =>
                buildResult(context, userInfo), // Pass userInfo to buildResult
          ).then((_) {
            isScanning = true;
            controller.resumeCamera();
          });
        } else {
          isScanning = true;
          controller.resumeCamera();
        }
      }
    });
  }

  Widget buildResult(BuildContext context, Map<String, dynamic> userInfo) {
    // Accept userInfo as a nullable parameter
    final String username = userInfo['userName'];
    List<dynamic> conditionData = userInfo['condition'] as List<dynamic>;
    List<String> conditionList =
        conditionData.map((item) => item.toString()).toList();

    List<dynamic> allergiesData = userInfo['allergies'] as List<dynamic>;
    List<String> allergiesList =
        allergiesData.map((item) => item.toString()).toList();

    IskolarInfo details = IskolarInfo(
      status: IskolarHealthStatus.monitored,
      firstName: userInfo['firstName'],
      lastName: userInfo['lastName'],
      userName: userInfo['userName'],
      studentNumber: userInfo['studentNumber'],
      course: userInfo['course'],
      college: userInfo['college'],
      condition: conditionList,
      allergies: allergiesList,
    );

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28.0,
      ),
      icon: Icon(Symbols.face_rounded, size: 48.0),
      title: Text("User Found!"),
      content: Text(
        "Do you want to view the details of ${details.firstName}?",
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
      actionsAlignment: MainAxisAlignment.spaceEvenly,

      actions: <Widget>[
        TextButton.icon(
          onPressed: () {
            UserDetails.showSheet(context, details);
          },
          icon: const Icon(Symbols.check_rounded),
          label: const Text('Show details'),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Symbols.close_rounded),
          label: const Text('Cancel'),
        )
      ], // Display userInfo as a string or an error message
    );
  }
}
