import 'package:flutter/material.dart';
import 'package:kheabia/pages/studients/process_scaned_data.dart';
import 'package:kheabia/utils/const.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_qr_scanner/QrScannerOverlayShape.dart';
import 'package:twitter_qr_scanner/twitter_qr_scanner.dart';

class ScanCodePage extends StatefulWidget {
  @override
  _ScanCodePageState createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(
          () {
            Navigator.of(context).pushReplacement(
              PageTransition(
                child: ProcessScanedData(
                  data: scanData,
                ),
                type: PageTransitionType.scale,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        initialMode: QRMode.SCANNER,
        switchButtonColor: Const.mainColor,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderColor: Const.mainColor,
          borderLength: 120,
          borderWidth: 2,
          cutOutSize: 265,
        ),
        onQRViewCreated: _onQRViewCreate,
        data: "INVALID DATA",
      ),
    );
  }
}
