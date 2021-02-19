import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';
import '../models/class.dart';

class EditClassScreen extends StatefulWidget {
  static const routeName = '/edit-class-screen';
  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

final List<int> temp = [
  1,
  2,
  3,
  4,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  50,
  3,
  2,
];
final _form = GlobalKey<FormState>();
var _isLoading = false;
var _editedClassData = [
  '', // 0 ClassId
  true, //1 IsPrimary
  '', // 2 Title
  '', // 3 Description
  <Skill>[], // 4 Granted Skills
  <Skill>[], // 5 Class Skills
  <int>[0], // 6 Skill Tier Gain at level
  <int>[0], // 7 Health
  <int>[0], // 8 Ep
  <int>[0], // 9 Attack
  <int>[0], //10 Defense
  <int>[0], //11 Accuracy
  <int>[0], //12 Resistance
  <int>[0], //13 Tough Save
  <int>[0], //14 Quick Save
  <int>[0], //15 Mind Save
];

Class _editedClass;
Class _sourceClass;
List<Skill> _grantedSkillSearchResults = [];
List<Skill> _grantedSkillList = [];
var _grantedSkillTextController = TextEditingController();
List<Skill> _classSkillSearchResults = [];
List<Skill> _classSkillList = [];
var _classSkillTextController = TextEditingController();

void _fetchDataFromServer(BuildContext context) {
  Provider.of<Skills>(context, listen: false).fetchAndSetSkills();
}

class _EditClassScreenState extends State<EditClassScreen> {
  @override
  void didChangeDependencies() {
    _fetchDataFromServer(context);
    _grantedSkillSearchResults = [];
    _grantedSkillList = [];
    _grantedSkillTextController.text = '';
    _classSkillSearchResults = [];
    _classSkillList = [];
    _classSkillTextController.text = '';
    final _classId = ModalRoute.of(context).settings.arguments as String;
    if (_classId != null) {
      _sourceClass =
          Provider.of<Classes>(context, listen: false).findById(_classId);
      _grantedSkillList =
          _sourceClass.grantedSkills == null ? [] : _sourceClass.grantedSkills;
      print(_sourceClass.classSkills == null);
      _classSkillList =
          _sourceClass.classSkills == null ? [] : _sourceClass.classSkills;
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

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();
    _editedClass = Class(
      classId: _sourceClass.classId,
      isPrimary: _editedClassData[1],
      title: _editedClassData[2],
      description: _editedClassData[3],
      grantedSkills: _grantedSkillList,
      classSkills: _classSkillList,
      skillLevelGainAtLevel: _editedClassData[6],
      health: _editedClassData[7],
      ep: _editedClassData[8],
      attack: _editedClassData[9],
      accuracy: _editedClassData[10],
      defense: _editedClassData[11],
      resistance: _editedClassData[12],
      toughSave: _editedClassData[13],
      quickSave: _editedClassData[14],
      mindSave: _editedClassData[15],
    );

    try {
      if (_editedClass.classId == 'New Class') {
        await Provider.of<Classes>(context, listen: false)
            .addClass(_editedClass);
      } else {
        await Provider.of<Classes>(context, listen: false)
            .updateClass(_editedClass);
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occured!'),
          content: Text(error.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  //Navigator.of(ctx).pop();
                },
                child: Text('Okay'))
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Classes on Database'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ClassID: ${_sourceClass.classId}',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Container(
                        width: 230,
                        height: 40,
                        child: SwitchListTile(
                          dense: true,
                          value: _editedClassData[1],
                          title: Text(_editedClassData[1]
                              ? 'Is a Primary Class'
                              : 'Is a Secondary Class'),
                          onChanged: (bool value) {
                            setState(() {
                              _editedClassData[1] = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    // Title, Status Testing
                    decoration: InputDecoration(
                      labelText: 'Class Title',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                    initialValue: _sourceClass.title,
                    onSaved: (newValue) {
                      _editedClassData[2] = newValue;
                    },
                  ),
                  TextFormField(
                    // Title, Status Testing
                    initialValue: _sourceClass.description,
                    decoration: InputDecoration(
                      labelText: 'Class Description',
                    ),
                    minLines: 1,
                    maxLines: 9,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedClassData[3] = newValue;
                    },
                  ),
                  //Granted Skills
                  Column(
                    children: [
                      TextFormField(
                        controller: _grantedSkillTextController,
                        decoration: InputDecoration(
                          labelText: 'Granted Skill Search',
                          //border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.none,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Theme.of(context).brightness,
                        onChanged: (value) {
                          final _skillProvider =
                              Provider.of<Skills>(context, listen: false);
                          _grantedSkillSearchResults =
                              _skillProvider.skillsWithTitle(value);

                          setState(() {});
                        },
                      ),
                      !(_grantedSkillSearchResults.length > 0)
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              height: 50 *
                                  _grantedSkillSearchResults.length.toDouble(),
                              color: Theme.of(context).backgroundColor,
                              child: ListView.builder(
                                  itemCount: _grantedSkillSearchResults.length,
                                  itemBuilder: (ctx, i) => ListTile(
                                      title: Text((_grantedSkillSearchResults[i]
                                                      .skillGroupName ==
                                                  null ||
                                              _grantedSkillSearchResults[i]
                                                      .skillGroupName ==
                                                  '')
                                          ? '${_grantedSkillSearchResults[i].title}'
                                          : '${_grantedSkillSearchResults[i].skillGroupName} --> ${_grantedSkillSearchResults[i].title}'),
                                      onTap: () {
                                        _grantedSkillList
                                            .add(_grantedSkillSearchResults[i]);
                                        _grantedSkillTextController.text = '';
                                        _grantedSkillSearchResults = [];
                                        setState(() {});
                                      }))),
                      //VIEWING OF Granted Skills List
                      _grantedSkillList.length == 0
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              height: _grantedSkillList.length > 0 ? 60 : 0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  //itemExtent: 100,
                                  itemCount: _grantedSkillList.length,
                                  itemBuilder: (ctx, i) => Card(
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 5),
                                                Text(
                                                    _grantedSkillList[i].title),
                                                IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      _grantedSkillList.remove(
                                                          _grantedSkillList[i]);
                                                      setState(() {});
                                                    })
                                              ]))))),
                    ],
                  ),
                  //Class Skills
                  Column(
                    children: [
                      TextFormField(
                        controller: _classSkillTextController,
                        decoration: InputDecoration(
                          labelText: 'Class Skills Search',
                          //border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.none,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Theme.of(context).brightness,
                        onChanged: (value) {
                          final _skillProvider =
                              Provider.of<Skills>(context, listen: false);
                          _classSkillSearchResults =
                              _skillProvider.skillsWithTitle(value);

                          setState(() {});
                        },
                      ),
                      !(_classSkillSearchResults.length > 0)
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              height: 50 *
                                  _classSkillSearchResults.length.toDouble(),
                              color: Theme.of(context).backgroundColor,
                              child: ListView.builder(
                                  itemCount: _classSkillSearchResults.length,
                                  itemBuilder: (ctx, i) => ListTile(
                                      title: Text((_classSkillSearchResults[i]
                                                      .skillGroupName ==
                                                  null ||
                                              _classSkillSearchResults[i]
                                                      .skillGroupName ==
                                                  '')
                                          ? '${_classSkillSearchResults[i].title}'
                                          : '${_classSkillSearchResults[i].skillGroupName} --> ${_classSkillSearchResults[i].title}'),
                                      onTap: () {
                                        _classSkillList
                                            .add(_classSkillSearchResults[i]);
                                        _classSkillTextController.text = '';
                                        _classSkillSearchResults = [];
                                        setState(() {});
                                      }))),
                      //VIEWING OF Class Skills List
                      _classSkillList.length == 0
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              height: _classSkillList.length > 0 ? 60 : 0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  //itemExtent: 100,
                                  itemCount: _classSkillList.length,
                                  itemBuilder: (ctx, i) => Card(
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 5),
                                                Text(_classSkillList[i].title),
                                                IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      _classSkillList.remove(
                                                          _classSkillList[i]);
                                                      setState(() {});
                                                    })
                                              ]))))),
                      //Next Thing
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          height: 650,
                          width: 1132,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(width: 112),
                                  SimpleLevelText(text: ' 1'),
                                  SimpleLevelText(text: ' 2'),
                                  SimpleLevelText(text: ' 3'),
                                  SimpleLevelText(text: ' 4'),
                                  SimpleLevelText(text: ' 5'),
                                  SimpleLevelText(text: ' 6'),
                                  SimpleLevelText(text: ' 7'),
                                  SimpleLevelText(text: ' 8'),
                                  SimpleLevelText(text: ' 9'),
                                  SimpleLevelText(text: '10'),
                                  SimpleLevelText(text: '11'),
                                  SimpleLevelText(text: '12'),
                                  SimpleLevelText(text: '13'),
                                  SimpleLevelText(text: '14'),
                                  SimpleLevelText(text: '15'),
                                  SimpleLevelText(text: '16'),
                                  SimpleLevelText(text: '17'),
                                  SimpleLevelText(text: '18'),
                                  SimpleLevelText(text: '19'),
                                  SimpleLevelText(text: '20'),
                                ],
                              ),
                              RowForm(
                                title: 'Skill Tier Gained',
                                inA: _sourceClass.skillLevelGainAtLevel,
                                outA: _editedClassData[6],
                              ),
                              RowForm(
                                title: 'Health',
                                inA: _sourceClass.health,
                                outA: _editedClassData[7],
                              ),
                              RowForm(
                                title: 'Ep',
                                inA: _sourceClass.ep,
                                outA: _editedClassData[8],
                              ),
                              RowForm(
                                title: 'Attack',
                                inA: _sourceClass.attack,
                                outA: _editedClassData[9],
                              ),
                              RowForm(
                                title: 'Defence',
                                inA: _sourceClass.defense,
                                outA: _editedClassData[10],
                              ),
                              RowForm(
                                title: 'Accuracy',
                                inA: _sourceClass.accuracy,
                                outA: _editedClassData[11],
                              ),
                              RowForm(
                                title: 'Resistance',
                                inA: _sourceClass.resistance,
                                outA: _editedClassData[12],
                              ),
                              RowForm(
                                title: 'Tough Save',
                                inA: _sourceClass.toughSave,
                                outA: _editedClassData[13],
                              ),
                              RowForm(
                                title: 'Quick Save',
                                inA: _sourceClass.quickSave,
                                outA: _editedClassData[14],
                              ),
                              RowForm(
                                title: 'Mind Save',
                                inA: _sourceClass.mindSave,
                                outA: _editedClassData[15],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class RowForm extends StatelessWidget {
  const RowForm({
    Key key,
    @required this.title,
    @required this.inA,
    @required this.outA,
  }) : super(key: key);

  final List<int> inA;
  final List<int> outA;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            width: 110,
            child: Text(
              title,
              textAlign: TextAlign.end,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 1,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 2,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 3,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 4,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 5,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 6,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 7,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 8,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 9,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 10,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 11,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 12,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 13,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 14,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 15,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 16,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 17,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 18,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 19,
              ),
              SingleIntForm(
                inA: inA,
                outA: outA,
                lvl: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SingleIntForm extends StatelessWidget {
  const SingleIntForm({
    Key key,
    @required this.inA,
    @required this.lvl,
    @required this.outA,
  }) : super(key: key);

  final List<int> inA;
  final int lvl;
  final List<int> outA;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      alignment: AlignmentDirectional.bottomCenter,
      width: 50,
      child: TextFormField(
        expands: false,
        initialValue: inA.length < 20
            ? temp[lvl].toString()
            : inA[lvl].toString(), // ? should be ''
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(6),
          isDense: true,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return '';
          }
          if (int.tryParse(value) == null) {
            return 'Type Incorrect';
          }
          return null;
        },
        onSaved: (newValue) {
          outA.add(int.tryParse(newValue));
        },
      ),
    );
  }
}

class SimpleLevelText extends StatelessWidget {
  const SimpleLevelText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      child: Container(
        width: 20,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
