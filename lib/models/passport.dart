import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../models/http_exception.dart';
import 'class.dart';
import 'skill.dart';

class Passport {
  @required
  String id;
  @required
  String playerId;
  @required
  String name;
  String? specialAbility;
  @required
  Class? primaryClass;
  List<Skill?>? primaryClassSkills;
  Class? secondaryClass;
  List<Skill?>? secondaryClassSkills;
  @required
  int alignment;
  @required
  int totalLevel;
  int primaryClassLevel;
  int secondaryClassLevel;
  String? RaceId; //Change to race Class when created
  List<String?>? dinguses;

  Passport({
    this.id = '', //Leave blank
    this.playerId = '',
    this.name = '',
    this.specialAbility,
    this.primaryClass,
    this.primaryClassSkills,
    this.secondaryClass,
    this.secondaryClassSkills,
    this.alignment = 0,
    this.totalLevel = 0,
    this.primaryClassLevel = 0,
    this.secondaryClassLevel = 0,
    this.RaceId,
    this.dinguses,
  });

  String? getId(Passport passport) {
    return this.id;
  }

  void printPassport() {
    print('ID: $id');
    print('Player ID: $playerId');
    print('Name: $name');
    print('specialAbility: $specialAbility');
    print('ID: $primaryClass');
    print('ID: $primaryClassSkills');
    print('ID: $secondaryClass');
    print('ID: $secondaryClassSkills');
    print('ID: $alignment');
    print('ID: $totalLevel');
    print('ID: $primaryClassLevel');
    print('ID: $secondaryClassLevel');
    print('ID: $RaceId');
    print('ID: $dinguses');
  }
}
