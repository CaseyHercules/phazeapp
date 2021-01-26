import 'package:flutter/material.dart';
import 'package:phazeapp/screens/landing_screen.dart';

void main() => runApp(PhazeApp());

class PhazeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interphaze App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[100],
        accentColor: Colors.blueGrey[900],
        backgroundColor: Colors.grey[50],
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontSize: 20,
            // fontFamily:
          ),
          subtitle2: TextStyle(
            color: Colors.black,
            fontSize: 12,
            // fontFamily:
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        accentColor: Colors.grey[100],
        backgroundColor: Colors.grey[900],
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 20,
            // fontFamily:
          ),
          subtitle2: TextStyle(
            color: Colors.white,
            fontSize: 12,
            // fontFamily:
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: LandingScreen.routeName,
      home: LandingScreen(),
      routes: {
        LandingScreen.routeName: (ctx) => LandingScreen(),
      },
    );
  }
}
