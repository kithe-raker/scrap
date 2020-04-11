import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrap/Page/authenPage/SubmitPhone.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/widget/Loading.dart';

class LoginOtherMethod extends StatefulWidget {
  @override
  _LoginOtherMethodState createState() => _LoginOtherMethodState();
}

class _LoginOtherMethodState extends State<LoginOtherMethod> {
  String phone;
  bool loading = false;
  StreamSubscription loadStatus;

  @override
  void initState() {
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: a.width / 20),
                      child: InkWell(
                        child: Container(
                          width: a.width / 7,
                          height: a.width / 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              color: Colors.white),
                          child: Icon(Icons.arrow_back,
                              color: Colors.black, size: a.width / 15),
                        ),
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: a.width / 6),
                          child: Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 9,
                                fontFamily: 'ThaiSans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            "\"ผู้คนกำลังรออ่านกระดาษของคุณ\"",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: a.width / 18,
                              fontFamily: 'ThaiSans',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: a.width / 30),
                          child: InkWell(
                            child: Container(
                                width: a.width / 1.3,
                                height: a.width / 6.5,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: a.width / 22, bottom: a.width / 35),
                                decoration: BoxDecoration(
                                    color: Color(0xff26A4FF),
                                    borderRadius:
                                        BorderRadius.circular(a.width / 2)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.phone,
                                        color: Colors.white,
                                        size: a.width / 20),
                                    SizedBox(width: 5.0),
                                    Text("เข้าสู่ระบบด้วยเบอร์โทร",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 18,
                                            fontWeight: FontWeight.bold))
                                  ],
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubmitPhone(login: true)));
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: a.height / 12),
                          width: a.width / 1.1,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white70, width: 2))),
                        ),
                        SizedBox(height: a.height / 12),
                        Container(
                          width: a.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              logoApp(a,
                                  'https://icons.iconarchive.com/icons/danleech/simple/256/facebook-icon.png',
                                  function: () {
                                authService.authenWithFacebook(context);
                              }),
                              logoApp(a,
                                  'https://image.flaticon.com/teams/slug/google.jpg',
                                  function: () {
                                authService.authenWithGoogle(context);
                              }),
                              logoApp(a,
                                  'https://cdn2.iconfinder.com/data/icons/minimalism/512/twitter.png',
                                  function: () {
                                authService.authenWithTwitter(context);
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading ? Loading() : SizedBox()
        ]));
  }

  Widget logoApp(Size a, String src, {@required Function function}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(a.width), color: Colors.white),
      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(a.width),
          child: Image.network(src,
              width: a.width / 5.6, height: a.width / 5.6, fit: BoxFit.cover),
        ),
        onTap: function,
      ),
    );
  }
}
