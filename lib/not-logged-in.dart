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
                      Text('๋ก๊ทธ์์',style: TextStyle(fontSize: 17)),
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
                    child: Text('ํ์ฝ์ ์ด๋ ๋์์ต๋๋ค.'),
                  ),
                  RaisedButton(
                    onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              c_SingInPage()
                          ))
                    },
                    child: Text('ํ์ ๊ฐ์'),
                  ),

                  // RaisedButton(
                  //   onPressed: () => {
                  //     logIn()
                  //   },
                  //   child: Text('๋ก๊ทธ์ธ'),
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
        print('์ต์ 6์ ์ด์์ ํจ์ค์๋๋ฅผ ์๋?ฅํ์ธ์.');
      }
      if( e.code == 'ERROR_INVALID_EMAIL'){
        print('์๋ชป๋ ์ด๋ฉ์ผ ํ์์๋๋ค.');
      }
      else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        print('์ด๋ฏธ ๋ฑ๋ก๋์ด์๋ ๊ณ์?์๋๋ค.');
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
        print('๋ฑ๋ก๋์ง ์์ ๊ณ์?์๋๋ค.');
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        print('์๋ชป๋ ํจ์ค์๋์๋๋ค.');
      }
    }

  }


}