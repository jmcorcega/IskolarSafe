import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:iskolarsafe/screens/home/logs.dart';

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
      alignment: Alignment.center,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: MediaQuery.of(context).size.height * 0.080,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 100.0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Symbols.close_rounded),
          ),
        ],
      ),
      content: Column(
        children: [
          Text("User found!"),
        ],
      ),
      actions: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle button press
                // Example: Perform an action or navigate to another screen
                ;
              },
              child: Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle button press
                // Example: Perform an action or navigate to another screen
                UserDetails.showSheet(context, details);
              },
              child: Text("No"),
            ),
          ],
        )
      ], // Display userInfo as a string or an error message
    );
  }
}
