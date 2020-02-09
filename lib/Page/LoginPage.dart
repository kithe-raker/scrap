import 'package:flutter/material.dart';
import 'package:scrap/Page/CreateID.dart';
import 'package:scrap/Page/HomePage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(
              "SIGN IN",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: a.width / 8,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: a.width / 10),
            width: a.width / 1.15,
            height: a.width / 1,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(a.width / 20)),
            child: Column(
              children: <Widget>[
                Container(
                    width: a.width,
                    padding: EdgeInsets.only(
                        top: a.width / 20,
                        left: a.width / 20,
                        bottom: a.width / 80),
                    child: Text(
                      "ID name",
                      style: TextStyle(
                          color: Colors.white, fontSize: a.width / 25),
                    )),
                Container(
                  width: a.width / 1.3,
                  height: a.width / 6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(a.width)),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ID name',
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                    width: a.width,
                    padding: EdgeInsets.only(
                        top: a.width / 20,
                        left: a.width / 20,
                        bottom: a.width / 80),
                    child: Text(
                      "password",
                      style: TextStyle(
                          color: Colors.white, fontSize: a.width / 25),
                    )),
                Container(
                  width: a.width / 1.3,
                  height: a.width / 6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(a.width)),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'password',
                        
                        ),
                  ),
                ),
                InkWell(
                    child: Container(
                        width: a.width / 1.3,
                        height: a.width / 6,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: a.width / 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(a.width / 40)),
                        child: Text(
                          "เข้าสู่ระบบ",
                          style: TextStyle(fontSize: a.width / 20),
                        )),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }),
                Container(
                  margin: EdgeInsets.only(top: a.width / 20),
                  child: Text("ลืมรหัสผ่าน",
                      style: TextStyle(
                          fontSize: a.width / 25, color: Colors.white)),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: a.width / 8),
            child: InkWell(
              child: Text(
                "สร้างบัญชี SCRAP.",
                style: TextStyle(color: Colors.white, fontSize: a.width / 20),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateID()));
              },
            ),
          )
        ],
      ),
    );
  }
}
