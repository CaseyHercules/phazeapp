import 'package:flutter/material.dart';
import 'package:phazeapp/models/passport.dart';

class ViewPassport extends StatelessWidget {
  final Passport? passport;
  const ViewPassport({Key? key, @required this.passport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15),
      children: [
        SizedBox(
          height: 34,
          width: 34,
          child: const DecoratedBox(
            decoration: const BoxDecoration(color: Colors.red),
          ),
        ),
        SizedBox(
          height: 34,
          width: 34,
          child: const DecoratedBox(
            decoration: const BoxDecoration(color: Colors.blue),
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text('Hello ${passport?.name} Test'),
          ),
        )
      ],
    );
  }
}
