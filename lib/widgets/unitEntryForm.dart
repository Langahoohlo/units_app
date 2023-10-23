import 'package:flutter/material.dart';

import '../services/helper_unit.dart';
import '../services/user_service.dart';

class UnitCreateForm extends StatefulWidget {
  const UnitCreateForm({
    Key? key,
  }) : super(key: key);

  @override
  State<UnitCreateForm> createState() => _UnitCreateForm();
}

class _UnitCreateForm extends State<UnitCreateForm> {
  final unitFormKey = GlobalKey<FormState>();

  late TextEditingController unitDesc;
  late TextEditingController reflections;

  @override
  void initState() {
    super.initState();
    unitDesc = TextEditingController();
    reflections = TextEditingController();
  }

  @override
  void dispose() {
    unitDesc.dispose();
    reflections.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: unitFormKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                validator: validateEmptyTitle,
                controller: unitDesc,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                    fontSize: 10,
                  ),
                  prefixIcon: Icon(
                    Icons.note,
                    color: Colors.deepPurple,
                  ),
                  labelText: 'Unit Description',
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                )),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
                maxLines: 5,
                validator: validateEmptyTitle,
                controller: reflections,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                    fontSize: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.deepPurple,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.abc,
                    color: Colors.deepPurple,
                  ),
                  errorMaxLines: 3,
                  labelText: 'Reflections',
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                )),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: () {
                createNewUnitInUI(
                  context,
                  unitDescController: unitDesc,
                  reflectionsController: reflections,
                );
              }, // Creates note in the UI
              child: const Text('Save Unit'),
            ),
          ],
        ),
      ),
    );
  }
}
