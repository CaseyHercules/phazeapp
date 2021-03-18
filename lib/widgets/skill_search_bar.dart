import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_skill_screen.dart';
import '../models/skill.dart';

class SkillSearchBar extends StatefulWidget {
  @override
  _SkillSearchBarState createState() => _SkillSearchBarState();
}

List<Skill> _searchResults = [];

class _SkillSearchBarState extends State<SkillSearchBar> {
  @override
  void initState() {
    _searchResults = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Skills>(context, listen: false).fetchAndSetSkills();
    final skills = Provider.of<Skills>(context);
    return Column(
      children: [
        ListTile(
          title: Form(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Skill Search',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.none,
              keyboardType: TextInputType.text,
              keyboardAppearance: Theme.of(context).brightness,
              onChanged: (value) {
                _searchResults = skills.skillsWithTitle(value);
                setState(() {});
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditSkillScreen.routeName, arguments: null);
            },
          ),
        ),
        !(_searchResults.length > 0)
            ? SizedBox(
                height: 0,
              )
            : Container(
                height: 50 * _searchResults.length.toDouble(),
                color: Theme.of(context).backgroundColor,
                child: ListView.builder(
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text((_searchResults[i].skillGroupName == '' ||
                            _searchResults[i].skillGroupName == null)
                        ? '${_searchResults[i].title} ${_searchResults[i].tier}'
                        : '${_searchResults[i].skillGroupName} --> ${_searchResults[i].title} ${_searchResults[i].tier}'),
                    onTap: () {
                      Navigator.of(context).pushNamed(EditSkillScreen.routeName,
                          arguments: _searchResults[i].id);
                    },
                  ),
                  itemCount: _searchResults.length,
                ),
              ),
      ],
    );
  }
}
