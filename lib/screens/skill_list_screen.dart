import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/class.dart';

late List<Skill> skills;
bool _isLoading = true;
bool _testing = true;

Future<void> _fetchData(BuildContext context) async {
  try {
    Provider.of<Skills>(context, listen: false).fetchAndSetSkills().then(
        (value) => skills = Provider.of<Skills>(context, listen: false).skills);
    Provider.of<Classes>(context, listen: false).fetchAndSetClasses(context);
  } catch (e) {
    print('Error: $e');
  }
}

List _processSkills(List<Skill> s) {
  var skillGroups = [];

  //Separate Skills into Skill Groups
  s.forEach((s) {
    if (s.skillGroupName == null || s.skillGroupName == '') {
      skillGroups.add(s.title);
    } else {
      if (!(skillGroups.contains(s.skillGroupName))) {
        skillGroups.add(s.skillGroupName);
      }
    }
  });
  // print('Skill Group Lenght: ${skillGroups.length}');
  // skillGroups.forEach((s) {
  //   print('$s');
  // });
  return skillGroups;
}

class SkillListScreen extends StatefulWidget {
  static const routeName = '/skill-list';

  @override
  _SkillListScreenState createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  @override
  // void didChangeDependencies() {
  //   _fetchData(context).then((value) {
  //     setState(() {});
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    try {
      //Do not Delete as makes the try attempt happen
      print(skills.length);
      _isLoading = false;
    } catch (e) {
      _fetchData(context).then((value) {
        setState(() {});
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Skill List Page'),
          // actions: [
          //   IconButton(
          //       icon: Icon(Icons.update), onPressed: () => _fetchData(context)),
          // ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _testing
                ? SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: SkillGroupsViewWidget(allSkills: skills)),
                  )
                : ListView.builder(
                    itemCount: skills.length,
                    itemBuilder: (ctx, i) => SkillViewWidget(s: skills[i])));
  }
}

class SkillViewWidget extends StatelessWidget {
  const SkillViewWidget({
    Key? key,
    required this.s,
  }) : super(key: key);

  final Skill s;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text(s.title),
        subtitle:
            s.skillGroupName == null ? Text('') : Text(s.skillGroupName!));
  }
}

class SkillGroupsViewWidget extends StatelessWidget {
  SkillGroupsViewWidget({
    Key? key,
    required this.allSkills,
  }) : super(key: key);

  final List<Skill> allSkills;

  @override
  Widget build(BuildContext context) {
    //print('Hello: ${allSkills.where((s) => s.skillGroupName == '1').length}');
    //Process Skills into skill groups
    final List skillGroups = _processSkills(allSkills);
    print('');
    return ListView.builder(
      shrinkWrap: true,
      itemCount: skillGroups.length,
      itemBuilder: (ctx, i) => (allSkills
                      .where((s) =>
                          s.skillGroupName == skillGroups[i] ||
                          s.title == skillGroups[i])
                      .length ==
                  1 &&
              (allSkills
                          .where((s) =>
                              s.skillGroupName == skillGroups[i] ||
                              s.title == skillGroups[i])
                          .first
                          .skillGroupName
                          .toString() ==
                      'null' ||
                  allSkills
                          .where((s) =>
                              s.skillGroupName == skillGroups[i] ||
                              s.title == skillGroups[i])
                          .first
                          .skillGroupName
                          .toString() ==
                      ''))
          ? ExpansionTile(
              title: Text(
                allSkills.firstWhere((s) => skillGroups[i] == s.title).title,
                style: Theme.of(context).textTheme.headline6,
              ),
              collapsedBackgroundColor: Theme.of(context).backgroundColor,
              children: [
                RenderSkillWidget(
                  skill: allSkills.firstWhere((s) => skillGroups[i] == s.title),
                )
              ], //Draw Skill
            )
          : ExpansionTile(
              title: Text(
                skillGroups[i],
                style: Theme.of(context).textTheme.headline6,
              ),
              collapsedBackgroundColor: Theme.of(context).backgroundColor,
              //backgroundColor: Theme.of(context).backgroundColor,
              children: [
                (allSkills
                                .where((s) =>
                                    s.skillGroupName == skillGroups[i] ||
                                    s.title == skillGroups[i])
                                .first
                                .skillGroupDescription
                                .toString() ==
                            'null' ||
                        allSkills
                                .where((s) =>
                                    s.skillGroupName == skillGroups[i] ||
                                    s.title == skillGroups[i])
                                .first
                                .skillGroupDescription
                                .toString() ==
                            '')
                    ? SizedBox()
                    : RenderSkillWidget(
                        skill: allSkills
                            .where((s) =>
                                s.skillGroupName == skillGroups[i] ||
                                s.title == skillGroups[i])
                            .first,
                        isSkillGroupDesc: true,
                      ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: allSkills
                      .where((s) =>
                          s.skillGroupName == skillGroups[i] ||
                          s.title == skillGroups[i])
                      .length,
                  itemBuilder: (ctx, j) {
                    return Column(
                      children: [
                        RenderSkillWidget(
                          skill: allSkills
                              .where((s) =>
                                  s.skillGroupName == skillGroups[i] ||
                                  s.title == skillGroups[i])
                              .elementAt(j),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
    );
  }
}

class RenderSkillWidget extends StatelessWidget {
  RenderSkillWidget({
    Key? key,
    required this.skill,
    this.isSkillGroupDesc = false,
  }) : super(key: key);

  final Skill skill;
  final bool isSkillGroupDesc;

  @override
  Widget build(BuildContext context) {
    return isSkillGroupDesc
        ? Container(
            child: ListTile(
              title: Text(
                skill.skillGroupDescription.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Container(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Tier ' +
                        skill.tier.toString() +
                        ' - ' +
                        skill.title.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  dense: true,
                ),
                ListTile(
                  title: Text(
                    '    ' + skill.description,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  dense: true,
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  // Cost
                  title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: 'Cost: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: skill.permenentEpReduction == 0
                                  ? skill.epCost.toString()
                                  : 'Permanent Ep reduction of ${skill.permenentEpReduction}'),
                        ]),
                  ),
                  dense: true,
                ),
                ListTile(
                  // Activation
                  title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: 'Activation: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: skill.activation),
                        ]),
                  ),
                  dense: true,
                ),
                ListTile(
                  // Duration
                  title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: 'Duration: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: skill.duration),
                        ]),
                  ),
                  dense: true,
                ),
                ListTile(
                  // Ability Check
                  title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text: 'Ability Check: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: skill.abilityCheck),
                        ]),
                  ),
                  dense: true,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          );
  }
}
