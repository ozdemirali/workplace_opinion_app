import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/models/period.dart';


// ignore: must_be_immutable
class AcademicYear extends StatefulWidget{
  AcademicYear({this.database,this.period,this.year});

  TextEditingController period;
  TextEditingController year;
  FirebaseDatabase database;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AcademicYearState();
  }
}

class AcademicYearState extends State<AcademicYear>{
  List<Period> period=new List();
  String _selectValue;

  @override
  void initState(){
    super.initState();
    if(widget.period.text!="")
      _selectValue=widget.period.text;

    widget.database
        .reference()
        .child("academic_year").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
      snapshot.value.forEach((v){
        //print(v);
        if(v!=null) {
          period.add(Period(v["period"], v["year"]));
        }

      });
    });

  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      period.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              hint: Text("Eğtim Öğretim Yılı"),
              value: _selectValue,
              items: period
                  .map((label) => DropdownMenuItem(
                child: Text(label.period),
                value: label.period,
              )).toList(),
              onChanged: (value){
                setState(() {
                  period.forEach((f){
                    _selectValue=value;
                    if(f.period==value){
                      widget.period.text=f.period;
                      widget.year.text=f.year;
                    }
                    // print(widget.period.text);
                    // print(widget.year.text);
                  });
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}