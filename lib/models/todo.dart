import 'package:flutter/foundation.dart';

class CurrentUnits with ChangeNotifier {
  Map<String, dynamic> _map = {};
  bool _error = false;
  String _errorMessage = '';

  Map<String, dynamic> get map => _map;
  bool get error => _error;
  String get errorMessage => _errorMessage;

  void initialValues() {
    _map = {};
    _error = false;
    _errorMessage = '';
    notifyListeners();
  }
}

Map<dynamic, dynamic> convertTodoListToMap(List<Unit> unit) {
  Map<dynamic, dynamic> map = {};
  for (var i = 0; i < unit.length; i++) {
    map.addAll({'$i': unit[i].toJson()});
  }
  return map;
}

List<Unit> convertMapToTodoList(Map<dynamic, dynamic> map) {
  List<Unit> todos = [];
  for (var i = 0; i < map.length; i++) {
    todos.add(Unit.fromJson(map['$i']));
  }
  return todos;
}

class Unit {
  // Set up the json model for out units saves.
  final String unitDesc;
  final String refelctions;

  Unit({
    required this.unitDesc,
    required this.refelctions,
  });

  Map<String, Object?> toJson() => {
        'untiDesc': unitDesc,
        'reflections': refelctions,
      };

  // How it will be stored in the JSON
  static Unit fromJson(Map<dynamic, dynamic>? json) => Unit(
      unitDesc: json!['unitDesc'] as String,
      refelctions: json['reflections'] as String);

  // To make sure the are no duplicates we will make every entry uppercase to make sure its not a duplicate
  @override
  bool operator ==(covariant Unit todo) {
    return (this
            .unitDesc
            .toUpperCase()
            .compareTo(todo.unitDesc.toUpperCase()) ==
        0);
  }

  @override
  int get hashCode {
    return unitDesc.hashCode;
  }
}
