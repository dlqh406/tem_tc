import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => {
                  signIn()
                },
                child: Text('Register'),
              ),
              RaisedButton(
                onPressed: () => {
                  logIn()
                },
                child: Text('Login'),
              ),


            ],
          ),
        ),
      ),
    );
  }


  Future<FirebaseUser> signIn() async {
    try {
     await FirebaseAuth.instance.
      createUserWithEmailAndPassword(
          email: "barry@example.com",
          password: "S11231231"
      );
    } catch (e) {
      print(e.code);
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        print('최소 6자 이상의 패스워드를 입력하세요.');
      }
      if( e.code == 'ERROR_INVALID_EMAIL'){
        print('잘못된 이메일 형식입니다.');
      }
      else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        print('이미 등록되어있는 계정입니다.');
      }
    }

  }

  Future<FirebaseUser> logIn() async {
    try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "barry.allen@example.com",
          password: "SuperSecretPassword!"
      );
    } catch (e) {
      print(e.code);
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        print('등록되지 않은 계정입니다.');
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        print('잘못된 패스워드입니다.');
      }
    }
  }

}