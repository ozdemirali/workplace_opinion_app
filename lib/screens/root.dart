
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/services/auth.dart';

import 'home.dart';
import 'login.dart';

enum AuthStatus{
  Not_Logged_In,
  Logged_In,
}

class Root extends StatefulWidget{
  Root({this.auth});
  final BaseAuth auth;


  @override
  State<StatefulWidget> createState() {
    return RootState();
  }

}

class RootState extends State<Root>{
  AuthStatus authStatus=AuthStatus.Not_Logged_In;
  //String userId="";
  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getCurrentUser().then((_user){
      setState((){
       if(user!=null){
         user=_user;
       }
       authStatus=user==null?AuthStatus.Not_Logged_In:AuthStatus.Logged_In;
      });
    });
  }

  void loginCallback(){
    widget.auth.getCurrentUser().then((_user){
      setState(() {
        user=_user;
      });
    });
    setState(() {
      authStatus=AuthStatus.Logged_In;
    });
  }

  void logoutCallBack(){
    setState(() {
      authStatus=AuthStatus.Not_Logged_In;
      user=null;
    });
  }


  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.Not_Logged_In:
        return Login(
          auth:widget.auth,
          loginCallback:loginCallback,
        );
        break;
      case AuthStatus.Logged_In:
        if(user!=null){
          return Home(
            user: user,
            auth: widget.auth,
            logoutCallback: logoutCallBack,
          );
        }else{
          return Login(
            auth: widget.auth,
            loginCallback: loginCallback,
          );
        }
        break;
      default:
        return Login(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
    }
  }

}