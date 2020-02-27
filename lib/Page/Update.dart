import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Update extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  _launchURL() async {
    String url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.bualoitech.scrap'
        : 'https://apps.apple.com/th/app/scrap/id1498592211?l=th';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'เวอร์ชั่นใหม่มาแล้ว',
                style: TextStyle(
                    fontSize: a.width / 6.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
              Text(
                'เวอร์ชั่นใหม่มาแล้ว!\nแตะปุ่มด้านล่างเพื่ออัปเดทแอปของท่าน',
                style: TextStyle(
                    fontSize: a.width / 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: a.height / 10),
              InkWell(
                borderRadius: BorderRadius.circular(a.width),
                child: Container(
                  width: a.width / 3.5,
                  height: a.width / 6.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(a.width)),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.favorite,
                    color: Color(0xff26A4FF),
                  ),
                ),
                onTap: _launchURL,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
