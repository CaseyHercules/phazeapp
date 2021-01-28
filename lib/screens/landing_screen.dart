import 'package:flutter/material.dart';

import '../widgets/footer.dart';
import '../widgets/app_drawer.dart';

//Once Logged in, Store Login Key, Then pull skill database
//Needs to Check if connect

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page'),
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
