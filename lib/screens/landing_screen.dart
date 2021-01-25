import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page'),
      ),
      body: Column(children: [
        Center(
          child: Image.network(
              'https://i1.wp.com/www.interphaze.org/wp-content/uploads/2017/10/InterphazeHeaderLogoClearBack.png?w=300&ssl=1'),
        )
        //Center(child: Image.file('/')),
      ]),
    );
  }
}
