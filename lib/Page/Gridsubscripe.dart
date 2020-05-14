import 'package:flutter/material.dart';
import 'package:scrap/Page/GridFollowing.dart';
import 'package:scrap/Page/GridTopScrap.dart';

class Gridsubscripe extends StatefulWidget {
  @override
  _GridsubscripeState createState() => _GridsubscripeState();
}

class _GridsubscripeState extends State<Gridsubscripe> {
  int page = 0;
  var controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                        style: page != 0
                            ? TextStyle(
                                color: Colors.white, fontSize: a.width / 20)
                            : TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 20,
                                fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        if (controller.page != 0)
                          controller.previousPage(
                              duration: Duration(milliseconds: 120),
                              curve: Curves.ease);
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
                        style: page != 1
                            ? TextStyle(
                                color: Colors.white, fontSize: a.width / 20)
                            : TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 20,
                                fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        if (controller.page != 1)
                          controller.nextPage(
                              duration: Duration(milliseconds: 120),
                              curve: Curves.ease);
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
              child: PageView(
                onPageChanged: (index) {
                  setState(() => page = index);
                },
                controller: controller,
                children: <Widget>[GridFollowing(), GridTopScrap()],
              ))
        ],
      ),
    );
  }
}
