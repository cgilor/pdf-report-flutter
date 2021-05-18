import 'package:flutter/material.dart';
import 'package:new_pdf_report/pages/home_page.dart';
import 'package:new_pdf_report/pages/photo_report.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My PDF reports',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'photo': (_) => PhotoReport(),
      },
    );
  }
}
