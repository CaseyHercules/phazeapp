import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill.dart';

class EditSkillScreen extends StatefulWidget {
  static const routeName = '/edit-skill-screen';
  @override
  _EditSkillScreenState createState() => _EditSkillScreenState();
}

var _isLoading = false;
List<Skill> _parentSearchResults = [];
Skill? _parentSkill;
var _parentSkillTextController = TextEditingController();
List<Skill> _prerequisiteSearchResults = [];
List<Skill?>? _prerequisiteSkillList = [];
var _prerequisiteSkillTextController = TextEditingController();
List<String> _additionalDataList = [];
var _additionalDataController = TextEditingController();

final _form = GlobalKey<FormState>();

var _editedSkillData = [
  '', // [0] ID is not set from within form
  '', // [1] Title
  '', // [2] Description
  '', // [3] Short Description
  int, // [4] Tier
  Skill, // [5] Not Used
  '', // [6] Skill Group
  List, // [7] Not used
  int, // [8] Permenent EP Reduction
  '', // [9] Active EP cost
  '', // [10] Activation
  '', // [11] Duration
  '', // [12] Ability Check
  false, // [13] Default Value for CanBeTakenMutiple in Form
  true, // [14] Default Value for CanBeTakenMutiple in Form
  '', // [15] Skill Group Description
  <String>[], // [16] Additional Data
];

late Skill _editedSkill;
Skill? _sourceSkill;

