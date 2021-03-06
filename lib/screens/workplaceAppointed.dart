import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/dialogs/showToNotification.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';

class WorkplaceAppointed extends StatefulWidget{
  WorkplaceAppointed({this.uidYear});
  final String uidYear;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WorkplaceAppointedState();
  }
}

class WorkplaceAppointedState extends State<WorkplaceAppointed> {
  List<UserWorkplace> _appointedWorkplaceList;
  Query _appointedQuery;


  final FirebaseDatabase _database=FirebaseDatabase.instance;

  StreamSubscription<Event> _onAppointedListAddedSubscription;
  StreamSubscription<Event> _onAppointedListChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appointedWorkplaceList=new List();
    _appointedQuery= _database.reference()
        .child("user_workplace")
        .orderByChild("uid_year").equalTo(widget.uidYear);

    _onAppointedListAddedSubscription=_appointedQuery.onChildAdded.listen(onEntryAdded);
    _onAppointedListChangedSubscription=_appointedQuery.onChildChanged.listen(onEntryChanged);

  }

  @override
  void dispose() {
    _onAppointedListAddedSubscription.cancel();
    _onAppointedListChangedSubscription.cancel();
    super.dispose();
  }

  onEntryAdded(Event event){
    setState(() {
      _appointedWorkplaceList.add(UserWorkplace.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event){
    var oldEntry=_appointedWorkplaceList.singleWhere((entry){
      return entry.key==event.snapshot.key;
    });
    setState(() {
      _appointedWorkplaceList[_appointedWorkplaceList.indexOf(oldEntry)]=
          UserWorkplace.fromSnapshot(event.snapshot);
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
              itemCount: _appointedWorkplaceList.length,
              itemBuilder:(BuildContext context,int position){
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _appointedWorkplaceList[position].type=="Alan D??????"?Colors.red:Colors.blue,
                      child: Text(""),
                    ),
                    title: Text(_appointedWorkplaceList[position].name),
                    subtitle: Text(_appointedWorkplaceList[position].student +" ("+_appointedWorkplaceList[position].branch +") "+_appointedWorkplaceList[position].studentPhone),
                    onTap: (){
                      //print("Se??ildi");
                      showToNotification(context,_appointedWorkplaceList[position]);
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }
}

