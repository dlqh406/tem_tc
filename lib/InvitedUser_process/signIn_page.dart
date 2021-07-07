import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../phoneCertification.dart';

class SingInPage extends StatefulWidget {
  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  final myControllerEmail = TextEditingController();
  final myControllerPW1 = TextEditingController();
  final myControllerPW2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignIn Page") ,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        children: <Widget>[
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
    else{
      try {
        await FirebaseAuth.instance.
        createUserWithEmailAndPassword(
            email: myControllerEmail.text,
            password: myControllerPW1.text
        ).then((value) {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  PhoneCertification (value.user)
              ));

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
