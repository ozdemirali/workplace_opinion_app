import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/services/auth.dart';
import 'package:workplace_opinion_app/widgets/list.dart';
import 'package:workplace_opinion_app/widgets/showToDialog.dart';
import 'package:workplace_opinion_app/widgets/showToTab.dart';
import 'package:workplace_opinion_app/widgets/workplaceList.dart';

class Home extends StatefulWidget{
  Home({this.auth,this.userId,this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

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
   tabController=new TabController(length: 4,initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:new AppBar(
        title: Text("Ali ÖZDEMİR"),
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
          Listeleme(),
          Listeleme(),
          WorkplaceList(),
          Listeleme(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //print("Ekle");
          showToDialog(context);
        },
        tooltip: "Kayıt Ekle",
        child: Icon(Icons.add),
      ),
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

}
