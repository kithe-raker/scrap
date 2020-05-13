import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/gridSubscirpe1.dart';
import 'package:scrap/Page/gridSubscripe2.dart';
import 'package:scrap/services/admob_service.dart';

class Gridsubscripe extends StatefulWidget {
  @override
  _GridsubscripeState createState() => _GridsubscripeState();
}

class _GridsubscripeState extends State<Gridsubscripe> {
  int page = 0;

  Widget pageBody(int selec) {
    switch (selec) {
      case 0:
        return GridSubscripe1();
        break;
      case 1:
        return GridSubscripe2();
        break;

      default:
        return GridSubscripe2();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: a.width,
            height: a.width / 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  child: Container(
                      width: a.width / 12,
                      child: Image.asset(
                        "assets/sss.png",
                        fit: BoxFit.contain,
                        width: a.width / 10,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Row(
                  children: [
                    InkWell(
                      child: Text(
                        "กำลังติดตาม",
                        style: page == 0 ? TextStyle(
                            color: Colors.white, fontSize: a.width / 20):TextStyle(
                            color: Colors.white, fontSize: a.width / 20,fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          page = 1;
                        });
                      },
                    ),
                    Text(
                      " | ",
                      style: TextStyle(
                          color: Colors.white, fontSize: a.width / 20),
                    ),
                    InkWell(
                      child: Text(
                        "สแครปยอดนิยม",
                        style: page == 1 ? TextStyle(
                            color: Colors.white, fontSize: a.width / 20):TextStyle(
                            color: Colors.white, fontSize: a.width / 20,fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          page = 0;
                        });
                      },
                    ),
                  ],
                ),
                Icon(Icons.history, color: Colors.white, size: a.width / 20)
              ],
            ),
          ),
          Container(
              width: a.width,
              height: a.height,
              padding: EdgeInsets.only(top: a.width / 5),
              child: pageBody(page))
        ],
      ),
    );
  }
}
