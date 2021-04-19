
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/models/workplace.dart';

class WorkplaceList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WorkplaceListState();
  }
}

class WorkplaceListState extends State<WorkplaceList>{

  List<Workplace> _workplaceList;
  Query _workplaceQuery;

  final FirebaseDatabase _database=FirebaseDatabase.instance;

  StreamSubscription<Event> _onWorkplaceAddedSubscription;
  StreamSubscription<Event> _onWorkplaceChangedSubscription;
  StreamSubscription<Event> _onWorkplaceRemovedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _workplaceList=new List();

    _workplaceQuery=_database.reference().child("workplace");

    _onWorkplaceAddedSubscription=_workplaceQuery.onChildAdded.listen(onEntryAdded);
    _onWorkplaceChangedSubscription=_workplaceQuery.onChildChanged.listen(onEntryChanged);
    _onWorkplaceRemovedSubscription=_workplaceQuery.onChildRemoved.listen(onEntryRemoved);

  }

  @override
  void dispose(){
    _onWorkplaceAddedSubscription.cancel();
    _onWorkplaceChangedSubscription.cancel();
    _onWorkplaceRemovedSubscription.cancel();
    super.dispose();
  }


  onEntryAdded(Event event){
    setState(() {
      _workplaceList.add(Workplace.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event){
    var oldEntry=_workplaceList.singleWhere((entry){
      return entry.key==event.snapshot.key;
    });
    setState(() {
      _workplaceList[_workplaceList.indexOf(oldEntry)]=
          Workplace.fromSnapshot(event.snapshot);
    });
  }

  onEntryRemoved(Event event){
    //print("Silindi");
    //print(event.snapshot.key);

    var oldEntry=_workplaceList.singleWhere((entry){
      return entry.key==event.snapshot.key;
    });

    setState(() {
      //print(_jobList.length);
      _workplaceList.remove(oldEntry);
      // print(_jobList.length);
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //print(_workplaceList);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
          child:ListView.builder(
            shrinkWrap: true,
            itemCount: _workplaceList.length,
            itemBuilder: (BuildContext context,int position){
              return Dismissible(
                key: Key(_workplaceList[position].key),
                //background: Container(color:Colors.red),
                onDismissed: (direction) async{
                  //print("Dismission work");
                  deleteWorkplace(_workplaceList[position].key);
                },
                secondaryBackground: Container(
                  child: Center(
                    child: Text("Sil",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white),),
                  ),
                  color: Colors.red,
                ),
                background: Container(),
                child: Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _workplaceList[position].type=="Alan Dışı"?Colors.red:Colors.blue,
                      child: Text(""),
                    ),
                    title: Text(_workplaceList[position].name),
                    subtitle: Text(_workplaceList[position].authorizedPerson +" - " +"0 " + _workplaceList[position].phone.substring(1,4) + " " +
                        _workplaceList[position].phone.substring(4,7) + " " +_workplaceList[position].phone.substring(7,9)+ " " +_workplaceList[position].phone.substring(9,11)
                    ),
                    onTap: (){
                      print("Seçildi");
                    },
                  ),
                ),
              );
            },
          ) ,
        ),
      ],
    );
  }

  deleteWorkplace(String key) {
    _database.reference().child("workplace").child(key).remove().then((_){});
  }

}
