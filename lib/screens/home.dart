import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/widgets/list.dart';
import 'package:workplace_opinion_app/widgets/showToDialog.dart';

class Home extends StatefulWidget{
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
   tabController=new TabController(length: 3,initialIndex: 0, vsync: this);
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
            Tab(text: "İşyerleri",icon: Icon(Icons.place),),
            Tab(text: "İş Yeri Atama",icon: Icon(Icons.assignment),),
            Tab(text:"İş Yeri Bulma",icon: Icon(Icons.find_in_page),),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child:new Text("Çıkış", style: new TextStyle(fontSize: 17.0,color: Colors.white), ),
              onPressed: (){
                print("Çıkış");
              }
          )
        ],
      ) ,
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          Listeleme(),
          Listeleme(),
          Listeleme(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print("Ekle");
          showToDialog(context);
        },
        tooltip: "Kayıt Ekle",
        child: Icon(Icons.add),
      ),
    );
  }

}
