import 'dart:convert';
import 'package:http/http.dart';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:backendless_todo_starter/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/unit_entry.dart';

class TodoService with ChangeNotifier {
  Map<String, dynamic> _map = {};
  bool _error = false;
  String _errorMessage = '';

  Map<String, dynamic> get map => _map;
  bool get error => _error;
  String get errorMessage => _errorMessage;

  Future<void> get fetchData async {
    final response = await get(Uri.parse(
        'https://dl.dropboxusercontent.com/s/q6chvs5eqktd1nb/unitReflections.json?dl=0'));

    if (response.statusCode == 200) {
      try {
        _map = jsonDecode(response.body);
        _error = false;
      } catch (e) {
        //If response is not 200 print out error and make the map empty
        _error = true;
        _errorMessage = e.toString();
        _map = {};
      }
    } else {
      _error = true;
      _errorMessage = 'Failed to retrieve data';
      _map = {};
    }
    notifyListeners();
  }

  void initialValues() {
    _map = {};
    _error = false;
    _errorMessage = '';
    notifyListeners();
  }

  UnitEntry? _unitEntry;

  List<Unit> _units = [];
  List<Unit> get todos => _units;

  void emptyTodos() {
    _units = [];
    notifyListeners();
  }

  bool _busyRetrieving = false;
  bool _busySaving = false;

  bool get busyRetrieving => _busyRetrieving;
  bool get busySaving => _busySaving;

  Future<String> getTodos(String username) async {
    String result = 'OK';
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "username = '$username'";

    _busyRetrieving = true;
    notifyListeners();

    List<Map<dynamic, dynamic>?>? map = await Backendless.data
        .of('UnitEntry')
        .find(queryBuilder)
        .onError((error, stackTrace) {
      result = error.toString();
      return null;
    });

    if (result != 'OK') {
      _busyRetrieving = false;
      notifyListeners();
      return result;
    }

    if (map != null) {
      if (map.length > 0) {
        _unitEntry = UnitEntry.fromJson(map.first);
        _units = convertMapToTodoList(_unitEntry!.todos);
        notifyListeners();
      } else {
        emptyTodos();
      }
    } else {
      result = 'NOT OK';
    }

    _busyRetrieving = false;
    notifyListeners();

    return result;
  }

  Future<String> saveTodoEntry(String username, bool inUI) async {
    String result = 'OK';

    if (_unitEntry == null) {
      _unitEntry =
          UnitEntry(todos: convertTodoListToMap(_units), username: username);
    } else {
      _unitEntry!.todos = convertTodoListToMap(_units);
    }

    if (inUI) {
      _busySaving = true;
      notifyListeners();
    }
    await Backendless.data
        .of('UnitEntry')
        .save(_unitEntry!.toJson())
        .onError((error, stackTrace) {
      result = error.toString();
      return null;
    });

    if (inUI) {
      _busySaving = false;
      notifyListeners();
    }

    return result;
  }

  void deleteTodo(Unit unit) {
    _units.remove(unit);
    notifyListeners();
  }

  void createTodo(Unit unit) {
    _units.insert(0, unit);
    notifyListeners();
  }
}
