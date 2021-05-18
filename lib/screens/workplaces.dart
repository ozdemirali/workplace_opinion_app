import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/dialogs/showToWorkplace.dart';
import 'package:workplace_opinion_app/models/workplace.dart';

class Workplaces extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WorkplacesState();
  }
}

class WorkplacesState extends State<Workplaces>{

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

    var oldEntry=_workplaceList.singleWhere((entry){
      return entry.key==event.snapshot.key;
    });

    setState(() {
      _workplaceList.remove(oldEntry);
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    subtitle: Text(_workplaceList[position].authorizedPerson +" - "+_workplaceList[position].phone
                    ),
                    onTap: (){
                      print("Seçildi");
                      print(_workplaceList[position]);
                      showToWorkplace(context, _workplaceList[position]);
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

  /// Deletes the item of list  record at [key] from the Realtime Database.
  deleteWorkplace(String key) {
    _database.reference().child("workplace").child(key).remove().then((_){});
  }
}

