import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/dialogs/showToNotification.dart';
import 'package:workplace_opinion_app/dialogs/showToStudentAssignment.dart';
import 'package:workplace_opinion_app/dialogs/showToWorkplace.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';
import 'package:workplace_opinion_app/models/workplace.dart';
import 'package:workplace_opinion_app/screens/studentPlacement.dart';
import 'package:workplace_opinion_app/screens/workplaceAppointed.dart';
import 'package:workplace_opinion_app/screens/workplaces.dart';
import 'package:workplace_opinion_app/services/auth.dart';

class Home extends StatefulWidget{
  Home({this.auth,this.user,this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final FirebaseUser user;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }

}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController tabController;


  @override
  void initState() {
    super.initState();
    tabController=new TabController(length: 4,initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //Get current year
    int month;
    int year;
    String uidYear;
    String period;
    month=DateTime.now().month;
    year=DateTime.now().year;

    if(month>=1 && month<=8){
      year=year-1;
    }
    uidYear=widget.user.uid+"_"+year.toString();
    period=year.toString()+"-"+(year+1).toString();
    print(period);

    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:new AppBar(
        title: Text(widget.user.displayName),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: "Atanan\nİşyerleri",icon: Icon(Icons.place),),
            Tab(text: "Stajer\nAtama",icon: Icon(Icons.account_box),),
            Tab(text: "Kayıtlı\nYerler", icon: Icon(Icons.assignment),),
            Tab(text:"İş Yeri\nBulma",icon: Icon(Icons.find_in_page),),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child:new Text("Çıkış", style: new TextStyle(fontSize: 17.0,color: Colors.white), ),
              onPressed: (){
                print("Çıkış");
                signOut();
              }
          )
        ],
      ) ,
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          WorkplaceAppointed(uidYear: uidYear,),
          StudentPlacement(year: period,),
          Workplaces(),
          Text("Yapılacak")
        ],
      ),
      floatingActionButton: new Visibility(
        visible:true,
        child: new FloatingActionButton(
          onPressed: (){
            selectShowDialog(tabController.index);
          },
          tooltip: 'Kayıt Ekle',
          child: new Icon(Icons.add),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     selectShowDialog(tabController.index);
      //   },
      //   tooltip: "Kayıt Ekle",
      //   child:Icon(Icons.add),
      // ),
    );
  }


  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      //print(e);
    }
  }

  selectShowDialog(int index){
    switch(index){
      case 0:
        //showToNotification(context);
        break;
      case 1:
        UserWorkplace userWorkplace;
        showToStudentAssignment(context, userWorkplace);
        break;
      case 2:
       Workplace _workplace;
       showToWorkplace(context,_workplace);
        break;
      case 3:
        print(index);
        print("3");
        break;

      default:

    }

  }
}
