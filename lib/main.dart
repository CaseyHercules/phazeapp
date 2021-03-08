import 'package:flutter/material.dart';
import 'package:phazeapp/screens/edit_class_screen.dart';
import 'package:phazeapp/screens/edit_skill_screen.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import './models/skill.dart';
import './models/class.dart';
import './screens/choose_entry.dart';
import './screens/landing_screen.dart';
import './screens/skill_list_screen.dart';

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
        ChangeNotifierProvider(create: (ctx) => Classes()),
      ],
      child: MaterialApp(
        title: 'Interphaze App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.cyan[100],
          accentColor: Colors.blueGrey[900],
          backgroundColor: Colors.grey[50],
          fontFamily: 'Gentium Book Basic',
          textTheme: TextTheme(
            headline4: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'Gentium Book Basic'),
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 20,
              // fontFamily:
            ),
            subtitle2: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              // fontFamily:
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.amber,
          accentColor: Colors.grey[700],
          backgroundColor: Colors.grey[900],
          fontFamily: 'Gentium Book Basic',
          textTheme: TextTheme(
            headline4: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Gentium Book Basic'),
            headline5: TextStyle(
              color: Colors.black,
              fontSize: 16,
              // fontFamily:
            ),
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20,
              // fontFamily:
            ),
            subtitle2: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              // fontFamily:
            ),
            subtitle1: TextStyle(
              //Text on form size
              color: Colors.white,
              fontSize: 18,
              // fontFamily:
            ),
          ),
          //inputDecorationTheme:
        ),
        themeMode: ThemeMode.dark, //currentTheme.currentTheme(),
        initialRoute: LandingScreen.routeName,
        home: LandingScreen(),
        routes: {
          LandingScreen.routeName: (ctx) => LandingScreen(),
          ChooseEntry.routeName: (ctx) => ChooseEntry(),
          EditSkillScreen.routeName: (ctx) => EditSkillScreen(),
          EditClassScreen.routeName: (ctx) => EditClassScreen(),
          SkillListScreen.routeName: (ctx) => SkillListScreen(),
        },
      ),
    );
  }
}
