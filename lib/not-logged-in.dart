import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_call/InvitedUser_process/loggedUser_page.dart';
import 'package:team_call/createHost_process/c_signIn_page.dart';

import 'InvitedUser_process/invitedUser_page.dart';


class NotLoggedIn extends StatefulWidget {
  @override
  _NotLoggedInState createState() => _NotLoggedInState();
}

class _NotLoggedInState extends State<NotLoggedIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:10.0),
            child: InkWell(
              child: new Container(
                  child: Row(
                    children: [
                      Text('로그아웃',style: TextStyle(fontSize: 17)),
                    ],
                  )
              ),
              onTap:  ()
              async {
                 await FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],

      ),
      body: StreamBuilder<FirebaseUser>(
          stream : FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => {
                      if(!snapshot.hasData){

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                InvitedUserPage()
                            ))
                      }
                      else{
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                LoggedUserIn(snapshot.data)
                            ))
                      }
                      
                    
                    },
                    child: Text('팀콜에 초대 되었습니다.'),
                  ),
                  RaisedButton(
                    onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              c_SingInPage()
                          ))
                    },
                    child: Text('회원 가입'),
                  ),

                  // RaisedButton(
                  //   onPressed: () => {
                  //     logIn()
                  //   },
                  //   child: Text('로그인'),
                  // ),


                ],
              ),
            ),
          );
        }
      ),
    );
  }


  Future<FirebaseUser> signIn() async {
    try {
     await FirebaseAuth.instance.
      createUserWithEmailAndPassword(
          email: "teamcall@teamcall.kr",
          password: "123123"
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
          email: "teamcall@teamcall.kr",
          password: "123123"
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