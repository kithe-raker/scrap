import 'package:flutter/material.dart';

class UserReport extends StatefulWidget {
  @override
  _UserReportState createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
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
                "UserReport",
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
