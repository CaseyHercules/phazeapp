import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Interphaze Mobile'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.list,
              color: Theme.of(context).accentColor,
              semanticLabel: 'Class Skill List',
            ),
            title: Text('Class Skill List'),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.gavel,
              color: Theme.of(context).accentColor,
              semanticLabel: 'Judge\'s Area',
            ),
            title: Text('Judge\'s Area'),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed();
            },
          ),
        ],
      ),
    );
  }
}
