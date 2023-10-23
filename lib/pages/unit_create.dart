import 'package:flutter/material.dart';

import '../widgets/unitEntryForm.dart';

class UnitCreatePage extends StatelessWidget {
  const UnitCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Unit'),
      ),
      body: SingleChildScrollView(child: UnitCreateForm()),
    );
  }
}
