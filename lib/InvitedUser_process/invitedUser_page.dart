import 'package:flutter/material.dart';
import 'package:team_call/InvitedUser_process/login_page.dart';
import 'package:team_call/InvitedUser_process/signIn_page.dart';

class InvitedUserPage extends StatefulWidget {
  @override
  _InvitedUserPageState createState() => _InvitedUserPageState();
}

class _InvitedUserPageState extends State<InvitedUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("invitedUserPage") ,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          LoginPage()
                      ))
                  },
                child: Text('기존 회원입니다'),
              ),
              RaisedButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          SingInPage()
                      ))
                },
                child: Text('간단 회원가입'),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

