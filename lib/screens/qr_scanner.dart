import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/screens/home/logs.dart';
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
              Logs.routeName,
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
      body: Center(
        child: Expanded(
          flex: 5,
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
                    borderColor: Theme.of(context).colorScheme.inversePrimary),
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
        ),
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

      if (barcode.code != null && barcode.code is String) {
        isScanning = false;
        controller.pauseCamera();

        Map<String, dynamic>? qrData;
        Map<String, dynamic> userInfo;

        qrData = jsonDecode(barcode.code!) as Map<String, dynamic>;

        userInfo = qrData['userInfo'];
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => buildResult(context, userInfo),
        ).then((_) {
          isScanning = true;
          controller.resumeCamera();
        });
      } else {
        isScanning = true;
        controller.resumeCamera();
      }
    });
  }

  Widget buildResult(BuildContext context, Map<String, dynamic> userInfo) {
    List<dynamic> conditionData = userInfo['condition'] as List<dynamic>;
    List<String> conditionList =
        conditionData.map((item) => item.toString()).toList();

    List<dynamic> allergiesData = userInfo['allergies'] as List<dynamic>;
    List<String> allergiesList =
        allergiesData.map((item) => item.toString()).toList();

    IskolarInfo details = IskolarInfo(
        status: IskolarHealthStatus.healthy,
        firstName: userInfo['firstName'],
        lastName: userInfo['lastName'],
        userName: userInfo['userName'],
        studentNumber: userInfo['studentNumber'],
        course: userInfo['course'],
        college: userInfo['college'],
        condition: conditionList,
        allergies: allergiesList,
        type: userInfo['type'] == 'student'
            ? IskolarType.student
            : userInfo['type'] == 'monitor'
                ? IskolarType.monitor
                : IskolarType.admin,
        photoUrl: userInfo['photoUrl']);

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
      ],
    );
  }
}
