import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
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
            Container(
              child: Text(
                "About",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: a.width / 8,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
