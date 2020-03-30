import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kheabia/models/pointer.dart';
import 'package:kheabia/pages/doctors/analysis_data.dart';
import 'package:kheabia/utils/const.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_qr_scanner/QrScannerOverlayShape.dart';
import 'package:twitter_qr_scanner/twitter_qr_scanner.dart';

class GenerateCode extends StatefulWidget {
  final String course;

  const GenerateCode({Key key, this.course}) : super(key: key);

  @override
  _GenerateCodeState createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  String data;

  @override
  void initState() {
    super.initState();

    // ! Data must be like this  ( - subjectID - doctorID - date - )
    // ? starting and ending with parentheses ()
    // ? has space between each character
    // ? has 3 dash ( - )
    // ? date in format dd/mm/yyyy or mm/dd/yyyy

    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String formatted = formatter.format(now);
    print(formatted); // something like 20/04/2020
    data = '( - ${widget.course} - ${Pointer.currentDoctor.id} - $formatted )';
    print('>>>>>>>>>>>>   $data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        initialMode: QRMode.VIEWER,
        switchButtonColor: Const.mainColor,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderColor: Const.mainColor,
          borderLength: 120,
          borderWidth: 2,
          cutOutSize: 265,
        ),
        onQRViewCreated: _onQRViewCreate,
        data: data,
      ),
    );
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(
          () {
            Navigator.of(context).pushReplacement(
              PageTransition(
                child: AnalysisData(
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
}
