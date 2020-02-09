import 'package:flutter/material.dart';
import 'package:scrap/widget/CreatePaper.dart';

import 'Profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;

    return Material(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.black,
            width: a.width,
            height: a.width / 5,
            padding: EdgeInsets.only(
              right: a.width / 20,
              left: a.width / 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    height: a.width / 5,
                    alignment: Alignment.center,
                    child: Text("SCRAP.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: a.width / 15,
                        ))),
                Container(
                    height: a.width / 5,
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Container(
                        width: a.width / 10,
                        height: a.width / 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(a.width),
                          color: Colors.white,
                        ),
                        child: Icon(Icons.person,
                            color: Colors.black, size: a.width / 15),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                      },
                    ))
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: a.width / 10),
                alignment: Alignment.bottomCenter,
                width: a.width,
                height: a.height / 1.119,
                color: Colors.black,
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: a.width / 7,
                        height: a.width / 7,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 10.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                  0.0,
                                  3.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(a.width),
                            color: Colors.white),
                        child: Icon(
                          Icons.person_add,
                          color: Colors.black,
                          size: a.width / 15,
                        ),
                      ),
                      InkWell(
                        child: Container(
                          width: a.width / 4,
                          height: a.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              border: Border.all(color: Colors.white,width: a.width/500)),
                          child: Container(
                            margin: EdgeInsets.all(a.width / 35),
                            width: a.width / 5,
                            height: a.width / 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(a.width),
                                border: Border.all(color: Colors.white)),
                            child: Container(
                              margin: EdgeInsets.all(a.width / 35),
                              width: a.width / 5,
                              height: a.width / 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(a.width),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white)),
                              child: Icon(
                                Icons.create,
                                size: a.width / 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          dialog();
                        },
                      ),
                      Container(
                        width: a.width / 7,
                        height: a.width / 7,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 10.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                  0.0,
                                  3.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(a.width),
                            color: Colors.blueAccent),
                        child: Icon(
                          Icons.refresh,
                          color: Colors.black,
                          size: a.width / 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  dialog() {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(content:
              StatefulBuilder(builder: (context, StateSetter setState) {
            Size a = MediaQuery.of(context).size;
            return Container(
              width: a.width / 1.2,
              height: a.height / 1.5,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: a.width,
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Icon(
                            Icons.clear,
                            size: a.width / 10,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: a.width / 20),
                        width: a.width / 1.2,
                        height: a.width / 1.2,
                        child: CreatePaper(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: a.width / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                                width: a.width / 3.5,
                                height: a.width / 6.5,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.circular(a.width)),
                                alignment: Alignment.center,
                                child: Text(
                                  "ทิ้งไว้",
                                  style: TextStyle(fontSize: a.width / 15),
                                )),
                            InkWell(
                              child: Container(
                                width: a.width / 3.5,
                                height: a.width / 6.5,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.circular(a.width)),
                                alignment: Alignment.center,
                                child: Text("ปาใส่",
                                    style: TextStyle(fontSize: a.width / 15)),
                              ),
                              onTap: () {
                                dialog2();
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }));
        });
  }

  dialog2() {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(content:
              StatefulBuilder(builder: (context, StateSetter setState) {
            Size a = MediaQuery.of(context).size;
            return Container(
              width: a.width / 1.2,
              height: a.height / 1.2,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Icon(
                                Icons.arrow_back,
                                size: a.width / 10,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Icon(
                                Icons.clear,
                                size: a.width / 10,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: a.width / 20),
                        width: a.width / 1.2,
                        height: a.width / 1,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(a.width / 10)),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: a.width / 10),
                          child: InkWell(
                            child: Container(
                              width: a.width / 3.5,
                              height: a.width / 6.5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(a.width)),
                              alignment: Alignment.center,
                              child: Text("ปาใส่",
                                  style: TextStyle(fontSize: a.width / 15)),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            );
          }));
        });
  }
}
