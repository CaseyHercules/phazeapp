import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class Skill {
  @required
  final String id; //Use Id of _all if viewable by all classes
  @required
  final String title;
  @required
  final String description;
  final String descriptionShort;
  @required
  final int tier;
  final Skill parentSkill;
  final String skillGroupName;
  final List<Skill> prerequisiteSkills;
  @required
  final int permenentEpReduction;
  @required
  final String epCost;
  @required
  final String activation;
  @required
  final String duration;
  @required
  final String abilityCheck;
  @required
  final bool canBeTakenMultiple;
  @required
  final bool playerVisable;

  Skill(
      {this.id, //Leave blank
      this.title,
      this.description,
      this.descriptionShort,
      this.tier,
      this.parentSkill,
      this.skillGroupName,
      this.prerequisiteSkills,
      this.permenentEpReduction,
      this.epCost,
      this.activation,
      this.duration,
      this.abilityCheck,
      this.canBeTakenMultiple,
      this.playerVisable});
}

class Skills with ChangeNotifier {
  List<Skill> _skills = [
    Skill(
      id: '001',
      title: 'Local Rumors',
      description:
          'Scholar has gathered knowledge of the goings-on and plot points of Phaze. Scholar begins play with one piece of information relevant to the local area and/or storyline of the current Phaze event.',
      tier: 1,
      skillGroupName: 'Rumors',
      permenentEpReduction: 1,
      epCost: null,
      activation: 'None',
      duration: 'Always On',
      abilityCheck: 'None',
      canBeTakenMultiple: false,
      playerVisable: true,
    ),
    Skill(
      id: '002',
      title: 'Learn Ability',
      description:
          'Scholar spends EP to learn an ability from a target’s Passport; adding it to her codex.  Abilities contained in Skill Codices may not be learned with this ability.  If, at any time during the ritual, the target elects to Actively Resist this effect, their Resistance is automatically successful. Scholar maintains a codex which may be used to collect and utilize class abilities. The Scholar must wield the codex during the use of these abilities.  The Codex is a Challenge Level 1 item (meaning it has a 5% save vs. breaking).',
      tier: 1,
      skillGroupName: 'Ability Codex',
      permenentEpReduction: null,
      epCost: '2 EP',
      activation: 'Ritual Action',
      duration: 'Permanent',
      abilityCheck:
          'None; any attempt to resist automatically negates without check',
      canBeTakenMultiple: false,
      playerVisable: true,
    ),
    Skill(
      id: '003',
      title: 'Mind Bonus',
      description: 'Character gains a +5 to Mind save',
      tier: 1,
      skillGroupName: 'Save Bonus',
      permenentEpReduction: 1,
      epCost: null,
      activation: 'None',
      duration: 'Always On',
      abilityCheck: 'None',
      canBeTakenMultiple: false,
      playerVisable: true,
    ),
    Skill(
      id: '004',
      title: 'Extra EPs',
      description: 'Character gains a permanent addition of 2 EPs.',
      tier: 1,
      permenentEpReduction: -2,
      epCost: null,
      activation: 'None',
      duration: 'Always On',
      abilityCheck: 'None',
    )
  ];

  List<Skill> get skills {
    return [..._skills];
  }

  void printSkill(Skill s) {
    print('ID: ${s.id}');
    print('Title: ${s.title}');
    print('Desc: ${s.description}');
    print('DescS: ${s.descriptionShort}');
    print('Tier: ${s.tier}');
    print('Parent: ${s.parentSkill == null ? 'None' : s.parentSkill.title}');
    print('Skill Group: ${s.skillGroupName}');
    s.prerequisiteSkills.length == 0
        ? print('Preq: None')
        : s.prerequisiteSkills
            .forEach((skill) => print('Preq: ${skill.title}'));
    print('pEpRedux: ${s.permenentEpReduction}');
    print('Ep Cost: ${s.epCost}');
    print('Activation: ${s.activation}');
    print('Duration: ${s.duration}');
    print('Ability Check: ${s.abilityCheck}');
    print('Taken Mutiple: ${s.canBeTakenMultiple}');
    print('Visable: ${s.playerVisable}');
  }

  Skill findById(String id) {
    return _skills.firstWhere((skill) => skill.id == id);
  } //Untested

