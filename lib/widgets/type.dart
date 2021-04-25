import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Type extends StatefulWidget{
  final String selectType;
  Type({this.selectType});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print(selectType);
    return TypeState();
  }
}

class TypeState extends State<Type>{
  List<String> type=new List();
  final FirebaseDatabase _database=FirebaseDatabase.instance;
  @override
  void initState(){
    super.initState();
    _database
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

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      type.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("-----");
     print(widget.selectType);
    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              value: widget.selectType,
              items: type
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              )).toList(),
              onChanged: (value){
                setState(() {
                  //widget.select=value;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}