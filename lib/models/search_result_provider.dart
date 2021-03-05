import 'package:flutter/foundation.dart';

class SearchResultProvider with ChangeNotifier {
  // ignore: unused_field
  String? _id;

  //SearchResultProvider(this._id);

  String get id {
    return id;
  }

  void setId(String id) {
    _id = id;
    notifyListeners();
  }
}
