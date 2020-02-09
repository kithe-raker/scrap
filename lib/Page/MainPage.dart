import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'LoginPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: InkWell(
        child: Container(
          child: Center(
            child: Text(
              "SCRAP.",
              style: TextStyle(
                  fontFamily: 'Pecita',
                  color: Colors.white,
                  fontSize: a.width / 6,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
      ),
    );
  }
}
