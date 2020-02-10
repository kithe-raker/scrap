import 'package:flutter/material.dart';

import 'HomePage.dart';

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
            child: Image.asset('./assets/SCRAP.png',width: a.width/2,)
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
