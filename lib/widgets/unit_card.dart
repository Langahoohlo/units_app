import 'package:backendless_todo_starter/models/todo.dart';
import 'package:backendless_todo_starter/pages/units_view.dart';
import 'package:flutter/material.dart';

class UnitCard extends StatelessWidget {
  const UnitCard({
    Key? key,
    required this.unit,
    required this.deleteAction,
  }) : super(key: key);
  final Unit unit;
  final Function(BuildContext context) deleteAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade300,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UnitsView(
              unitDesc: unit.unitDesc,
              reflections: unit.refelctions,
            );
          }));
        },
        child: Card(
          color: Colors.purple,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(unit.unitDesc),
          ),
        ),
      ),
    );
  }
}
