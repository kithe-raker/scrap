import 'package:flutter/material.dart';

class ArrowBack extends StatefulWidget {
  @override
  _ArrowBackState createState() => _ArrowBackState();
}

class _ArrowBackState extends State<ArrowBack> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
        color: Colors.black,
        width: a.width,
        
        child: Column(children: <Widget>[
          Container(
              color: Colors.black,
              width: a.width,
              height: a.height / 6,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: a.width / 15,
                      right: a.width / 25,
                      left: a.width / 25,
                      bottom: a.width / 30.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              //back btn
                              child: Container(
                                width: a.width / 7,
                                height: a.width / 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
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
                          ],
                        ), //back btn
                      ])))
        ]));
  }
}
