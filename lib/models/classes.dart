import 'package:flutter/foundation.dart';

class Class {
  @required
  final String classId;
  @required
  final String title;
  @required
  final String description;
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
