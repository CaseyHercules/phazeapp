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
  final String skillGroupDescription;
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
      this.skillGroupDescription,
      this.prerequisiteSkills,
      this.permenentEpReduction,
      this.epCost,
      this.activation,
      this.duration,
      this.abilityCheck,
      this.canBeTakenMultiple,
      this.playerVisable});

  String getId(Skill skill) {
    return this.id;
  }
}

class Skills with ChangeNotifier {
  List<Skill> _skills = [];

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
    print('Skill Group Desc: ${s.skillGroupDescription}');
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
    if (id == null || id == '') {
      return null;
    }
    return _skills.firstWhere((skill) => skill.id == id, orElse: () => null);
  } //Tested Works

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

  Future<void> fetchAndSetSkills() async {
    const url =
        'https://interphaze-pocket-scholar-default-rtdb.firebaseio.com/skills.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Skill> loadedSkills = [];
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((id, skill) {
        //First Run, MUST RUN TWICE FOR EDGE CASE
        //Where prerequisiteSkill isn't loaded, so find by ID returns null
        //But On loading this pile of skills,
        //prerequisiteSkill could now be loaded
        loadedSkills.add(
          Skill(
            id: id,
            title: skill['title'],
            description: skill['description'],
            descriptionShort: skill['descriptionShort'],
            tier: skill['tier'],
            //parentSkill: null,
            skillGroupName: skill['skillGroupName'] == skill['title']
                ? ''
                : skill['skillGroupName'],
            skillGroupDescription: skill['skillGroupDescription'],
            //prerequisiteSkills: null,
            permenentEpReduction: skill['permenentEpReduction'],
            epCost: (skill['epCost'] == null) ? 'None' : skill['epCost'],
            activation: skill['activation'],
            duration: skill['duration'],
            abilityCheck: skill['abilityCheck'],
            canBeTakenMultiple: skill['canBeTakenMultiple'],
            playerVisable: skill['playerVisable'],
          ),
        );
      });
      _skills = loadedSkills;
      loadedSkills = [];

      //Second Run
      extractedData.forEach((id, skill) {
        loadedSkills.add(
          Skill(
            id: id,
            title: skill['title'],
            description: skill['description'],
            descriptionShort: skill['descriptionShort'],
            tier: skill['tier'],
            parentSkill: findById(skill['parentSkillId']),
            skillGroupName: skill['skillGroupName'] == skill['title']
                ? ''
                : skill['skillGroupName'],
            skillGroupDescription: skill['skillGroupDescription'],
            prerequisiteSkills: skill['prerequisiteSkillsIds'].toString() != ''
                ? skill['prerequisiteSkillsIds']
                    .toString()
                    .split(",")
                    .map((s) => findById(s))
                    .toList()
                : [],
            permenentEpReduction: skill['permenentEpReduction'],
            epCost: (skill['epCost'] == null) ? 'None' : skill['epCost'],
            activation: skill['activation'],
            duration: skill['duration'],
            abilityCheck: skill['abilityCheck'],
            canBeTakenMultiple: skill['canBeTakenMultiple'],
            playerVisable: skill['playerVisable'],
          ),
        );
      });
      _skills = loadedSkills;
      loadedSkills = [];
    } catch (error) {
      print(error);
      throw (error);
    }
  }

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
            'skillGroupDescription': skill.skillGroupDescription,
            //Needs to be TESTED, is List<Skill>
            'prerequisiteSkillsIds': skill.prerequisiteSkills == null
                ? ''
                : [...skill.prerequisiteSkills.map((s) => s.id)].join(","),
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
      if (response.statusCode >= 400) {
        throw HttpException(
            'Couldn\'t reach server. Error:${response.statusCode}');
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateSkill(Skill updatedSkill) async {
    //Untested
    print('ID: ${updatedSkill.id}');
    final url =
        'https://interphaze-pocket-scholar-default-rtdb.firebaseio.com/skills/${updatedSkill.id}.json';
    try {
      final response = await http.patch(
        url,
        body: jsonEncode(
          {
            'title': updatedSkill.title,
            'description': updatedSkill.description,
            'descriptionShort': updatedSkill.descriptionShort,
            'tier': updatedSkill.tier,
            'parentSkillId': updatedSkill.parentSkill == null
                ? ''
                : updatedSkill.parentSkill.id,
            'skillGroupName': updatedSkill.skillGroupName,
            'skillGroupDescription': updatedSkill.skillGroupDescription,
            'prerequisiteSkillsIds': updatedSkill.prerequisiteSkills == null
                ? ''
                : [...updatedSkill.prerequisiteSkills.map((s) => s.id)]
                    .join(","),
            'permenentEpReduction': updatedSkill.permenentEpReduction,
            'epCost': updatedSkill.epCost,
            'activation': updatedSkill.activation,
            'duration': updatedSkill.duration,
            'abilityCheck': updatedSkill.abilityCheck,
            'canBeTakenMultiple': updatedSkill.canBeTakenMultiple,
            'playerVisable': updatedSkill.playerVisable,
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException(
            'Couldn\'t reach server. Error:${response.statusCode}');
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteSkill(Skill skill) async {
    //Untested
    final url =
        'https://interphaze-pocket-scholar-default-rtdb.firebaseio.com/skills/${skill.id}.json';
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException(
            'Couldn\'t reach server. Error:${response.statusCode}');
      }
    } catch (error) {
      throw (error);
    } finally {
      _skills.removeAt(_skills.indexWhere((s) => s.id == skill.id));
      notifyListeners();
    }
  }

  // Get Skills from Data and decode the JSON

  // void moveSkill(String id, int index) {
  //   int i = _skills.indexWhere((skill) => skill.id == id);
  //   var _tempSkill = _skills[i];
  //   _skills.removeAt(i);
  //   _skills.insert(index, _tempSkill);
  //   notifyListeners();
  // } //Untested
}
