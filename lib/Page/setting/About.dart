import 'package:flutter/material.dart';
import 'package:scrap/Page/setting/servicedoc.dart';
import 'package:scrap/Page/setting/sqUserdoc.dart';
import 'package:scrap/widget/Arrow_back.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  _launchURL() async {
    String url = 'https://www.instagram.com/scrap.app/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            width: a.width,
            height: a.height,
            color: Colors.black,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: a.width,
                      child: ArrowBack(),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: a.width / 15, top: a.height / 56),
                      width: a.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("เกี่ยวกับแอปพลิเคชัน",
                              style: TextStyle(
                                  color: Colors.white, fontSize: a.width / 8)),
                          Text("ข้อมูลทั่วไปของแอปพลิเคชัน",
                              style: TextStyle(
                                  color: Colors.white, fontSize: a.width / 20))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: a.width / 18,
                          left: a.width / 18,
                          top: a.width / 21,
                          bottom: a.width / 20),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              "assets/paperscrap.jpg",
                              width: a.width / 1.1,
                              height: a.height / 1.72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(a.width / 20),
                            height: a.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "เขียนโดย : ",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: a.width / 25),
                                        ),
                                        Text(
                                          "@scrapteam",
                                          style: TextStyle(
                                              color: Color(0xff26A4FF),
                                              fontSize: a.width / 25),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "เวลา : ",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: a.width / 25),
                                        ),
                                        Text(
                                          "00.00",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: a.width / 25),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: a.width / 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "เวอร์ชัน : ",
                                          style:
                                              TextStyle(fontSize: a.width / 20),
                                        ),
                                        Text(
                                          "1.1.0",
                                          style:
                                              TextStyle(fontSize: a.width / 20),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "ผู้พัฒนา : ",
                                          style:
                                              TextStyle(fontSize: a.width / 20),
                                        ),
                                        Text(
                                          "Bualoitech.co.th",
                                          style: TextStyle(
                                            color: Color(0xff26A4FF),
                                            fontSize: a.width / 20,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Instagram : ",
                                          style:
                                              TextStyle(fontSize: a.width / 20),
                                        ),
                                        InkWell(
                                          child: Text(
                                            "scrap.app",
                                            style: TextStyle(
                                              color: Color(0xff26A4FF),
                                              fontSize: a.width / 20,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          onTap: _launchURL,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                width: a.width / 1.1,
                                padding: EdgeInsets.all(a.width / 21),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("ข้อกำหนดการใช้บริการ",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: a.width / 20)),
                                              Icon(
                                                Icons.play_arrow,
                                                color: Colors.grey,
                                              )
                                            ]),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Servicedoc(),
                                            ));
                                      },
                                    ),
                                    InkWell(
                                      child: Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("นโยบายความเป็นส่วนตัว",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: a.width / 20,
                                                  )),
                                              Icon(
                                                Icons.play_arrow,
                                                color: Colors.grey,
                                              )
                                            ]),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SqUserdoc(),
                                            ));
                                      },
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
