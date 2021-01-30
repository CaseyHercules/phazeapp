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
Skill _parentSkill;
var _parentSkillTextController = TextEditingController();
List<Skill> _prerequisiteSearchResults = [];
List<Skill> _prerequisiteSkillList = [];
var _prerequisiteSkillTextController = TextEditingController();

final _form = GlobalKey<FormState>();

bool _canBeTakenMultiple = false;
bool _playerVisable = false;

var _editedSkill = Skill(
  id: null,
  title: '',
  description: '',
  descriptionShort: '',
  tier: null,
  parentSkill: null,
  skillGroupName: '',
  prerequisiteSkills: null,
  permenentEpReduction: null,
  epCost: '',
  activation: '',
  duration: '',
  abilityCheck: '',
  canBeTakenMultiple: null,
  playerVisable: null,
);

class _EditSkillScreenState extends State<EditSkillScreen> {
  @override
  void didChangeDependencies() {
    //final _skillList = Provider.of<Skills>(context);
    _isLoading = false;
    _parentSearchResults = [];
    _parentSkill = null;
    _parentSkillTextController.text = '';
    _prerequisiteSearchResults = [];
    _prerequisiteSkillList = [];
    _prerequisiteSkillTextController.text = '';

    final _skillId = ModalRoute.of(context).settings.arguments as String;
    if (_skillId != null) {
      _editedSkill =
          Provider.of<Skills>(context, listen: false).findById(_skillId);
      _canBeTakenMultiple = _editedSkill.canBeTakenMultiple == null
          ? false
          : _editedSkill.canBeTakenMultiple;
      _playerVisable = _editedSkill.playerVisable == null
          ? true
          : _editedSkill.canBeTakenMultiple;
    } else {
      _editedSkill = Skill(
        id: null,
        title: '',
        description: '',
        descriptionShort: '',
        tier: null,
        parentSkill: null,
        skillGroupName: '',
        prerequisiteSkills: null,
        permenentEpReduction: null,
        epCost: '',
        activation: '',
        duration: '',
        abilityCheck: '',
        canBeTakenMultiple: false,
        playerVisable: false,
      );
    }
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
//TODO Finish Save Logic
    if (_editedSkill.id != null) {
      await Provider.of<Skills>(context, listen: false).addSkill(_editedSkill);
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
      body: Form(
          key: _form,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'Skill Id: ${_editedSkill.id == null ? 'New Skill' : _editedSkill.id}',
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
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                initialValue: _editedSkill.title,
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: newValue,
                    description: _editedSkill.description,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: _editedSkill.tier,
                    parentSkill: _parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: _editedSkill.epCost,
                    activation: _editedSkill.activation,
                    duration: _editedSkill.duration,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                initialValue: _editedSkill.description,
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: newValue,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: _editedSkill.tier,
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: _editedSkill.epCost,
                    activation: _editedSkill.activation,
                    duration: _editedSkill.duration,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                  _form.currentState.validate();
                },
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Please provide a value';
                //   }
                //   return null;
                // },
                initialValue: _editedSkill.descriptionShort,
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: _editedSkill.description,
                    descriptionShort: newValue,
                    tier: _editedSkill.tier,
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: _editedSkill.epCost,
                    activation: _editedSkill.activation,
                    duration: _editedSkill.duration,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                  _form.currentState.validate();
                },
                validator: (value) {
                  if (value.isEmpty) {
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
                initialValue: _editedSkill.tier == null
                    ? ''
                    : _editedSkill.tier.toString(),
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: _editedSkill.description,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: int.parse(newValue),
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: _editedSkill.epCost,
                    activation: _editedSkill.activation,
                    duration: _editedSkill.duration,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                          height: 50 * _parentSearchResults.length.toDouble(),
                          color: Theme.of(context).backgroundColor,
                          child: ListView.builder(
                            itemCount: _parentSearchResults.length,
                            itemBuilder: (ctx, i) => ListTile(
                                title: Text(_parentSearchResults[i]
                                            .skillGroupName ==
                                        null
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
                  _form.currentState.validate();
                },
                validator: (value) {
                  // if (value.isEmpty) {
                  //   return 'Please provide a value';
                  // }
                  return null;
                },
                initialValue: _editedSkill.skillGroupName,
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: _editedSkill.description,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: _editedSkill.tier,
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: newValue,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: _editedSkill.epCost,
                    activation: _editedSkill.activation,
                    duration: _editedSkill.duration,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                          height:
                              50 * _prerequisiteSearchResults.length.toDouble(),
                          color: Theme.of(context).backgroundColor,
                          child: ListView.builder(
                            itemCount: _prerequisiteSearchResults.length,
                            itemBuilder: (ctx, i) => ListTile(
                                title: Text(_prerequisiteSearchResults[i]
                                            .skillGroupName ==
                                        null
                                    ? '${_prerequisiteSearchResults[i].title}'
                                    : '${_prerequisiteSearchResults[i].skillGroupName} --> ${_prerequisiteSearchResults[i].title}'),
                                onTap: () {
                                  _prerequisiteSkillList
                                      .add(_prerequisiteSearchResults[i]);
                                  _prerequisiteSkillTextController.text = '';
                                  _prerequisiteSearchResults = [];
                                  setState(() {});
                                }),
                          ),
                        ),
                  //VIEWING OF PreRequisite Skills List
                  _prerequisiteSkillList.length == 0
                      ? SizedBox(
                          height: 0,
                        )
                      : Container(
                          height: _prerequisiteSkillList.length > 0 ? 60 : 0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            //itemExtent: 100,
                            itemCount: _prerequisiteSkillList.length,
                            itemBuilder: (ctx, i) => Card(
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 5),
                                    Text(_prerequisiteSkillList[i].title),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _prerequisiteSkillList.remove(
                                              _prerequisiteSkillList[i]);
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
              TextFormField(
                // permenentEpReduction, Works
                decoration: InputDecoration(
                  labelText: 'Permenent EP Reduction',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
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
                initialValue: _editedSkill.permenentEpReduction == null
                    ? ''
                    : _editedSkill.permenentEpReduction.toString(),
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: _editedSkill.description,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: _editedSkill.tier,
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: int.parse(newValue),
                    epCost: _editedSkill.epCost,
                    activation: _editedSkill.activation,
                    duration: _editedSkill.duration,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                  _form.currentState.validate();
                },
                validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please provide a value';
                  //   }
                  return null;
                },
                initialValue: _editedSkill.epCost,
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: _editedSkill.description,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: _editedSkill.tier,
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: newValue,
                    activation: _editedSkill.activation,
                    duration: _editedSkill.duration,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                  _form.currentState.validate();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                initialValue: _editedSkill.activation,
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: _editedSkill.description,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: _editedSkill.tier,
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: _editedSkill.epCost,
                    activation: newValue,
                    duration: _editedSkill.duration,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                  _form.currentState.validate();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                initialValue: _editedSkill.duration,
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: _editedSkill.description,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: _editedSkill.tier,
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: _editedSkill.epCost,
                    activation: _editedSkill.activation,
                    duration: newValue,
                    abilityCheck: _editedSkill.abilityCheck,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
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
                  _form.currentState.validate();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                initialValue: _editedSkill.abilityCheck,
                onSaved: (newValue) {
                  Skill(
                    id: _editedSkill.id,
                    title: _editedSkill.title,
                    description: _editedSkill.description,
                    descriptionShort: _editedSkill.descriptionShort,
                    tier: _editedSkill.tier,
                    parentSkill: _editedSkill.parentSkill,
                    skillGroupName: _editedSkill.skillGroupName,
                    prerequisiteSkills: _editedSkill.prerequisiteSkills,
                    permenentEpReduction: _editedSkill.permenentEpReduction,
                    epCost: _editedSkill.epCost,
                    activation: _editedSkill.activation,
                    duration: _editedSkill.duration,
                    abilityCheck: newValue,
                    canBeTakenMultiple: _canBeTakenMultiple,
                    playerVisable: _playerVisable,
                  );
                },
              ),
              SwitchListTile(
                // canBeTakenMultiple, Testing
                value: _canBeTakenMultiple,
                onChanged: (bool value) {
                  setState(() => _canBeTakenMultiple = value);
                },
                secondary:
                    Icon(_canBeTakenMultiple ? Icons.reorder : Icons.maximize),
                title: Text(
                    '${_canBeTakenMultiple ? 'Skill Can be Taken Mutiple Times' : 'Skill Can\'t be Taken Mutiple Times'}'),
              ),
              SwitchListTile(
                // playerVisable, Testing
                value: _playerVisable,
                onChanged: (bool value) {
                  setState(() => _playerVisable = value);
                },
                secondary: Icon(
                    _playerVisable ? Icons.visibility : Icons.visibility_off),
                title: Text(
                    '${_playerVisable ? 'Visable to Players' : 'Not Visable to Players'}'),
              )
            ],
          )),
    );
  }
}
