import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/footer.dart';
import '../widgets/app_drawer.dart';
import '../models/skill.dart';
import '../models/class.dart';

//Once Logged in, Store Login Key, Then pull skill database
//Needs to Check if connect

void _fetchDataFromServer(BuildContext context) {
  try {
    Provider.of<Skills>(context, listen: false)
        .fetchAndSetSkills(forceRefresh: false);
    Provider.of<Classes>(context, listen: false).fetchAndSetClasses(context);
  } catch (e) {
    print(e);
  }
}

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page'),
        actions: [
          IconButton(
              icon: Icon(Icons.update),
              onPressed: () => _fetchDataFromServer(context)),
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(children: [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    child: Image.asset(
                      'assets/images/InterphazeHeaderLogoWhiteBack.png',
                      height: 150,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      'Interphaze Mobile App',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: Footer(),
    );
  }
}
