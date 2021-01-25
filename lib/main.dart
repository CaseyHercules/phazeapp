import 'package:flutter/material.dart';
import 'package:phazeapp/screens/landing_screen.dart';

void main() => runApp(PhazeApp());

class PhazeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interphaze App',
      theme: ThemeData(primaryColor: Colors.amber, accentColor: Colors.black87),
      initialRoute: LandingScreen.routeName,
      home: LandingScreen(),
      routes: {
        LandingScreen.routeName: (ctx) => LandingScreen(),
        //'/welcome': (context) => WelcomeScreen(),
      },
    );
  }
}
