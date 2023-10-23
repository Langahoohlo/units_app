import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:backendless_todo_starter/routes/routes.dart';
import 'package:backendless_todo_starter/services/helper_unit.dart';
import 'package:backendless_todo_starter/services/helper_user.dart';
import 'package:backendless_todo_starter/services/user_service.dart';
import 'package:backendless_todo_starter/widgets/app_progress_indicator.dart';
import 'package:backendless_todo_starter/widgets/unit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:tuple/tuple.dart';

import '../services/unit_service.dart';

class UnitReflectionsPage extends StatefulWidget {
  const UnitReflectionsPage({Key? key}) : super(key: key);

  @override
  _UnitReflectionsPage createState() => _UnitReflectionsPage();
}

class _UnitReflectionsPage extends State<UnitReflectionsPage> {
  late TextEditingController unitController;
  late TextEditingController reflectionsController;

  @override
  void initState() {
    super.initState();
    unitController = TextEditingController();
    reflectionsController = TextEditingController();
  }

  @override
  void dispose() {
    unitController.dispose();
    reflectionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.black],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RouteManager.unitPage);
                            }),
                        IconButton(
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            logoutUserInUI(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: provider.Selector<UserService, BackendlessUser?>(
                      selector: (context, value) => value.currentUser,
                      builder: (context, value, child) {
                        return value == null
                            ? Text('Todo List')
                            : Text('${value.getProperty('name')}\'s Units',
                                style: const TextStyle(
                                    fontSize: 40.0,
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic));
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 20),
                        child: provider.Consumer<TodoService>(
                          builder: (context, value, child) {
                            return value.todos.length == 0
                                ? Text('First Login')
                                : ListView.builder(
                                    itemCount: value.todos.length,
                                    itemBuilder: (context, index) {
                                      return UnitCard(
                                        unit: value.todos[index],
                                        deleteAction: (context) async {
                                          context
                                              .read<TodoService>()
                                              .deleteTodo(value.todos[index]);
                                        },
                                      );
                                    },
                                  );
                          },
                        )),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        // Created units are saved locally until this is pressed to save in the server.
                        saveAllUnitsInUI(context);
                      },
                      child: Text('Save Unit Entries')),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            provider.Selector<UserService, Tuple2>(
                selector: (context, value) =>
                    Tuple2(value.showUserProgress, value.userProgressText),
                builder: (context, value, child) {
                  return value.item1
                      ? AppProgressIndicator(text: value.item2)
                      : Container();
                }),
          ],
        ),
      ),
    );
  }
}
