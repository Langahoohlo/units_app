import 'package:flutter/material.dart';

class UnitsView extends StatefulWidget {
  final String unitDesc;
  final String reflections;
  const UnitsView({Key? key, required this.unitDesc, required this.reflections})
      : super(key: key);

  @override
  State<UnitsView> createState() => _UnitsView();
}

class _UnitsView extends State<UnitsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Unit View'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.unitDesc,
                        style: TextStyle(color: Colors.white),
                      ),
                    ))),
            SizedBox(height: 20),
            Container(
              height: 250,
              width: 375,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.reflections,
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ));
  }
}
