import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';




// ignore: must_be_immutable
class Type extends StatefulWidget{
  Type({this.database,this.selectValue,this.select});

  TextEditingController selectValue;
  String select;
  FirebaseDatabase database;


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TypeState();
  }
}

class TypeState extends State<Type>{
  List<String> type=new List();
  String _selectValue;

  @override
  void initState(){
    super.initState();
    if(widget.selectValue.text!="")
      _selectValue=widget.selectValue.text;

    if(widget.select.toLowerCase()=="type"){
      widget.database
          .reference()
          .child("type").orderByKey()
          .once()
          .then((DataSnapshot snapshot){
        snapshot.value.forEach((value){
          if(value!=null){
            type.add(value["name"].trim());
          }
        });
      });
    }
    else{
      widget.database
          .reference()
          .child("type").orderByKey().limitToFirst(3)
          .once()
          .then((DataSnapshot snapshot){
        snapshot.value.forEach((value){
          if(value!=null){
            type.add(value["name"].trim());
          }
        });
      });
    }




  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      type.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              value:_selectValue,
              items: type
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              )).toList(),
              onChanged: (value){
                setState(() {
                  _selectValue=value;
                  widget.selectValue.text=_selectValue;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}
