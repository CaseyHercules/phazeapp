import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/class.dart';

class SkillListScreen extends StatelessWidget {
  static const routeName = '/skill-list';

  void _fetchDataFromServer(BuildContext context) {
    Provider.of<Skills>(context, listen: false).fetchAndSetSkills();
    Provider.of<Classes>(context, listen: false).fetchAndSetClasses(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skill List Page'),
        actions: [
          IconButton(
              icon: Icon(Icons.update),
              onPressed: () => _fetchDataFromServer(context)),
        ],
      ),
      body: SizedBox(
        height: 10,
      ),
    );
  }
}
