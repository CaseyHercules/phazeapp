import 'package:flutter/material.dart';
import '../widgets/skill_search_bar.dart';

// Needs To Pull data from server and not phone

enum ThingsThatCanBeEditied {
  Skills,
  Classes,
  Items,
  Spells,
  Players,
  Characters,
  Passport,
}

Widget _content = SkillSearchBar();

class ChooseEntry extends StatefulWidget {
  static const routeName = '/choose-entry';
  @override
  _ChooseEntryState createState() => _ChooseEntryState();
}

class _ChooseEntryState extends State<ChooseEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit or Add Skill'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Edit Skills'),
                value: ThingsThatCanBeEditied.Skills,
              ),
              PopupMenuItem(
                child: Text('Edit Classes'),
                value: ThingsThatCanBeEditied.Classes,
              ),
              // PopupMenuItem(
              //   child: Text('Spells'),
              //   value: ThingsThatCanBeEditied.Spells,
              // ),
              // PopupMenuItem(
              //   child: Text('Passport'),
              //   value: ThingsThatCanBeEditied.Passport,
              // ),
              // PopupMenuItem(
              //   child: Text('Characters'),
              //   value: ThingsThatCanBeEditied.Characters,
              // ),
              // PopupMenuItem(
              //   child: Text('Players'),
              //   value: ThingsThatCanBeEditied.Players,
              // ),
            ],
            onSelected: (ThingsThatCanBeEditied selectedValue) {
              setState(() {
                if (selectedValue == ThingsThatCanBeEditied.Skills) {
                  _content = SkillSearchBar();
                  // _formtype = Container(
                  //   height: 100,
                  //   width: 100,
                  //   color: Colors.white,
                  // );
                }
                if (selectedValue == ThingsThatCanBeEditied.Classes) {
                  //searchBar = ClassSearchBar();
                }
                // if (selectedValue == ThingsThatCanBeEditied.Spells) {
                //   //
                // }
                // if (selectedValue == ThingsThatCanBeEditied.Passport) {
                //   //
                // }
                // if (selectedValue == ThingsThatCanBeEditied.Characters) {
                //   //
                // }
                // if (selectedValue == ThingsThatCanBeEditied.Players) {
                //   //
                // }
              });
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: _content,
    );
  }
}
