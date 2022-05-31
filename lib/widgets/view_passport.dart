import 'package:flutter/material.dart';
import 'package:phazeapp/models/passport.dart';

class ViewPassport extends StatelessWidget {
  final Passport? passport;
  const ViewPassport({Key? key, @required this.passport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 34,
            ),
            Container(
                width: MediaQuery.of(context).size.width * .8,
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text(
                            '=== ${passport?.name} ===',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )))),
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .9), //Media
                child: Card(
                    child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                      'Special Ability: ${passport?.specialAbility == null ? 'None' : passport?.specialAbility}'),
                ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                        //TODO Replace with Stat List Widget
                        height: 150,
                        width: MediaQuery.of(context).size.width * .3,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .3,
                        ), //Media
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Attack: TODO ATTACK'),
                        ))),
                    Container(
                        //TODO Replace with Stat List Widget
                        height: 150,
                        width: MediaQuery.of(context).size.width * .3,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .3,
                        ), //Media
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Defence: TODO Defence'),
                        ))),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        //TODO Replace with Stat List Widget
                        height: 150,
                        width: MediaQuery.of(context).size.width * .3,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .3,
                        ), //Media
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Accuracy: TODO Accuracy'),
                        ))),
                    Container(
                        //TODO Replace with Stat List Widget
                        height: 150,
                        width: MediaQuery.of(context).size.width * .3,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .3,
                        ), //Media
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Resistance: TODO Resistance'),
                        ))),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        //TODO Replace with Small Stat Widget Maybe?
                        width: MediaQuery.of(context).size.width * .3,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .3,
                        ), //Media
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('HP: TODO HP'),
                        ))),
                    Container(
                        //TODO Replace with Small Stat Widget Maybe?
                        width: MediaQuery.of(context).size.width * .3,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .3,
                        ), //Media
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Tough: TODO Tough'),
                        ))),
                    Container(
                        //TODO Replace with Small Stat Widget Maybe?
                        width: MediaQuery.of(context).size.width * .3,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .3,
                        ), //Media
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Quick: TODO Quick'),
                        ))),
                    Container(
                        //TODO Replace with Small Stat Widget Maybe?
                        width: MediaQuery.of(context).size.width * .3,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .3,
                        ), //Media
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Mind: TODO Mind'),
                        ))),
                  ],
                ),
              ],
            ),
            Container(
                height: 200,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .9),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text('Replace with Race Widget'),
                        )))),
            Container(
                height: 200,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .9),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text('Replace with Class Widget'),
                        )))),
            Container(
                height: 200,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .9),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text('Replace with Class Widget'),
                        )))),
            Container(
                height: 200,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .9),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text('Replace with Dingus Widget'),
                        )))),
          ],
        ),
      ),
    );
  }
}
