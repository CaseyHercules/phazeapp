import 'package:flutter/material.dart';
import 'package:phazeapp/config.dart';
import 'package:phazeapp/models/skill.dart';
import 'package:phazeapp/screens/editSkill.dart';
import 'package:provider/provider.dart';
import './screens/landing_screen.dart';

void main() => runApp(PhazeApp());

class PhazeApp extends StatefulWidget {
  @override
  _PhazeAppState createState() => _PhazeAppState();
}

class _PhazeAppState extends State<PhazeApp> {
  @override
  void initState() {
    currentTheme.addListener(() {
      print('Theme Color Changed');
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Skills()),
      ],
      child: MaterialApp(
        title: 'Interphaze App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.cyan[100],
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
        themeMode: ThemeMode.dark, //currentTheme.currentTheme(),
        initialRoute: LandingScreen.routeName,
        home: LandingScreen(),
        routes: {
          LandingScreen.routeName: (ctx) => LandingScreen(),
          EditSkill.routeName: (ctx) => EditSkill(),
        },
      ),
    );
  }
}
