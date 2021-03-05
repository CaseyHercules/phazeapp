import 'dart:developer';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../models/http_exception.dart';

class Skill {
  @required
  final String? id; //Use Id of _all if viewable by all classes
  @required
  final String? title;
  @required
  final String? description;
  final String? descriptionShort;
  @required
  final int? tier;
  final Skill? parentSkill;
  final String? skillGroupName;
  final String? skillGroupDescription;
  final List<Skill?>? prerequisiteSkills;
  final List<String>? additionalData;
  @required
  final int? permenentEpReduction;
  @required
  final String? epCost;
  @required
  final String? activation;
  @required
  final String? duration;
  @required
  final String? abilityCheck;
  @required
  final bool? canBeTakenMultiple;
  @required
  final bool? playerVisable;

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
      this.additionalData,
      this.permenentEpReduction,
      this.epCost,
      this.activation,
      this.duration,
      this.abilityCheck,
      this.canBeTakenMultiple,
      this.playerVisable});

  String? getId(Skill skill) {
    return this.id;
  }

  void printSkill() {
    print('ID: $id');
    print('Title: $title');
    print('Desc: $description');
    print('DescS: $descriptionShort');
    print('Tier: $tier');
    print('Parent: ${parentSkill == null ? 'None' : parentSkill!.title}');
    print('Skill Group: $skillGroupName');
    print('Skill Group Desc: $skillGroupDescription');
    (prerequisiteSkills == null || prerequisiteSkills!.length == 0)
        ? print('Preq: None')
        : prerequisiteSkills!
            .forEach((skill) => print('Preq: ${skill!.title}'));
    print('pEpRedux: $permenentEpReduction');
    print('Ep Cost: $epCost');
    print('Activation: $activation');
    print('Duration: $duration');
    print('Ability Check: $abilityCheck');
    print('Taken Mutiple: $canBeTakenMultiple');
    print('Visable: $playerVisable');
    print('Additional Data: $additionalData');
  }
}

class Skills with ChangeNotifier {
  List<Skill> _skills = [];

  List<Skill> get skills {
    return [..._skills];
  }

  int count() {
    return _skills.length;
  }

  Skill? findById(String? id) {
    if (id == null || id == '') {
      return null;
    }
    return _skills.firstWhereOrNull((skill) => skill.id == id);
  } //Tested Works

  List<Skill> skillsWithTitle(String title, [int results = 5]) {
    List<Skill> _searchedSkills = [];
    if (title == '' || title == null) {
      return [];
    }
    for (int i = 0; i < _skills.length; i++) {
      if (_skills[i].title!.toLowerCase().contains(title.toLowerCase()) ||
          ((_skills[i].skillGroupName == null ||
                  _skills[i].skillGroupName == '')
              ? false
              : _skills[i]
                  .skillGroupName!
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

  Future<void> fetchAndSetSkills({
    bool fromOnline = false,
    bool forceRefresh = false,
  }) async {
    Map<String, dynamic>? container;
    bool _skillsSet = false;
    if (kIsWeb) {
      fromOnline = true;
    } else {
      try {
        readSkills();
        _skillsSet = true;
      } catch (error) {
        _skillsSet = false;
      }
    }

    try {
      if (fromOnline || forceRefresh || (!_skillsSet)) {
        var url = Uri.https(
          'interphaze-pocket-scholar-default-rtdb.firebaseio.com',
          'skills.json',
        );
        final response = await http.get(url);
        container = json.decode(response.body) as Map<String, dynamic>?;
        if (!kIsWeb) {
          await writeSkills();
        }
      } else {
        final response = await readSkills();
        container = json.decode(response) as Map<String, dynamic>?;
      }

      final extractedData = container;

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
            additionalData: skill['additionalData'] == null
                ? null
                : skill['additionalData'].cast<String>(),
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
            additionalData: skill['additionalData'] == null
                ? null
                : skill['additionalData'].cast<String>(),
          ),
        );
      });
      // _skills.forEach((s) {
      //   s.printSkill();
      // });
      _skills = loadedSkills;
      loadedSkills = [];
      notifyListeners();
    } catch (error) {
      print('Error State $error');
      throw (error);
    }
  }

  Future<String> printSkillJSON() async {
    var url = Uri.https(
      'interphaze-pocket-scholar-default-rtdb.firebaseio.com',
      'skills.json',
    );

    try {
      final response = await http.get(url);
      //print('Responce @ printSkillJSON(): ${response.body}');
      return response.body;
    } catch (error) {
      print('Error @ printSkillJSON(): $error');
      return error.toString();
    }
  }

  Future<void> addSkill(Skill skill, [bool atTop = true]) async {
    var url = Uri.https(
      'interphaze-pocket-scholar-default-rtdb.firebaseio.com',
      'skills.json',
    );
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': skill.title,
            'description': skill.description,
            'descriptionShort': skill.descriptionShort,
            'tier': skill.tier,
            'parentSkillId':
                skill.parentSkill == null ? '' : skill.parentSkill!.id,
            'skillGroupName': skill.skillGroupName,
            'skillGroupDescription': skill.skillGroupDescription,
            'prerequisiteSkillsIds': skill.prerequisiteSkills == null
                ? ''
                : [...skill.prerequisiteSkills!.map((s) => s!.id)].join(","),
            'permenentEpReduction': skill.permenentEpReduction,
            'epCost': skill.epCost,
            'activation': skill.activation,
            'duration': skill.duration,
            'abilityCheck': skill.abilityCheck,
            'canBeTakenMultiple': skill.canBeTakenMultiple,
            'playerVisable': skill.playerVisable,
            'additionalData': skill.additionalData,
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
    var url = Uri.https(
      'interphaze-pocket-scholar-default-rtdb.firebaseio.com',
      'skills/${updatedSkill.id}.json',
    );
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
                : updatedSkill.parentSkill!.id,
            'skillGroupName': updatedSkill.skillGroupName,
            'skillGroupDescription': updatedSkill.skillGroupDescription,
            'prerequisiteSkillsIds': updatedSkill.prerequisiteSkills == null
                ? ''
                : [...updatedSkill.prerequisiteSkills!.map((s) => s!.id)]
                    .join(","),
            'permenentEpReduction': updatedSkill.permenentEpReduction,
            'epCost': updatedSkill.epCost,
            'activation': updatedSkill.activation,
            'duration': updatedSkill.duration,
            'abilityCheck': updatedSkill.abilityCheck,
            'canBeTakenMultiple': updatedSkill.canBeTakenMultiple,
            'playerVisable': updatedSkill.playerVisable,
            'additionalData': updatedSkill.additionalData,
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
    var url = Uri.https(
      'interphaze-pocket-scholar-default-rtdb.firebaseio.com',
      'skills/${skill.id}.json',
    );
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

  //Storage Stuff
  Future<String> get _localPath async {
    print('Attempting to get LocalPath');
    final directory = await getApplicationDocumentsDirectory();
    print('LocalPath: ${directory.path}');
    return directory.path;
  }

  Future<File> get _localFile async {
    print('Attempting to get LocalFile');
    final path = await _localPath;
    return File('$path/skills.json');
  }

  Future<File> writeSkills() async {
    print('Attempting to access skills.json LocalFile');
    final file = await _localFile;
    return file.writeAsString(await printSkillJSON());
  }

  bool isFile() {
    try {
      readSkills();
      return true;
    } catch (e) {
      return false;
    }
  }

  void deleteFile() async {
    final file = await _localFile;
    file.delete();
  }

  Future<String> readSkills() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (error) {
      return error.toString();
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
