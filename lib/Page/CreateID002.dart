import 'package:flutter/material.dart';
import 'package:scrap/Page/HomePage.dart';

class CreateID002 extends StatefulWidget {
  @override
  _CreateID002State createState() => _CreateID002State();
}

class _CreateID002State extends State<CreateID002> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(a.width / 20),
        child: Container(
            width: a.width,
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: a.width / 7,
                  height: a.width / 10,
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(a.width),
                          color: Colors.white),
                      child: Icon(Icons.arrow_back,
                          color: Colors.black, size: a.width / 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                    width: a.width,
                    height: a.height / 1.12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "ใส่เลข 6 หลักจาก SMS",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: a.width / 15),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: a.width / 10, bottom: a.width / 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: a.width / 8,
                                  height: a.width / 8,
                                  color: Colors.white,
                                ),
                                Container(
                                  width: a.width / 8,
                                  height: a.width / 8,
                                  color: Colors.white,
                                ),
                                Container(
                                  width: a.width / 8,
                                  height: a.width / 8,
                                  color: Colors.white,
                                ),
                                Container(
                                  width: a.width / 8,
                                  height: a.width / 8,
                                  color: Colors.white,
                                ),
                                Container(
                                  width: a.width / 8,
                                  height: a.width / 8,
                                  color: Colors.white,
                                ),
                                Container(
                                  width: a.width / 8,
                                  height: a.width / 8,
                                  color: Colors.white,
                                )
                              ],
                            )),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: a.width/10),
                            width: a.width / 3,
                            height: a.width / 6,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(a.width)),
                            child: Text("ยืนยัน",style: TextStyle(fontSize: a.width/15),),
                          ),
                          onTap: (){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                          },
                        )
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
