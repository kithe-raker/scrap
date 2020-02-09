import 'package:flutter/material.dart';

import 'CreateID002.dart';

class CreateID extends StatefulWidget {
  @override
  _CreateIDState createState() => _CreateIDState();
}

class _CreateIDState extends State<CreateID> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(a.width / 20),
        child: Container(
          width: a.width,
          alignment: Alignment.topLeft,
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
                      "เบอร์โทรศัพท์",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: a.width / 15),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: a.width / 20, bottom: a.width / 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a.width / 40)),
                            width: a.width / 5,
                            height: a.width / 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a.width / 40)),
                            width: a.width / 2,
                            height: a.width / 8,
                          )
                        ],
                      ),
                    ),
                    Text(
                      "เราจะส่งเลข 6 หลัก เพื่อยืนยันเบอร์คุณ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: a.width / 30),
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(a.width / 10)),
                        width: a.width / 3,
                        height: a.width / 6,
                        margin: EdgeInsets.only(top: a.width / 5),
                        alignment: Alignment.center,
                        child: Text(
                          "ต่อไป",
                          style: TextStyle(
                              fontSize: a.width / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateID002()));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
