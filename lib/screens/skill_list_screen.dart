import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/class.dart';

late List<Skill> skills;
bool _isLoading = true;
bool _testing = true;

Future<void> _fetchData(BuildContext context) async {
  Provider.of<Skills>(context, listen: false).fetchAndSetSkills().then(
      (value) => skills = Provider.of<Skills>(context, listen: false).skills);
  Provider.of<Classes>(context, listen: false).fetchAndSetClasses(context);
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
  print('Skill Group Lenght: ${skillGroups.length}');
  skillGroups.forEach((s) {
    print('$s');
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
          actions: [
            IconButton(
                icon: Icon(Icons.update), onPressed: () => _fetchData(context)),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _testing
                ? SkillGroupsViewWidget(allSkills: skills)
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
    //Process Skills into skill groups
    final List skillGroups = _processSkills(allSkills);
    print(skillGroups);
    return ListView.builder(
        itemCount: skillGroups.length,
        itemBuilder: (ctx, i) => ExpansionTile(
              title: Text(skillGroups[i]),
              children: [Text('hello')],
            ));
  }
}