  List<Skill> skillsWithTitle(String title, [int results = 5]) {
    List<Skill> _searchedSkills = [];
    if (title == '' || title == null) {
      return [];
    }
    for (int i = 0; i < _skills.length; i++) {
      if (_skills[i].title.toLowerCase().contains(title.toLowerCase()) ||
          ((_skills[i].skillGroupName == null ||
                  _skills[i].skillGroupName == '')
              ? false
              : _skills[i]
                  .skillGroupName
                  .toLowerCase()
                  .contains(title.toLowerCase()))) {
        _searchedSkills.add(_skills[i]);
        if (_searchedSkills.length >= results) {
          break;
        }
      } else {}
    }
    return _searchedSkills;
  } //Tested, Seems to Work

  Future<void> addSkill(Skill skill, [bool atTop = true]) async {
    const url =
        'https://interphaze-pocket-scholar-default-rtdb.firebaseio.com/skills.json';
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': skill.title,
            'description': skill.description,
            'descriptionShort': skill.descriptionShort,
            'tier': skill.tier,
            'parentSkillId': skill.parentSkill == null
                ? ''
                : skill.parentSkill.id, //Seems to Work
            'skillGroupName': skill.skillGroupName,
            'prerequisiteSkillsIds': skill.prerequisiteSkills == null
                ? ''
                : skill.prerequisiteSkills
                    .map((e) => e.id), //Needs to be TESTED, is List<Skill>
            'permenentEpReduction': skill.permenentEpReduction,
            'epCost': skill.epCost,
            'activation': skill.activation,
            'duration': skill.duration,
            'abilityCheck': skill.abilityCheck,
            'canBeTakenMultiple': skill.canBeTakenMultiple,
            'playerVisable': skill.playerVisable,
          },
        ),
      );
      print('1$response');
      if (response.statusCode >= 400) {
        print('2$response');
        throw HttpException(
            'Couldn\'t reach server. Error:${response.statusCode}');
      } else {
        print('3$response');
        _skills.insert(
          atTop ? 0 : _skills.length,
          Skill(
            id: json.decode(response.body)['name'],
            title: skill.title,
            description: skill.description,
            descriptionShort: skill.descriptionShort,
            tier: skill.tier,
            parentSkill: skill.parentSkill,
            skillGroupName: skill.skillGroupName,
            prerequisiteSkills: skill.prerequisiteSkills,
            permenentEpReduction: skill.permenentEpReduction,
            epCost: skill.epCost,
            activation: skill.activation,
            duration: skill.duration,
            abilityCheck: skill.abilityCheck,
            canBeTakenMultiple: skill.canBeTakenMultiple,
            playerVisable: skill.playerVisable,
          ),
        );
      }
    } catch (error) {
      throw (error);
    }
  } //Untested

  // void moveSkill(String id, int index) {
  //   int i = _skills.indexWhere((skill) => skill.id == id);
  //   var _tempSkill = _skills[i];
  //   _skills.removeAt(i);
  //   _skills.insert(index, _tempSkill);
  //   notifyListeners();
  // } //Untested

  void updateSkill(String skillToUpdateId, Skill newSkill) async {
    int i = _skills.indexWhere((skill) => skill.id == skillToUpdateId);
    _skills[i] = newSkill;
    notifyListeners();
    const url =
        'https://interphaze-pocket-scholar-default-rtdb.firebaseio.com/skills.json';
    try {
      final response = await http.patch(
        url,
        body: jsonEncode(
          {
            'title': newSkill.title,
            'description': newSkill.description,
            'descriptionShort': newSkill.descriptionShort,
            'tier': newSkill.tier,
            'parentSkillId': newSkill.parentSkill.id, //Needs to TEST, is SKILL
            'skillGroupName': newSkill.skillGroupName,
            'prerequisiteSkillsIds': newSkill.prerequisiteSkills
                .map((e) => e.id), //Needs to be TESTED, is List<Skill>
            'permenentEpReduction': newSkill.permenentEpReduction,
            'epCost': newSkill.epCost,
            'activation': newSkill.activation,
            'duration': newSkill.duration,
            'abilityCheck': newSkill.abilityCheck,
            'canBeTakenMultiple': newSkill.canBeTakenMultiple,
            'playerVisable': newSkill.playerVisable,
          },
        ),
      );

      notifyListeners();
      if (response.statusCode >= 400) {
        throw HttpException(
            'Couldn\'t reach server. Error:${response.statusCode} \n Please try again in 1 minute. If problem check that you are connected to the internet, then contact the Admin');
      }
    } catch (error) {
      print('Error: $error | Error.toString(): ${error.toString()}');
      throw (error.toString());
    }
  } //Untested

  void removeSkill(String id, int index) {
    int i = _skills.indexWhere((skill) => skill.id == id);
    _skills.removeAt(i);
    notifyListeners();
  } //Untested

  // Get Skills from Data and decode the JSON
}
