import 'package:flutter/material.dart';
import 'package:scrap/Page/MyHomePage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewWorld extends StatefulWidget {
  @override
  _NewWorldState createState() => _NewWorldState();
}

class _NewWorldState extends State<NewWorld> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   actions: <Widget>[
      //     Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      //       Container(
      //           margin: EdgeInsets.only(
      //               top: MediaQuery.of(context).size.width / 90),
      //           height: MediaQuery.of(context).size.width / 7,
      //           alignment: Alignment.center,
      //           child: Image.asset(
      //             'assets/SCRAP.png',
      //             width: MediaQuery.of(context).size.width / 4,
      //           )),
      //     ])
      //   ],
      // ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: a.height,
              width: a.width,
              color: Color(0xff333333),
              child: Column(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // ส่วนของ แทบสีดำด้านบน
                          color: Colors.black,
                          width: a.width,
                          height: a.width / 5.5,
                          padding: EdgeInsets.only(
                            top: a.height / 50,
                            right: a.width / 20,
                            left: a.width / 20,
                            bottom: a.height / 50,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //Logo
                                Container(
                                    margin: EdgeInsets.only(top: a.width / 90),
                                    height: a.width / 7,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/SCRAP.png',
                                      width: a.width / 4,
                                    )),
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      // margin: EdgeInsets.only(bottom: a.width / 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(a.width),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 0.75,
                                          )),
                                      width: 35,
                                      height: 35,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(a.width),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://scontent.fbkk5-5.fna.fbcdn.net/v/t1.0-1/p960x960/66777281_1177291532477111_3471558186308206592_o.jpg?_nc_cat=104&_nc_sid=dbb9e7&_nc_eui2=AeHAbuIw7tZMnY7ZtXr7iFsEoRmpoiNy4xAywafQwN8bkyOawOgVHOQpGf7Weg9U6J-Odin7yj_iWimxyfYnytxil4U67EIjyEhAM0S5pO5mFg&_nc_ohc=6_RF5mMA4CwAX9CT48F&_nc_ht=scontent.fbkk5-5.fna&_nc_tp=6&oh=1aa114787db5b6a20d86343c47f1fe03&oe=5E9917E0',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: new Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: new BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(a.width),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 0.55,
                                            )),
                                        constraints: BoxConstraints(
                                          minWidth: 15.5,
                                          minHeight: 15.5,
                                        ),
                                        child: Center(
                                          child: new Text(
                                            '2',
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 60),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height /
                              9.5, // card height
                          child: PageView.builder(
                            itemCount: 3,
                            controller: PageController(viewportFraction: 0.5),
                            onPageChanged: (int index) =>
                                setState(() => _index = index),
                            itemBuilder: (context, i) {
                              return Transform.scale(
                                scale: i == _index ? 1 : 0.9,
                                child: InkWell(
                                  child: Card(
                                      color: i == _index
                                          ? Color(0xff101010)
                                          : Color(0xff2E2E2E),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: i == _index
                                                ? Color(0xff515151)
                                                : Color(0x00fff),
                                            width: 0.25,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(left: 8),
                                          child: Image.asset(
                                            'assets/paper-mini01.png',
                                            width: a.width / 9.5,
                                          ),
                                        ),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'โลกหลัก',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '{ SCRAP }',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              )
                                            ])
                                      ])
                                      // Center(
                                      //   child: Text(
                                      //     "Card ${i + 1}",
                                      //     style: TextStyle(
                                      //         fontSize: 32, color: Colors.white),
                                      //   ),
                                      // ),
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    // ส่วนของ แทบสีดำด้านบน
                    color: Color(0xff171717),
                    width: a.width,
                    height: a.width / 4,
                    // padding: EdgeInsets.only(
                    //   top: a.height / 50,
                    //   right: a.width / 20,
                    //   left: a.width / 20,
                    //   bottom: a.height / 50,
                    // ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                                width: a.width / 5,
                                child: Center(
                                  child: Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                    size: a.width / 12,
                                  ),
                                )),
                          ),
                          InkWell(
                            child: Container(
                                width: a.width / 5,
                                child: Center(
                                  child: Icon(
                                    Icons.language,
                                    color: Colors.grey[600],
                                    size: a.width / 12,
                                  ),
                                )),
                          ),
                          InkWell(
                            child: Container(
                                width: a.width / 5.5,
                                height: a.width / 5.5,
                                decoration: new BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius:
                                          20, // has the effect of softening the shadow
                                      spreadRadius:
                                          1, // has the effect of extending the shadow
                                      offset: Offset(
                                        0, // horizontal, move right 0
                                        10, // vertical, move down 10
                                      ),
                                    )
                                  ],
                                  color: Color(0xff171717),
                                  borderRadius: BorderRadius.circular(a.width),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/paper.png',
                                    width: a.width / 8,
                                  ),
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  ));
                            },
                          ),
                          InkWell(
                            child: Container(
                                width: a.width / 5,
                                child: Center(
                                  child: Icon(
                                    Icons.place,
                                    color: Colors.grey[600],
                                    size: a.width / 12,
                                  ),
                                )),
                          ),
                          InkWell(
                            child: Container(
                                width: a.width / 5,
                                child: Center(
                                  child: Icon(
                                    Icons.supervisor_account,
                                    color: Colors.grey[600],
                                    size: a.width / 12,
                                  ),
                                )),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
