import 'package:backendless_todo_starter/services/user_service.dart';
import 'package:backendless_todo_starter/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';
import 'unit_service.dart';

void saveAllUnitsInUI(BuildContext context) async {
  // TODO
  String result = await context
      .read<TodoService>()
      .saveTodoEntry(context.read<UserService>().currentUser!.email, true);

  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showSnackBar(context, 'Data succesfuly Saved');
  }
}

void createNewUnitInUI(BuildContext context,
    {required TextEditingController unitDescController,
    required TextEditingController reflectionsController}) async {
  // Both fields are required to create a units entry.
  if (unitDescController.text.isEmpty && reflectionsController.text.isEmpty) {
    showSnackBar(context, 'Please enter a both fields, then save!');
  } else {
    Unit todo = Unit(
        // created: DateTime.now(),
        refelctions: reflectionsController.text.trim(),
        unitDesc: unitDescController.text.trim());

    if (context.read<TodoService>().todos.contains(todo)) {
      showSnackBar(context, 'Duplicate');
    } else {
      unitDescController.text = '';
      context.read<TodoService>().createTodo(todo);
      Navigator.pop(context);
    }
  }
}
