import 'dart:js';

import 'package:flutter/material.dart';
import 'package:phazeapp/models/passport.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/class.dart';
import '../models/passport.dart';
import '../widgets/view_passport.dart';

class PassportScreen extends StatefulWidget {
  static const routeName = '/passport';
  const PassportScreen({Key? key}) : super(key: key);

  @override
  State<PassportScreen> createState() => _PassportScreenState();
}

var _isLoading = false;
var _isEditing = false;
var _passportId = 0;
//Passport _passport = await fetchPassport(passportId);
Passport p = new Passport();

Future<void> _savePassport() async {}

class _PassportScreenState extends State<PassportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Passport'),
          actions: [
            IconButton(
                icon: Icon(Icons.save), onPressed: () => createPassport(p))
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _isEditing
                ? Center(child: CircularProgressIndicator())
                : ViewPassport(
                    passport: p,
                  ));
  }
}
