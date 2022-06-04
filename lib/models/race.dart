import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../models/http_exception.dart';

class Race {
  @required
  String? rid;
  @required
  String? name;
  String? description;
  String? name_desc;
  List<String?>? Stats; //[TODO Replace with stat object]
}
