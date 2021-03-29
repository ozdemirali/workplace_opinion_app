
import 'package:flutter/material.dart';
final List<Tab> myTabs = <Tab>[
  Tab(text:"Left",),
  Tab(text: 'Right'),
];


Widget showToTab(){
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar:PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              tabs: myTabs,
              labelColor: Colors.black,
            ),
          ),
      ),


      body: TabBarView(
        children:  myTabs.map((Tab tab) {
          final String label = tab.text.toLowerCase();
          return Center(
            child: Text(
              'This is the $label tab',
              style: const TextStyle(fontSize: 36),
            ),
          );
        }).toList(),
      ),
    ),
  );
}