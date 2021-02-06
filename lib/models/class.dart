import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import 'skill.dart';

class Class {
  @required
  final String classId;
  @required
  final bool isPrimary;
  @required
  final String title;
  @required
  final String description;
  @required
  final List<Skill> grantedSkills;
  @required
  final List<Skill> classSkills;
  @required
  final List<int>
      skillLevelGainAtLevel; //0-20 0 is no skill gain, 1 is tier 1 skill gain, 2 is tier 2 skill gain
  @required
  final List<int> health;
  @required
  final List<int> ep;
  @required
  final List<int> attack;
  @required
  final List<int> accuracy;
  @required
  final List<int> defense;
  @required
  final List<int> resistance;
  @required
  final List<int> toughSave;
  @required
  final List<int> quickSave;
  @required
  final List<int> mindSave;

  Class({
    this.classId,
    this.isPrimary,
    this.title,
    this.description,
    this.grantedSkills,
    this.classSkills,
    this.skillLevelGainAtLevel,
    this.health,
    this.ep,
    this.attack,
    this.accuracy,
    this.defense,
    this.resistance,
    this.toughSave,
    this.quickSave,
    this.mindSave,
  });
  void printClass() {
    print('ID: $classId');
    print('Title: $title');
    print('Is Primary: $isPrimary');
    print('Description: $description');
    print('Granted Skills: $grantedSkills');
    print('Class Skills: $classSkills');
    print('Skill Gain: $skillLevelGainAtLevel');
    print('Health: $health');
    print('Ep: $ep');
    print('Attack: $attack');
    print('Accuracy: $accuracy');
    print('Defense: $defense');
    print('Resistance: $resistance');
    print('MindSave: $mindSave');
    print('ToughSave: $toughSave');
    print('QuickSave: $quickSave');
  }
}

class Classes extends ChangeNotifier {
  List<Class> _classes = [
    Class(
      classId: '001',
      isPrimary: true,
      title: 't',
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
    ),
    Class(
      classId: '002',
      isPrimary: true,
      title: 'Scholar Test',
      description: 'Test',
      grantedSkills: null,
      classSkills: null,
      skillLevelGainAtLevel: [
        0,
        1,
        0,
        1,
        0,
        1,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        3,
        3,
        3,
        3,
        3,
        3,
        3,
        4,
      ],
      health: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      ep: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      attack: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      accuracy: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      defense: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      resistance: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      toughSave: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      quickSave: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
      mindSave: [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20
      ],
    ),
  ];

  List<Class> get classes {
    return [..._classes];
  }

  void test() {
    _classes.forEach((c) {
      printClass(c);
    });
  }

  void printClass(Class c) {
    print('ID: ${c.classId}');
    print('Title: ${c.title}');
    print('Is Primary: ${c.isPrimary}');
    print('Description: ${c.description}');
    print('Granted Skills: ${c.grantedSkills}');
    print('Class Skills: ${c.classSkills}');
    print('Skill Gain: ${c.skillLevelGainAtLevel}');
    print('Health: ${c.health}');
    print('Ep: ${c.ep}');
    print('Attack: ${c.attack}');
    print('Accuracy: ${c.accuracy}');
    print('Defense: ${c.defense}');
    print('Resistance: ${c.resistance}');
    print('MindSave: ${c.mindSave}');
    print('ToughSave: ${c.toughSave}');
    print('QuickSave: ${c.quickSave}');
  } //Not Tested

  Class findById(String id) {
    if (id == null || id == '') {
      return null;
    }
    return _classes.firstWhere((c) => c.classId == id, orElse: () => null);
  } // Not Tested

  List<Class> classesWithTitle(String title, [int results = 5]) {
    List<Class> _searchedClasses = [];
    if (title == '' || title == null) {
      return [];
    }
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].title.toLowerCase().contains(title.toLowerCase())) {
        _searchedClasses.add(_classes[i]);
      }
      if (_searchedClasses.length >= results) {
        break;
      }
    }
    return _searchedClasses;
  } // Not Tested

  //Fetch and Set Classes
  //Add Class
  Future<void> addSkill(Class c, [bool atTop = true]) async {
    const url =
        'https://interphaze-pocket-scholar-default-rtdb.firebaseio.com/skills.json';
    try {
      print(c.skillLevelGainAtLevel.toString());
      print(c.skillLevelGainAtLevel);
      // final response = await http.post(
      //   url,
      //   body: jsonEncode(
      //     {
      //       'title': c.title,
      //       'description': c.description,
      //       'grantedSkillsIds': null,
      //       'classSkillsIds': null,
      //       'skillLevelGainAtLevel': c.skillLevelGainAtLevel.toString(),
      //       'health': c.health.toString(),
      //       'ep': c.ep,
      //       'attack': c.attack,
      //       'accuracy': c.accuracy,
      //       'defense': c.defense,
      //       'resistance': c.resistance,
      //       'mindSave': c.mindSave,
      //       'toughSave': c.toughSave,
      //       'quickSave': c.quickSave,
      //     },
      //   ),
      // );
    } catch (error) {}
    //Update Class
    //Delete Class
  }
}
