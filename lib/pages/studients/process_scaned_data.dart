import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kheabia/models/pointer.dart';
import 'package:kheabia/utils/app_utils.dart';
import 'package:kheabia/utils/const.dart';

class ProcessScanedData extends StatefulWidget {
  final String data;

  // ! Data must be like this  ( - subjectID - doctorID - date - )
  // ? starting and ending with parenthes ()
  // ? has space between each character
  // ? has 4 dash ( - )
  // ? date in format dd/mm/yyyy or mm/dd/yyyy

  const ProcessScanedData({Key key, this.data}) : super(key: key);

  @override
  _ProcessScanedDataState createState() => _ProcessScanedDataState();
}

class _ProcessScanedDataState extends State<ProcessScanedData> {
  bool dataIsValid;
  bool networkIsActive = false;

  String date = '';
  String subjectCode = '';
  String doctorID = '';

  @override
  void initState() {
    super.initState();

    subscripToConnection();
  }

  subscripToConnection() async {
    networkIsActive = await AppUtils.getConnectionState();
    if (networkIsActive) {
      makeDataProcessing();
    } else {
      networkIsActive = false;
    }
  }

  void makeDataProcessing() {
    int numberOfHash = 0;
    int numberOfParenthes = 0;

    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i] == '-') {
        numberOfHash += 1;
      }
    }

    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i] == ')' || widget.data[i] == '(') {
        numberOfParenthes += 1;
      }
    }

    List<String> words = widget.data.split(' ');
    date = words[6];

    RegExp regExp = RegExp(
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$',
    );

    if (regExp.hasMatch(date)) {
      if (numberOfHash == 4 && numberOfParenthes == 2) {
        subjectCode = words[2];
        doctorID = words[4];

        registerStudent();
      } else {
        dataIsValid = false;
      }
    } else {
      dataIsValid = false;
    }
  }

  void registerStudent() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/mm/yyyy');
    String formatted = formatter.format(now);

    DocumentSnapshot snapshot = await Firestore.instance
        .collection('Subjects')
        .document(subjectCode)
        .collection('Students')
        .document(Pointer.currentStudent.id)
        .get();

    String lastRegesteredDate = snapshot.data['Last attendance'];
    if (lastRegesteredDate != formatted) {
      dataIsValid = true;
      int currentNumberOfTimes = int.parse(snapshot.data['numberOfTimes']);
      await Firestore.instance
          .collection('Subjects')
          .document(subjectCode)
          .collection('Students')
          .document(Pointer.currentStudent.id)
          .updateData(
        {
          'numberOfTimes': '${++currentNumberOfTimes}',
        },
      );
    } else {
      dataIsValid = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: networkIsActive
          ? dataIsValid == null
              ? Colors.white
              : dataIsValid == false ? Color(0xff4E497F) : Colors.white
          : Colors.white,
      body: networkIsActive
          ? dataIsValid == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : dataIsValid
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/true_data.jpg',
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(28),
                          ),
                          Text(
                            "تم تسجيل حضورك",
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(28),
                          ),
                          OutlineButton(
                            borderSide: BorderSide(color: Const.mainColor),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'خروج',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      color: Color(0xffF2F2F2),
                      height: ScreenUtil.screenHeight,
                      width: ScreenUtil.screenWidth,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/no_internet_connection.jpg',
                            ),
                            Text(
                              'لا يوجد اتصال بالانترنت',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
          : Container(
              color: Color(0xffF2F2F2),
              height: ScreenUtil.screenHeight,
              width: ScreenUtil.screenWidth,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/fake_data.jpg',
                    fit: BoxFit.cover,
                    width: ScreenUtil.screenWidth,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Text(
                    'بيانات غير صحيحة',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
