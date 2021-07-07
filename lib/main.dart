import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_call/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      systemNavigationBarIconBrightness: Brightness.dark,
//        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kopup',
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Root(),
    );
  }
}