import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kheabia/animations/splash_tap.dart';
import 'package:kheabia/models/pointer.dart';
import 'package:kheabia/models/user.dart';
import 'package:kheabia/pages/auth/login_page.dart';
import 'package:kheabia/pages/studients/scan_code_page.dart';
import 'package:kheabia/utils/app_utils.dart';
import 'package:kheabia/utils/const.dart';
import 'package:kheabia/utils/firebase_methods.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'absence_review.dart';

class StudientHomePage extends StatefulWidget {
  final String username;

  const StudientHomePage({Key key, this.username}) : super(key: key);

  @override
  _StudientHomePageState createState() => _StudientHomePageState();
}

class _StudientHomePageState extends State<StudientHomePage> {
  bool networkIsActive = false;

  @override
  void initState() {
    super.initState();

    subscripToConnection();
  }

  void loadUserData() async {
    DocumentSnapshot snapshot = await FirebaseUtils.getCurrentUserData(
      username: widget.username,
    );

    User currentUser = User.fromMap(snapshot.data);
    Pointer.currentUser = currentUser;
  }

  subscripToConnection() {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        networkIsActive = AppUtils.getNetworkState(result);
        if (networkIsActive) {
          loadUserData();
        }
        setState(
          () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      allowFontScaling: true,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
    return Scaffold(
      appBar: networkIsActive
          ? AppBar(
              backgroundColor: Const.mainColor,
              title: Text(
                'غيابي',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.error_outline,
                  ),
                  onPressed: () {
                    AppUtils.showDialog(
                      context: context,
                      title: 'تسجيل الخروج',
                      negativeText: 'الغاء',
                      positiveText: 'تاكيد',
                      onPositiveButtonPressed: () {
                        SharedPreferences.getInstance().then(
                          (pref) {
                            pref.clear();
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => LoginPage(),
                              ),
                            );
                          },
                        );
                      },
                      contentText: 'هل تريد تسجيل الخروج؟',
                    );
                  },
                ),
              ],
            )
          : null,
      body: networkIsActive
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        15,
                      ),
                    ),
                    SlideInDown(
                      child: Pointer.currentUser.name == null
                          ? CircularProgressIndicator()
                          : Text(
                              '${Pointer.currentUser.name ?? ''}',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold,
                                color: Const.mainColor,
                                fontSize: 22,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        15,
                      ),
                    ),
                    FadeInLeft(
                      child: _buldCards(
                        imageAsset: 'assets/images/1.jpg',
                        text: 'فحـص الكود',
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: ScanCodePage(),
                              type: PageTransitionType.downToUp,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        15,
                      ),
                    ),
                    FadeInRight(
                      child: _buldCards(
                        imageAsset: 'assets/images/2.jpg',
                        text: 'مراجعة الغياب',
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: AbsenceReview(),
                              type: PageTransitionType.downToUp,
                            ),
                          );
                        },
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
            ),
    );
  }

  Widget _buldCards({
    String imageAsset,
    String text,
    Function onTap,
  }) {
    return Splash(
      onTap: onTap,
      maxRadius: 180,
      splashColor: Const.mainColor,
      child: Container(
        height: ScreenUtil().setHeight(
          190,
        ),
        margin: EdgeInsets.all(
          ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(0, 3),
              blurRadius: 3,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              height: ScreenUtil().setHeight(
                130,
              ),
              width: ScreenUtil.screenWidth,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(4),
            ),
            Center(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontWeight: FontWeight.bold,
                  color: Const.mainColor,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
