import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';

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

class EditSkill extends StatefulWidget {
  static const routeName = '/editSkill';
  @override
  _EditSkillState createState() => _EditSkillState();
}

class _EditSkillState extends State<EditSkill> {
  var editedSkill = Skill(
    id: null,
    title: '',
    description: '',
    descriptionShort: '',
    tier: null,
    parentSkill: null,
    skillGroupName: '',
    prerequisiteSkills: null,
    permenentEpReduction: null,
    epCost: '',
    activation: '',
    duration: '',
    abilityCheck: '',
    canBeTakenMultiple: null,
    playerVisable: null,
  );

  List<Skill> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    final skills = Provider.of<Skills>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Skill'),
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
                    //
                  }
                  if (selectedValue == ThingsThatCanBeEditied.Classes) {
                    //
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
        body: Column(
          children: [
            ListTile(
              title: Form(
                child: TextFormField(
                  //autofocus: true,
                  decoration: InputDecoration(labelText: 'Skill Search'),
                  textInputAction: TextInputAction.none,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Theme.of(context).brightness,
                  onChanged: (value) {
                    _searchResults = skills.skillsWithTitle(value);
                    setState(() {
                      //print(skills.skillsWithTitle(value).toString());
                    });
                  },
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ),
            !(_searchResults.length > 0)
                ? SizedBox(
                    height: 0,
                  )
                : Container(
                    height: 50 * _searchResults.length.toDouble(),
                    //width: 100,
                    color: Colors.black,
                    child: ListView.builder(
                      itemBuilder: (ctx, i) => ListTile(
                        title: Text('${_searchResults[i].title}'),
                      ),
                      itemCount: _searchResults.length,
                    ),
                  )
          ],
        ));
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
