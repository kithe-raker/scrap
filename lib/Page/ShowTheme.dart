import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class ShowTheme extends StatefulWidget {
  @override
  _ShowThemeState createState() => _ShowThemeState();
}

class _ShowThemeState extends State<ShowTheme> {
  int textureIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Container(
          height: screenHeightDp,
          width: screenWidthDp,
          color: Colors.grey[900],
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: screenHeightDp,
                  width: screenWidthDp,
                  child: Column(
                    children: <Widget>[
                      //! ไว้เพิ่ม สี ฟอนต์
                      //color picker
                      // Container(
                      //   margin: EdgeInsets.only(top: screenWidthDp / 42),
                      //   padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 21),
                      //   width: screenWidthDp,
                      //   height: appBarHeight / 1.42,
                      //   child: Text('สี',
                      //       textAlign: TextAlign.start,
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: s46,
                      //           fontWeight: FontWeight.bold)),
                      // ),
                      // Container(
                      //     width: screenWidthDp,
                      //     height: screenWidthDp / 8,
                      //     // height: screenHeightDp / 8.1,
                      //     margin: EdgeInsets.only(
                      //         top: screenWidthDp / 42, bottom: screenWidthDp / 42),
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: screenWidthDp / 21),
                      //     child: ListView(
                      //       physics: AlwaysScrollableScrollPhysics(),
                      //       scrollDirection: Axis.horizontal,
                      //       children: <Widget>[
                      //         chooseColor(Colors.black),
                      //         chooseColor(Colors.white),
                      //         chooseColor(Colors.purple),
                      //         chooseColor(Colors.blue),
                      //         chooseColor(Colors.blueAccent),
                      //         chooseColor(Colors.green),
                      //         chooseColor(Colors.yellow),
                      //         chooseColor(Colors.orange),
                      //         chooseColor(Colors.red),
                      //       ],
                      //     )),
                      //paper picker
                      Container(
                          height: appBarHeight / 1.42,
                          width: screenWidthDp,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidthDp / 21),
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // SizedBox(),
                              Text('กระดาษ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: s46,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                      Expanded(
                          child: GridView.count(
                              mainAxisSpacing: screenWidthDp / 42,
                              crossAxisSpacing: screenWidthDp / 42,
                              crossAxisCount: 2,
                              padding: EdgeInsets.all(screenWidthDp / 21),
                              childAspectRatio: 0.8968,
                              //  physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              children: texture.texturesList
                                  .map((fileName) => paperBlock(fileName))
                                  .toList())),
                    ],
                  ),
                ),
                Positioned(
                  right: screenWidthDp / 21,
                  top: screenWidthDp / 42,
                  child: Container(
                    child: GestureDetector(
                        child: Icon(Icons.save,
                            color: Color(0xffff5f5f5), size: s60),
                        onTap: () {
                          Navigator.pop(context, textureIndex);
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseColor(Color colors) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: screenWidthDp / 45),
          decoration: BoxDecoration(
              color: colors,
              borderRadius: BorderRadius.all(Radius.circular(screenWidthDp))),
          height: screenWidthDp / 8,
          width: screenWidthDp / 8,
        ),
      ],
    );
  }

  Widget paperBlock(String fileName) {
    var requiredAtt = texture.point[fileName];
    var fileIndex = texture.texturesIndex[fileName];
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    return userStream.att >= requiredAtt
        ? GestureDetector(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    child:
                        SvgPicture.asset('assets/$fileName', fit: BoxFit.cover),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: fileIndex == scrapData.textureIndex
                          ? Center(
                              child: Container(
                                  padding: EdgeInsets.all(screenWidthDp / 81),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[800].withOpacity(0.72),
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp)),
                                  child: Icon(Icons.check,
                                      color: Colors.white, size: s38)),
                            )
                          : SizedBox()),
                ],
              ),
            ),
            onTap: () {
              scrapData.textureIndex = fileIndex;
              setState(() => textureIndex = fileIndex);
            },
          )
        : SizedBox();
  }
}
