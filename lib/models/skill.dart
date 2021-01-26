import 'package:flutter/foundation.dart';

class Skill {
  @required
  final String id;
  @required
  final String classId;
  @required
  final String title;
  @required
  final String description;
  final String descriptionShort;
  @required
  final int tier;
  final String skillClassification;
  final Skill parentSkill;
  final List<Skill> prerequisiteSkills;
  final int permenentEpReduction;
  @required
  final String epCost;
  @required
  final String activation;
  @required
  final String duration;
  @required
  final String abilityCheck;

  Skill(
      {this.id,
      this.classId,
      this.title,
      this.description,
      this.descriptionShort,
      this.tier,
      this.skillClassification,
      this.parentSkill,
      this.prerequisiteSkills,
      this.permenentEpReduction,
      this.epCost,
      this.activation,
      this.duration,
      this.abilityCheck});
}
