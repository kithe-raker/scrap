import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size a =MediaQuery.of(context).size;
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
                  fontSize: a.width/8,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(width: a.width/1.2,height: a.width/2,color: Colors.grey,)
          
        ],
      ),
    );
  }
}
