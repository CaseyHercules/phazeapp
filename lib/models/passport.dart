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
  String pid;
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
  String? race; //Change to race Class when created
  List<String?>? dinguses;

  Passport({
    this.pid = '', //Leave blank
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
    this.race,
    this.dinguses,
  });

  String? getId(Passport passport) {
    return this.pid;
  }

  void printPassport() {
    print('ID: $pid');
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
    print('ID: $race');
    print('ID: $dinguses');
  }

  Future<void> fetchPassport(passportId) async {
    //TODO Incomplete
    var url = Uri.https(
      'interphaze-pocket-scholar-default-rtdb.firebaseio.com/passport/',
      '$passportId.json',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        print("Didn't Recieve Passport");
        return;
      }
      print(extractedData);
      //extractedData.forEach((id, c) {});
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //Create Passport
  Future<void> createPassport(Passport p) async {
    var url = Uri.https(
      'interphaze-pocket-scholar-default-rtdb.firebaseio.com',
      'passport.json',
    );
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'name': p.name,
            'playerId': p.playerId,
            'totalLevel': p.totalLevel,
            'primaryClass':
                p.primaryClass == null ? '' : p.primaryClass!.classId,
            'primaryClassSkills': p.primaryClassSkills == null
                ? ''
                : [...p.primaryClassSkills!.map((s) => s!.id)].join(","),
            'primaryClassLevel': p.primaryClassLevel,
            'secondaryClass':
                p.secondaryClass == null ? '' : p.secondaryClass!.classId,
            'secondaryClassSkills': p.secondaryClassSkills == null
                ? ''
                : [...p.secondaryClassSkills!.map((s) => s!.id)].join(","),
            'secondaryClassLevel': p.secondaryClassLevel,
            'alignment': p.alignment,
            'race': p.race, //Will be race.id once race object is created
            'specialAbility': p.specialAbility,
            'dinguses': [...p.dinguses!].join(","),
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException(
            'Couldn\'t reach server. Error:${response.statusCode}');
      }
    } catch (e) {}
  }

  //Update Passport
  Future<void> updatePassport(Passport p) async {
    var url = Uri.https(
      'interphaze-pocket-scholar-default-rtdb.firebaseio.com',
      'passport/${p.pid}.json',
    );
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'name': p.name,
            'playerId': p.playerId,
            'totalLevel': p.totalLevel,
            'primaryClass':
                p.primaryClass == null ? '' : p.primaryClass!.classId,
            'primaryClassSkills': p.primaryClassSkills == null
                ? ''
                : [...p.primaryClassSkills!.map((s) => s!.id)].join(","),
            'primaryClassLevel': p.primaryClassLevel,
            'secondaryClass':
                p.secondaryClass == null ? '' : p.secondaryClass!.classId,
            'secondaryClassSkills': p.secondaryClassSkills == null
                ? ''
                : [...p.secondaryClassSkills!.map((s) => s!.id)].join(","),
            'secondaryClassLevel': p.secondaryClassLevel,
            'alignment': p.alignment,
            'race': p.race, //Will be race.id once race object is created
            'specialAbility': p.specialAbility,
            'dinguses': [...p.dinguses!].join(","),
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException(
            'Couldn\'t reach server. Error:${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
