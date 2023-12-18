import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_page/Views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 42,
              vertical: 20
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: Color(0xFF757575),
              ),
              gapPadding: 10
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: Color(0xFF757575),
              ),
              gapPadding: 10
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: Color(0xFF757575),
              ),
              gapPadding: 10
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0, systemOverlayStyle: SystemUiOverlayStyle.dark, toolbarTextStyle: TextTheme(
            headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
          ).bodyText2, titleTextStyle: TextTheme(
            headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
          ).headline6,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Muli",
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color(0xFF757575)),
          bodyText2: TextStyle(color : Color(0xFF757575))
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PageSplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}