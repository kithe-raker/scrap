import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: a.width / 10),
      margin: EdgeInsets.only(top: a.width / 11.5),
      decoration: BoxDecoration(
          color: Color(0xff282828),
          borderRadius: BorderRadius.circular(a.width / 20)),
      width: a.width / 1.2,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: a.width / 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(a.width),
                border: Border.all(
                  color: Colors.white,
                  width: a.width / 150,
                )),
            width: a.width / 4,
            height: a.width / 4,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(a.width),
                child: Image.asset("assets/userprofile.png")
                // child: snapshot.data['img'] == null
                //                       ? Image.asset("assets/userprofile.png")
                //                       : CachedNetworkImage(
                //                           imageUrl: snapshot.data['img'],
                //                           fit: BoxFit.cover,
                //                         ),
                ),
          ),
          Text(
            "@natsatapon23",
            style: TextStyle(
              color: Colors.white,
              fontSize: a.width / 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Join 15/02/2020",
            style: TextStyle(color: Color(0xff26A4FF), fontSize: a.width / 18),
          ),
          Container(
            margin: EdgeInsets.only(
              top: a.width / 20,
              bottom: a.width / 12.5,
            ),
            width: a.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "“ยุบพรรคอนาคตใหม่แต่ยุบคนไทยไม่ได้หรอก ไอตู่หน้าโง่”",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: a.width / 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: a.width / 18,
              ),
            ),
          ),
          SizedBox(
            height: a.height / 20,
          ),
        ],
      ),
    );
  }
}
