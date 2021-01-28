import 'package:flutter/foundation.dart';
import '../models/skill.dart';

class Class {
  @required
  final String classId;
  @required
  final String title;
  @required
  final String description;
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
    this.title,
    this.description,
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
}
