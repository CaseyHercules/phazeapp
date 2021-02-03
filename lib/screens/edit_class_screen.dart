import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/class.dart';

class EditClassScreen extends StatefulWidget {
  static const routeName = '/edit-class-screen';
  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

final _form = GlobalKey<FormState>();
var _isLoading = false;
var _editedClassData = [];

Class _editedClass;
Class _sourceClass;

class _EditClassScreenState extends State<EditClassScreen> {
  @override
  void didChangeDependencies() {
    final _classId = ModalRoute.of(context).settings.arguments as String;
    if (_classId != null) {
      _sourceClass =
          Provider.of<Classes>(context, listen: false).findById(_classId);
    } else {
      _sourceClass = Class(
        classId: 'New Class',
        isPrimary: true,
        title: '',
        description: '',
        grantedSkills: [],
        classSkills: [],
        skillLevelGainAtLevel: [],
        health: [],
        ep: [],
        attack: [],
        accuracy: [],
        defense: [],
        resistance: [],
        toughSave: [],
        quickSave: [],
        mindSave: [],
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
