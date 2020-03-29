import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kheabia/pages/auth/forgot_password.dart';
import 'package:kheabia/pages/auth/login_page.dart';
import 'package:kheabia/pages/studients/home_page.dart';
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
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final String username;

  const MyApp({
    Key key,
    this.username,
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
      home: username == ''
          ? LoginPage()
          : StudientHomePage(
              username: username,
            ),
    );
  }
}
