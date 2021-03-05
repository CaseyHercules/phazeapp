import 'package:flutter/material.dart';
import '../widgets/skill_search_bar.dart';
import '../widgets/class_search_bar.dart';

import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/class.dart';

// Needs To Pull data from server and not phone
var _titleBarText = 'Edit or Add Skills';

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
    Provider.of<Skills>(context, listen: false).fetchAndSetSkills();
    Provider.of<Classes>(context, listen: false).fetchAndSetClasses(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleBarText),
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
                  _titleBarText = 'Edit or Add Skills';
                }
                if (selectedValue == ThingsThatCanBeEditied.Classes) {
                  _content = ClassSearchBar();
                  _titleBarText = 'Edit or Add Classes';
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
