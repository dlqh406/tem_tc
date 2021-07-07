import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../phoneCertification.dart';
import 'c_phoneCertification.dart';

class c_SingInPage extends StatefulWidget {
  @override
  _c_SingInPageState createState() => _c_SingInPageState();
}

class _c_SingInPageState extends State<c_SingInPage> {
  final myControllerGroup = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerPW1 = TextEditingController();
  final myControllerPW2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("c_SignIn Page") ,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        children: <Widget>[
          new TextField(
            controller: myControllerGroup,
            decoration: new InputDecoration(
                hintText:  '조직명',
                hintStyle: TextStyle(color: Colors.grey),
                border: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                        color: Colors.blueAccent
                    )
                )
            ),
          ),
          new TextField(
            controller: myControllerEmail,
            decoration: new InputDecoration(
              hintText:  '이메일',
                hintStyle: TextStyle(color: Colors.grey),
                border: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                        color: Colors.blueAccent
                    )
                )
            ),
          ),

          new TextField(
            obscureText: true,
            controller: myControllerPW1,
            decoration: new InputDecoration(
                hintText:  '패스워드',
                hintStyle: TextStyle(color: Colors.grey),
                border: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                        color: Colors.blueAccent
                    )
                )
            ),
          ),
          new TextField(
            obscureText: true,
            controller: myControllerPW2,
            decoration: new InputDecoration(
                hintText:  '패스워드 확인',
                hintStyle: TextStyle(color: Colors.grey),
                border: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                        color: Colors.blueAccent
                    )
                )
            ),
          ),

          RaisedButton(
            onPressed: () => {
              signIn()
            },
            child: Text('회원가입'),
          ),


        ],
      ),
    );

  }
  Future<FirebaseUser> signIn() async {
    if(myControllerPW1.text != myControllerPW2.text ){
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          "패스워드가 일치하지 않습니다.",
        ),
      );

    }
    else if( myControllerEmail.text == ""){
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          "이메일을 입력하세요",
        ),
      );
    }
    else if( myControllerGroup.text == ""){
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          "조직명을 입력하세요",
        ),
      );
    }
    else{
      try {
        await FirebaseAuth.instance.
        createUserWithEmailAndPassword(
            email: myControllerEmail.text,
            password: myControllerPW1.text
        ).then((value0) {
          //myControllerGroup.text
          var data ={
            'name' : myControllerGroup.text
          };
          Firestore.instance
              .collection('main_data')
              .add(data).then((value1) {

            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    c_PhoneCertification (value0.user,value1.documentID,myControllerGroup.text)
                ));

          });



        });
      } catch (e) {
        print(e.code);
        if (e.code == 'ERROR_WEAK_PASSWORD') {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              "최소 6자 이상의 패스워드를 입력하세요.",
            ),
          );
        }
        else if( e.code == 'ERROR_INVALID_EMAIL'){
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              "잘못된 이메일 형식입니다.",
            ),
          );

        }
        else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              "이미 등록되어있는 계정입니다.",
            ),
          );

        }
        else{
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              e.code,
            ),
          );
        }
      }
    }


  }
}
