import 'package:flutter/material.dart';

class AddPlayer extends StatefulWidget {
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: a.width,
        height: a.height,
        color: Colors.black,
        child: Column(children: <Widget>[
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
                                        color: Colors.black,
                                        size: a.width / 15),
                                  ),
                                  onTap: () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                ),
                              ],
                            ), 
        ],),
      ),
    );
  }
}
