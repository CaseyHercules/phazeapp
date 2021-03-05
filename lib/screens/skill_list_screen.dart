import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/class.dart';

late List<Skill> skills;
bool _isLoading = true;
var length = 0;

class SkillListScreen extends StatefulWidget {
  static const routeName = '/skill-list';

  @override
  _SkillListScreenState createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  @override
  void didChangeDependencies() {
    _fetchData(context).then((value) {
      _isLoading = false;
      setState(() {});
    });
    super.didChangeDependencies();
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<Skills>(context, listen: false).fetchAndSetSkills().then(
        (value) => skills = Provider.of<Skills>(context, listen: false).skills);
    Provider.of<Classes>(context, listen: false).fetchAndSetClasses(context);
  }

  @override
  Widget build(BuildContext context) {
    print('build');
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
            : ListView.builder(
                itemCount: length, itemBuilder: (ctx, i) => SizedBox()));
  }
}
