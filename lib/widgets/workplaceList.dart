import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/models/WorkplaceForDropDown.dart';

// ignore: must_be_immutable
class WorkplaceList extends StatefulWidget{
  WorkplaceList({this.database,this.workplace,this.workplaceName,this.workplaceType});

TextEditingController workplace;
TextEditingController workplaceName;
TextEditingController workplaceType;
FirebaseDatabase database;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WorkplaceListState();
  }
}

class WorkplaceListState extends State<WorkplaceList>{
  List<WorkplaceForDropDown> workplace=new List();
  String _selectValue;


  @override
  void initState(){
    super.initState();
    if(widget.workplace.text!=""){
      _selectValue=widget.workplace.text;
    }
    widget.database
        .reference()
        .child("workplace")
        .once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      values.forEach((k,v) {
        workplace.add(WorkplaceForDropDown(k,v["name"],v["type"]));
      });
    });
  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      workplace.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              hint: Text("İş Yeri Seçiniz"),
              value: _selectValue,
              items: workplace
                  .map((label) => DropdownMenuItem(
                child: Text(label.name),
                value: label.key,
              )).toList(),
              onChanged: (value){
                setState(() {
                  _selectValue=value;
                   print(value);
                  workplace.forEach((f){
                    if(f.key==value){
                      widget.workplace.text=f.key;
                      widget.workplaceName.text=f.name;
                      widget.workplaceType.text=f.type;
                    }
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
