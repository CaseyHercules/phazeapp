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

class User {
  String? email;
  String? preferedName;
  String? userId;
  List<String?>? passportIds;

  User({
    this.userId,
    this.email,
    this.preferedName,
    this.passportIds,
  });
}
