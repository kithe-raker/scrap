import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: a.width / 8),
      margin: EdgeInsets.only(top: a.width / 10),
      decoration: BoxDecoration(
          color: Color(0xff434343),
          borderRadius: BorderRadius.circular(a.width / 20)),
      width: a.width / 1.2,
      height: a.width / 1,
      child: Column(
        children: <Widget>[
          CircleAvatar(backgroundColor: Colors.white, minRadius: a.width / 7),
          Text(
            "@natsatapon23",
            style: TextStyle(color: Colors.white, fontSize: a.width / 15),
          ),
          Text(
            "Join 15/02/2020",
            style: TextStyle(color: Color(0xff26A4FF), fontSize: a.width / 18),
          ),
          SizedBox(
            height: a.width / 5,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(a.width),
                border: Border.all(color: Colors.white)),
            width: a.width / 4,
            height: a.width / 10,
            alignment: Alignment.center,
            child: Text(
              "+ สหาย",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
