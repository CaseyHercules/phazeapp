import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/class.dart';

late List<Skill> skills;
bool _isLoading = true;
//bool _testing = true;

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
  //Removes Skills With Parent Skills from Group
  //Separate Skills into Skill Groups
  s.forEach((s) {
    if (s.parentSkill == null) {
      if (s.skillGroupName == null || s.skillGroupName == '') {
        skillGroups.add(s.title);
      } else {
        if (!(skillGroups.contains(s.skillGroupName))) {
          skillGroups.add(s.skillGroupName);
        }
      }
    }
  });
  return skillGroups;
}

List _processChildSkills(List<Skill> s) {
  var skillGroups = [];
  //Removes Skills With Parent Skills from Group
  //Separate Skills into Skill Groups
  s.forEach((s) {
    if (s.parentSkill != null) {
      if (s.skillGroupName == null || s.skillGroupName == '') {
        skillGroups.add(s.title);
      } else {
        if (!(skillGroups.contains(s.skillGroupName))) {
          skillGroups.add(s.skillGroupName);
        }
      }
    }
  });
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
          : SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: SkillGroupsViewWidget(allSkills: skills)),
            ),
    );
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
    final List skillGroups = _processSkills(allSkills);
    //Process Skills into skill groups

    return ListView.builder(
      shrinkWrap: true,
      primary: true,
      itemCount: skillGroups.length,
      itemBuilder: (ctx, i) => (allSkills
                  .where((t) => (t.parentSkill != null))
                  .where((u) =>
                      u.parentSkill?.id ==
                      (allSkills
                          .where((s) =>
                              (s.skillGroupName == skillGroups[i] ||
                                  s.title == skillGroups[i]) &&
                              s.parentSkill == null)
                          .first
                          .id))
                  .length !=
              0)
          // Test for if skill has parent Skill, then ignores them
          // Logic, Get List of All Skill that have a parent, Then, Return an array of skills' parent skill ids that match the id of the current Skill being Checked.
          // ID: (allSkills.where((s) => (s.skillGroupName == skillGroups[i] || s.title == skillGroups[i]) && s.parentSkill == null).first.id)
          ? ExpansionTile(
              //Render Parent and Children Group of Skills TODO FINISH
              title: Text(
                allSkills
                    .firstWhere((s) => (skillGroups[i] == s.title ||
                        s.skillGroupName == skillGroups[i]))
                    .title,
                style: Theme.of(context).textTheme.headline6,
              ),
              collapsedBackgroundColor: Theme.of(context).backgroundColor,
              children: [
                //TODO If skill group Exists, Render
                //TODO Render Parent Skill
                //TODO Get Skill Groups of children
                //TODO Make list of ExpandTiles, Per Each Skill Group
                //For Each Skill group Render Each Skill in each group
                RenderSkillWidget(
                  skill: allSkills.firstWhere((s) =>
                      s.skillGroupName == skillGroups[i] ||
                      s.title == skillGroups[i]),
                  childrenSkills: [
                    ...allSkills
                        .where((t) => (t.parentSkill != null))
                        .where((u) =>
                            u.parentSkill?.id ==
                            (allSkills
                                .where((s) =>
                                    (s.skillGroupName == skillGroups[i] ||
                                        s.title == skillGroups[i]) &&
                                    s.parentSkill == null)
                                .first
                                .id))
                        .toList()
                  ],
                )
              ],
            )
          //Test if skill group only has one skill in it.
          : (allSkills.where((s) => s.skillGroupName == skillGroups[i] || s.title == skillGroups[i]).length ==
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
              // Render Single skill in skill group
              ? ExpansionTile(
                  title: Text(
                    allSkills
                        .firstWhere((s) => skillGroups[i] == s.title)
                        .title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  collapsedBackgroundColor: Theme.of(context).backgroundColor,
                  children: [
                    RenderSkillWidget(
                      skill: allSkills
                          .firstWhere((s) => skillGroups[i] == s.title),
                    )
                  ],
                ) // Render Skill group with multi skills
              : ExpansionTile(
                  title: Text(
                    skillGroups[i],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  collapsedBackgroundColor: Theme.of(context).backgroundColor,
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
                                '') // If skill group desc is null or '' Make nothing, Else render a Skillgroup desc box
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
  RenderSkillWidget(
      {Key? key,
      required this.skill,
      this.isSkillGroupDesc = false,
      this.childrenSkills})
      : super(key: key);

  final Skill skill;
  final bool isSkillGroupDesc;
  final List<Skill>? childrenSkills;
  //final bool childrenSkills;

  @override
  Widget build(BuildContext context) {
    var hasChildren = false;
    late List skillGroups;

    try {
      hasChildren = childrenSkills!.length > 0;
      // print(
      //     'TITLE: ${skill.title} And ChildrenSkills Length is: ${childrenSkills!.length}');
      skillGroups = _processChildSkills(childrenSkills!);
    } catch (e) {
      //Do Nothing
      hasChildren = false;
      print('TITLE: ${skill.title}');
    }

    return isSkillGroupDesc
        ? Container(
            child: ListTile(
              title: Text(
                skill.skillGroupDescription.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : hasChildren //Render Parent Skill and It's Children
            ? Column(
                children: [
                  (skill.skillGroupDescription == null ||
                          skill.skillGroupDescription == '')
                      ? SizedBox()
                      : RenderSkillWidget(
                          skill: skill,
                          isSkillGroupDesc: true,
                        ),
                  // Render Skill group desc if it exists
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: skillGroups.length,
                      itemBuilder: (ctx, i) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: ExpansionTile(
                            title: Text(skillGroups[i]),
                            collapsedBackgroundColor:
                                Theme.of(context).backgroundColor,
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: childrenSkills!
                                      .where((s) =>
                                          s.skillGroupName == skillGroups[i] ||
                                          s.title == skillGroups[i])
                                      .length,
                                  itemBuilder: (ctx, j) {
                                    return RenderSkillWidget(
                                      skill: childrenSkills!
                                          .where((s) =>
                                              s.skillGroupName ==
                                                  skillGroups[i] ||
                                              s.title == skillGroups[i])
                                          .elementAt(j),
                                    );
                                  })
                            ],
                          ),
                        );
                      }),
                ],
              ) //TODO Make Thing for parent Skills
            : Container(
                //Render Non-parent Skills
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
