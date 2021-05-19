import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workplace_opinion_app/mixin/validation_mixin.dart';
import 'package:workplace_opinion_app/services/auth.dart';

class Login extends StatefulWidget{
  Login({this.auth,this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> with ValidationMixin{
  final formKey=new GlobalKey<FormState>();

  String email,password,errorMessage;
  bool isLoading;


  @override
  void initState() {
    errorMessage="";
    isLoading=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Staj Yerleri"),
      ),
      body: Stack(
        children: <Widget>[
          showForm(),
          showCircularProgress(),
        ],
      ),
    );
  }

  Widget showCircularProgress(){
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showForm(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            showLoginButton(),
            showLoginGoogleButton()
          ],
        ),
      ),
    );
  }
  
  Widget showLogo(){
    return new Hero(
        tag: "Logo",
        child: new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 48.0,
              child:Image.asset("images/opinion_2.png"),
            ),
        )
    );
  }

  Widget showEmailInput(){
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child:new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
            hintText: 'E-mail',
            icon: new Icon(
              Icons.mail,
              color:Colors.teal,
            ),
          ),
          validator: validateEmail,
          onSaved: (value){
            email=value.trim();
          },
        ),
    );
  }

  Widget showPasswordInput(){
    return new Padding(
      padding:const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Şifreniz',
          icon: new Icon(
            Icons.lock,
            color: Colors.teal,
          ),
        ),
        validator: validatePassword,
        onSaved: (value){
          password=value.trim();
        },
      ),
    );
  }

  Widget showLoginButton(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)
            ),
            color: Colors.teal,
            child: new Text("Giriş",
                style:new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: (){
              if(formKey.currentState.validate()){
                formKey.currentState.save();
                submit();
              }
              else{
                setState(() {
                  errorMessage="";
                });
              }

            }),
      ),
    );
  }

  Widget showLoginGoogleButton(){
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)
            ),
            color: Colors.teal,
            child: new Text("Sign in whit Google",
                style:new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: ()async{
              submitGoogle();
            }),
      ),
    );
  }

  Widget showErrorMessage(){
    if(errorMessage.length>0 && errorMessage!=null){
      return new Padding(
        padding:const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new Text(
          errorMessage,
          style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
              height: 1.0,
              fontWeight: FontWeight.bold),
        ),
      );
    }else{
      return new Container(
        height: 0.0,
      );
    }
  }


  void submit() async{
    setState(() {
      errorMessage = "";
      isLoading=true;
    });
    String userId="";
    FirebaseUser user;
    try{
      user = await widget.auth.signIn(email, password);

      setState(() {
        isLoading = false;
      });

      if (user != null) {
        widget.loginCallback();
      }
    }
    catch(e){
      //print("Error : $e");
      setState(() {
        isLoading = false;
        errorMessage=e.message;
        formKey.currentState.reset();
      });
    }
  }

  void submitGoogle() async{
    setState(() {
      errorMessage = "";
      isLoading=true;
    });
    FirebaseUser user;
    try{
      user=await widget.auth.signInGoogle();
      setState(() {
        isLoading = false;
      });

      if (user != null) {
        widget.loginCallback();
      }
    }
    catch(e){
      //print("Error : $e");
      setState(() {
        isLoading = false;
        errorMessage=e.message;
        formKey.currentState.reset();
      });
    }
  }
}