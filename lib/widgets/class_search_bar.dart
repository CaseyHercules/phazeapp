import 'package:flutter/material.dart';
import 'package:phazeapp/screens/edit_class_screen.dart';
import 'package:provider/provider.dart';

import '../models/class.dart';

class ClassSearchBar extends StatefulWidget {
  @override
  _ClassSearchBarState createState() => _ClassSearchBarState();
}

List<Class> _searchResults = [];

class _ClassSearchBarState extends State<ClassSearchBar> {
  @override
  void initState() {
    _searchResults = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final classes = Provider.of<Classes>(context);
    return Column(
      children: [
        ListTile(
          title: Form(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Class Search',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.none,
              keyboardType: TextInputType.text,
              keyboardAppearance: Theme.of(context).brightness,
              onChanged: (value) {
                _searchResults = classes.classesWithTitle(value);
                setState(() {
                  // print('C');
                  // classes.test();
                });
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditClassScreen.routeName, arguments: null);
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
                    title: Text('${_searchResults[i].title}'),
                    onTap: () {
                      Navigator.of(context).pushNamed(EditClassScreen.routeName,
                          arguments: _searchResults[i].classId);
                    },
                  ),
                  itemCount: _searchResults.length,
                ),
              ),
      ],
    );
  }
}
