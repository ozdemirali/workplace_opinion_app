import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/widgets/studentToWorkplace.dart';

class StudentPlacement extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StudentPlacementState();
  }

}

class StudentPlacementState extends State<StudentPlacement> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
          child:studentToWorkplace(),
        ),
      ],
    );
  }
}