class _EditSkillScreenState extends State<EditSkillScreen> {
  @override
  void didChangeDependencies() {
    _isLoading = false;
    _parentSearchResults = [];
    _parentSkill = null;
    _parentSkillTextController.text = '';
    _prerequisiteSearchResults = [];
    _prerequisiteSkillList = [];
    _prerequisiteSkillTextController.text = '';
    _additionalDataList = [];

    final _skillId = ModalRoute.of(context)!.settings.arguments as String?;
    if (_skillId != null) {
      _sourceSkill =
          Provider.of<Skills>(context, listen: false).findById(_skillId);
      _parentSkill =
          _sourceSkill!.parentSkill == null ? null : _sourceSkill!.parentSkill;
      _prerequisiteSkillList = _sourceSkill!.prerequisiteSkills == null
          ? []
          : _sourceSkill!.prerequisiteSkills;
      _editedSkillData[13] = _sourceSkill!.canBeTakenMultiple;
      _editedSkillData[14] = _sourceSkill!.playerVisable;
      _editedSkillData[16] = (_sourceSkill!.additionalData == null
          ? []
          : _sourceSkill!.additionalData)!;
    } else {
      _sourceSkill = Skill(
        id: 'New Skill',
        title: '',
        description: '',
        descriptionShort: '',
        tier: 0,
        parentSkill: null,
        skillGroupName: '',
        skillGroupDescription: '',
        prerequisiteSkills: null,
        permenentEpReduction: 0,
        epCost: '',
        activation: '',
        duration: '',
        abilityCheck: '',
        canBeTakenMultiple: _editedSkillData[13] as bool,
        playerVisable: _editedSkillData[14] as bool,
        additionalData: [],
      );
    }
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    _editedSkill = Skill(
      id: _sourceSkill!.id,
      title: _editedSkillData[1] as String,
      description: _editedSkillData[2] as String,
      descriptionShort: _editedSkillData[3] as String?,
      tier: _editedSkillData[4] as int,
      parentSkill: _parentSkill,
      skillGroupName: _editedSkillData[6] as String?,
      skillGroupDescription: _editedSkillData[15] as String?,
      prerequisiteSkills: _prerequisiteSkillList,
      permenentEpReduction: _editedSkillData[8] as int,
      epCost: _editedSkillData[9] as String,
      activation: _editedSkillData[10] as String,
      duration: _editedSkillData[11] as String,
      abilityCheck: _editedSkillData[12] as String,
      canBeTakenMultiple: _editedSkillData[13] as bool,
      playerVisable: _editedSkillData[14] as bool,
      additionalData: _additionalDataList,
    );

    setState(() {
      _isLoading = true;
    });
    _editedSkill.printSkill();

    try {
      if (_editedSkill.id == 'New Skill') {
        await Provider.of<Skills>(context, listen: false)
            .addSkill(_editedSkill);
      } else {
        await Provider.of<Skills>(context, listen: false)
            .updateSkill(_editedSkill);
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
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'))
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Skills on Database'),
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
                  Text(
                    'Skill Id: ${_sourceSkill!.id}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  TextFormField(
                    // Title, Status Testing
                    decoration: InputDecoration(
                      labelText: 'Skill Title',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                    initialValue: _sourceSkill!.title,
                    onSaved: (newValue) {
                      _editedSkillData[1] = newValue!;
                    },
                  ),
                  TextFormField(
                    // Description, Status Testing
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    minLines: 1,
                    maxLines: 9,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                    initialValue: _sourceSkill!.description,
                    onSaved: (newValue) {
                      _editedSkillData[2] = newValue!;
                    },
                  ),
                  TextFormField(
                    // descriptionShort
                    decoration: InputDecoration(
                      labelText: 'Passport description',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      _form.currentState!.validate();
                    },
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please provide a value';
                    //   }
                    //   return null;
                    // },
                    initialValue: _sourceSkill!.descriptionShort,
                    onSaved: (newValue) {
                      _editedSkillData[3] = newValue!;
                    },
                  ),
                  TextFormField(
                    // tier, Works
                    decoration: InputDecoration(
                      labelText: 'Level Tier',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) {
                      _form.currentState!.validate();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value from 1-4';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please provide a value from 1-4';
                      }
                      if (0 > int.parse(value) || int.parse(value) > 4) {
                        return 'Please provide a value from 1-4';
                      }
                      return null;
                    },
                    initialValue: _sourceSkill!.tier.toString(),
                    onSaved: (newValue) {
                      _editedSkillData[4] = int.parse(newValue!);
                    },
                  ),
                  //Parent Skill
                  Column(
                    children: [
                      TextFormField(
                        controller: _parentSkillTextController,
                        decoration: InputDecoration(
                          labelText: 'Parent Skill Search',
                        ),
                        textInputAction: TextInputAction.none,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Theme.of(context).brightness,
                        onChanged: (value) {
                          final _skillProvider =
                              Provider.of<Skills>(context, listen: false);
                          _parentSearchResults =
                              _skillProvider.skillsWithTitle(value);
                          _parentSkill = null;

                          setState(() {});
                        },
                      ),
                      !(_parentSearchResults.length > 0)
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              height:
                                  50 * _parentSearchResults.length.toDouble(),
                              color: Theme.of(context).backgroundColor,
                              child: ListView.builder(
                                itemCount: _parentSearchResults.length,
                                itemBuilder: (ctx, i) => ListTile(
                                    title: Text((_parentSearchResults[i]
                                                    .skillGroupName ==
                                                null ||
                                            _parentSearchResults[i]
                                                    .skillGroupName ==
                                                '')
                                        ? '${_parentSearchResults[i].title}'
                                        : '${_parentSearchResults[i].skillGroupName} --> ${_parentSearchResults[i].title}'),
                                    onTap: () {
                                      _parentSkill = _parentSearchResults[i];
                                      _parentSkillTextController.text =
                                          _parentSearchResults[i].title;
                                      _parentSearchResults = [];
                                      setState(() {});
                                    }),
                              ),
                            ),
                    ],
                  ),
                  TextFormField(
                    // skillGroupName, Works
                    decoration: InputDecoration(
                      labelText: 'Skill Group',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      _form.currentState!.validate();
                    },
                    validator: (value) {
                      // if (value.isEmpty) {
                      //   return 'Please provide a value';
                      // }
                      return null;
                    },
                    initialValue: _sourceSkill!.skillGroupName,
                    onSaved: (newValue) {
                      _editedSkillData[6] = newValue!;
                    },
                  ),
                  TextFormField(
                    // skillGroupDescription, Works
                    decoration: InputDecoration(
                      labelText: 'Skill Group Description',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      _form.currentState!.validate();
                    },
                    validator: (value) {
                      // if (value.isEmpty) {
                      //   return 'Please provide a value';
                      // }
                      return null;
                    },
                    initialValue: _sourceSkill!.skillGroupDescription,
                    onSaved: (newValue) {
                      _editedSkillData[15] = newValue!;
                    },
                  ),
                  //Prerequisite Skills
                  Column(
                    children: [
                      TextFormField(
                        controller: _prerequisiteSkillTextController,
                        decoration: InputDecoration(
                          labelText: 'Prerequisite Skills Search',
                          //border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.none,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Theme.of(context).brightness,
                        onChanged: (value) {
                          final _skillProvider =
                              Provider.of<Skills>(context, listen: false);
                          _prerequisiteSearchResults =
                              _skillProvider.skillsWithTitle(value);

                          setState(() {});
                        },
                      ),
                      !(_prerequisiteSearchResults.length > 0)
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              height: 50 *
                                  _prerequisiteSearchResults.length.toDouble(),
                              color: Theme.of(context).backgroundColor,
                              child: ListView.builder(
                                itemCount: _prerequisiteSearchResults.length,
                                itemBuilder: (ctx, i) => ListTile(
                                    title: Text((_prerequisiteSearchResults[i]
                                                    .skillGroupName ==
                                                null ||
                                            _prerequisiteSearchResults[i]
                                                    .skillGroupName ==
                                                '')
                                        ? '${_prerequisiteSearchResults[i].title}'
                                        : '${_prerequisiteSearchResults[i].skillGroupName} --> ${_prerequisiteSearchResults[i].title}'),
                                    onTap: () {
                                      _prerequisiteSkillList!
                                          .add(_prerequisiteSearchResults[i]);
                                      _prerequisiteSkillTextController.text =
                                          '';
                                      _prerequisiteSearchResults = [];
                                      setState(() {});
                                    }),
                              ),
                            ),
                      //VIEWING OF PreRequisite Skills List
                      _prerequisiteSkillList!.length == 0
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              height:
                                  _prerequisiteSkillList!.length > 0 ? 60 : 0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                //itemExtent: 100,
                                itemCount: _prerequisiteSkillList!.length,
                                itemBuilder: (ctx, i) => Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 5),
                                        Text(_prerequisiteSkillList![i]!.title),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _prerequisiteSkillList!.remove(
                                                  _prerequisiteSkillList![i]);
                                              setState(() {});
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  //Additional Data
                  Column(
                    children: [
                      Row(children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: TextFormField(
                            controller: _additionalDataController,
                            decoration: InputDecoration(
                              labelText: 'Additional Data Input',
                            ),
                            textInputAction: TextInputAction.none,
                            keyboardType: TextInputType.text,
                            keyboardAppearance: Theme.of(context).brightness,
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (_additionalDataController.text != null)
                                _additionalDataList
                                    .add(_additionalDataController.text);
                              _additionalDataController.text = '';
                              setState(() {});
                            })
                      ]),
                      //VIEWING OF Additional Data List
                      _additionalDataList.length == 0
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              height: _additionalDataList.length > 0 ? 60 : 0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _additionalDataList.length,
                                  itemBuilder: (ctx, i) => Card(
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 5),
                                                Text(_additionalDataList[i]),
                                                IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      _additionalDataList.remove(
                                                          _additionalDataList[
                                                              i]);
                                                      setState(() {});
                                                    })
                                              ])))))
                    ],
                  ),

                  TextFormField(
                    // permenentEpReduction, Works
                    decoration: InputDecoration(
                      labelText: 'Permenent EP Reduction',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value, if None, then put 0';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please provide a interger';
                      }
                      if (!int.parse(value).isFinite) {
                        return 'Please provide a interger';
                      }
                      return null;
                    },
                    initialValue: _sourceSkill!.permenentEpReduction == null
                        ? ''
                        : _sourceSkill!.permenentEpReduction.toString(),
                    onSaved: (newValue) {
                      _editedSkillData[8] = int.parse(newValue!);
                    },
                  ),
                  TextFormField(
                    // epCost, Works
                    decoration: InputDecoration(
                      labelText: 'Active Ep Cost',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      _form.currentState!.validate();
                    },
                    validator: (value) {
                      //   if (value.isEmpty) {
                      //     return 'Please provide a value';
                      //   }
                      return null;
                    },
                    initialValue: _sourceSkill!.epCost,
                    onSaved: (newValue) {
                      _editedSkillData[9] = newValue!;
                    },
                  ),
                  TextFormField(
                    // activation, Works
                    decoration: InputDecoration(
                      labelText: 'Activation',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      _form.currentState!.validate();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                    initialValue: _sourceSkill!.activation,
                    onSaved: (newValue) {
                      _editedSkillData[10] = newValue!;
                    },
                  ),
                  TextFormField(
                    // duration, Works
                    decoration: InputDecoration(
                      labelText: 'Duration',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      _form.currentState!.validate();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                    initialValue: _sourceSkill!.duration,
                    onSaved: (newValue) {
                      _editedSkillData[11] = newValue!;
                    },
                  ),
                  TextFormField(
                    // abilityCheck
                    decoration: InputDecoration(
                      labelText: 'Ability Check',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      _form.currentState!.validate();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                    initialValue: _sourceSkill!.abilityCheck,
                    onSaved: (newValue) {
                      _editedSkillData[12] = newValue!;
                    },
                  ),
                  SwitchListTile(
                    // canBeTakenMultiple, Testing
                    value: _editedSkillData[13] as bool,
                    onChanged: (bool value) {
                      setState(() => _editedSkillData[13] = value);

                      print([..._prerequisiteSkillList!.map((s) => s!.id)]
                          .join(",")
                          .toString());
                    },
                    secondary: Icon(_editedSkillData[13] != null
                        ? Icons.reorder
                        : Icons.maximize),
                    title: Text(
                        '${_editedSkillData[13] != null ? 'Skill Can be Taken Mutiple Times' : 'Skill Can\'t be Taken Mutiple Times'}'),
                  ),
                  SwitchListTile(
                    // playerVisable, Testing

                    value: _editedSkillData[14] as bool,
                    onChanged: (bool value) {
                      setState(() => _editedSkillData[14] = value);
                    },
                    secondary: Icon(_editedSkillData[14] != null
                        ? Icons.visibility
                        : Icons.visibility_off),
                    title: Text(
                        '${_editedSkillData[14] != null ? 'Visable to Players' : 'Not Visable to Players'}'),
                  )
                ],
              )),
    );
  }
}
