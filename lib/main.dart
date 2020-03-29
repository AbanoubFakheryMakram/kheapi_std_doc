import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kheabia/pages/auth/login_page.dart';
import 'package:kheabia/pages/doctors/doctor_home_page.dart';
import 'package:kheabia/pages/studients/student_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SharedPreferences.getInstance().then(
    (pref) {
      runApp(
        MyApp(
          username: pref.getString('username') ?? '',
          type: pref.getString('type') ?? '1',
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final String username;
  final String type;

  const MyApp({
    Key key,
    this.username,
    this.type,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'غيابي',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DoctorHomePage(
          username: '7000551101',
        ));
  }
}

/*
*
* username == ''
          ? LoginPage()
          : type == '1'
              ? StudentHomePage(
                  username: username,
                )
              : DoctorHomePage(
                  username: username,
                ),*/
