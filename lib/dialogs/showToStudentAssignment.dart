import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workplace_opinion_app/models/dataWorkplace.dart';
import 'package:workplace_opinion_app/models/period.dart';
import 'package:workplace_opinion_app/models/user.dart';
import 'package:workplace_opinion_app/models/userWorkplace.dart';
import 'package:workplace_opinion_app/widgets/inputDigital.dart';
import 'package:workplace_opinion_app/widgets/inputText.dart';
import 'package:workplace_opinion_app/widgets/teacher.dart';



TextEditingController txtStudentName=new TextEditingController();
TextEditingController txtStudentPhone=new TextEditingController();
TextEditingController txtTeacherName=new TextEditingController();
TextEditingController txtTeacherUid=new TextEditingController();
var maskFormatter = new MaskTextInputFormatter(mask: '# (###) ### ## ##', filter: { "#": RegExp(r'[0-9]') });

final _formKey = GlobalKey<FormState>();

String selectWorkplace;
String selectWorkplaceName;
String selectWorkplaceType;
String selectTeacherName;
String selectTeacherUid;
String selectBranch;
String selectType;
String selectPeriod;
String selectYear;
String _key;

final FirebaseDatabase _database=FirebaseDatabase.instance;


showToStudentAssignment(BuildContext context,UserWorkplace data) async{
 //print(data.toJson());
  if(data!=null){
    _key=data.key;
    selectWorkplace=data.workplace;
    selectWorkplaceName=data.name;
    selectWorkplaceType=data.type;
    txtTeacherUid.text=data.user.uid;
    txtTeacherName.text=data.user.name;
    txtStudentName.text=data.student;
    txtStudentPhone.text=data.studentPhone;
    selectBranch=data.branch;
    selectType=data.type;
    selectPeriod=data.year;
  }
  else{
    _key=null;
    txtStudentName.text="";
    txtStudentPhone.text="";

  }



  await showDialog<String>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 5,right: 5),
          title: Center(
            child: Text("Stajer Atama"),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          content: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  //showToForm(_formKey),
                  Form(
                    key: _formKey,
                    child:Column(
                      children: <Widget>[
                        WorkplaceList(),
                        Teacher(database: _database,teacherUid: txtTeacherUid, teacherName: txtTeacherName,),
                        inputText(txtStudentName,"Öğrenin Adı"),
                        AcademicYear(),
                        Branch(),
                        inputDigital(txtStudentPhone, "0 (999) 999 99 99", "Öğrencinin Telefonu", maskFormatter),
                      ],
                    ) ,
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              alignment:Alignment.center,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new FlatButton(
                      child:const Text('İptal'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                      child:const Text('Kayıt'),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          add();
                          Navigator.pop(context);
                        }

                      }),
                ],
              ),
            ),
          ],
        );
      }
  );
}

class WorkplaceList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WorkplaceListState();
  }
}

class WorkplaceListState extends State<WorkplaceList>{
  List<DataWorkplace> workplace=new List();


  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("workplace")
        .once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      values.forEach((k,v) {
        workplace.add(DataWorkplace(k,v["name"],v["type"]));

      });
    });
  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      workplace.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //print("Widget ");
    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            //print(data);
            return DropdownButtonFormField<String>(
              hint: Text("İş Yeri Seçiniz"),
              value: selectWorkplace,
              items: workplace
                  .map((label) => DropdownMenuItem(
                child: Text(label.name),
                value: label.key,
              )).toList(),
              onChanged: (value){
                setState(() {
                  selectWorkplace=value;
                  //print(value);
                  workplace.forEach((f){
                    if(f.key==value){
                      selectWorkplaceName=f.name;
                      selectWorkplaceType=f.type;
                    }
                  });
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}

// class Teacher extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return TeacherState();
//   }
// }
//
// class TeacherState extends State<Teacher>{
//   List<User> teacher=new List();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //print("---name");
//     _database
//         .reference()
//         .child("user").orderByKey()
//         .once()
//         .then((DataSnapshot snapshot){
//       snapshot.value.forEach((value){
//         if(value!=null){
//           //print(value["name"]);
//           teacher.add(User(value["uid"], value["name"].trim()+" "+value["surname"].trim()));
//         }
//       });
//     });
//   }
//   Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds: 1),()=>
//       teacher.length.toString()
//   );
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return FutureBuilder<String>(
//       future: callAsyncFetch(),
//       builder: (context,AsyncSnapshot<String> snapshot){
//         if(snapshot.data!="0"){
//           //print(teacher);
//           return DropdownButtonFormField<String>(
//             hint: Text("Öğretmen Ata"),
//             value: selectTeacherUid,
//             items: teacher
//                 .map((label)=>DropdownMenuItem(
//               child: Text(label.name),
//               value: label.uid,
//             )).toList(),
//             onChanged: (value){
//               setState(() {
//                 teacher.forEach((f){
//                   if(f.uid==value){
//                     selectTeacherUid=f.uid;
//                     selectTeacherName=f.name;
//                   }
//                   //print(selectTeacherUid);
//                   //print(selectTeacherName);
//
//                 });
//               });
//             },
//           );
//         }else
//         {
//           //print(teacher);
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

class Branch extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BranchState();
  }
}

class BranchState extends State<Branch>{
  List<String> branch=new List();

  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("branch").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
      snapshot.value.forEach((value){
        if(value!=null){
          branch.add(value["name"].trim());
        }
      });
    });

  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      branch.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              hint: Text("Dalını seçiniz"),
              value: selectBranch,
              items: branch
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              )).toList(),
              onChanged: (value){
                setState(() {
                  selectBranch=value;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}

class AcademicYear extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AcademicYearState();
  }
}

class AcademicYearState extends State<AcademicYear>{
  List<Period> period=new List();

  @override
  void initState(){
    super.initState();
    _database
        .reference()
        .child("academic_year").orderByKey()
        .once()
        .then((DataSnapshot snapshot){
          snapshot.value.forEach((v){
            //print(v);
            if(v!=null) {
              period.add(Period(v["period"], v["year"]));
            }

          });
          //print(year.length);
      // Map<dynamic, dynamic> values=snapshot.value;
      // values.forEach((k,v) {
      //   year.add(Period(v["period"],v["year"]));
      //
      // });

    });

  }

  Future<String> callAsyncFetch()=>Future.delayed(Duration(seconds:1),()=>
      period.length.toString()
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder<String>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data!="0") {
            return DropdownButtonFormField<String>(
              hint: Text("Eğtim Öğretim Yılı"),
              value: selectPeriod,
              items: period
                  .map((label) => DropdownMenuItem(
                child: Text(label.period),
                value: label.period,
              )).toList(),
              onChanged: (value){
                setState(() {
                  period.forEach((f){
                    if(f.period==value){
                      selectPeriod=f.period;
                      selectYear=f.year;
                    }
                  });
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

}



add(){
  String uidYear;
  uidYear=selectTeacherUid+"_"+selectYear;
  UserWorkplace userWorkplace=new UserWorkplace(selectWorkplace, selectWorkplaceName,selectWorkplaceType,uidYear, selectPeriod, txtStudentName.text, selectBranch, txtStudentPhone.text,User(txtTeacherUid.text,txtTeacherName.text));

  if(_key==null){
    _database.reference().child("user_workplace").push().set(userWorkplace.toJson());
  }
  else{
    _database.reference().child("user_workplace").child(_key).set(userWorkplace.toJson());
  }

}