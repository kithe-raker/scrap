import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/LitteringScrap.dart';
import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/streamWidget/StreamLoading.dart';
import 'package:stream_transform/stream_transform.dart';

class WriteScrap extends StatefulWidget {
  @override
  _WriteScrapState createState() => _WriteScrapState();
}

class _WriteScrapState extends State<WriteScrap> {
  bool private = false;
  int textureIndex = 0;
  var _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.grey[900],
              width: screenWidthDp,
              height: screenHeightDp,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: appBarHeight / 1.42,
                        width: screenWidthDp,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 21),
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(Icons.arrow_back,
                                  color: Color(0xfffa5a5a5), size: s60),
                              onTap: () => nav.pop(context),
                            ),
                            Text('เขียนสแครปของคุณ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: s46)),
                            GestureDetector(
                                child: Icon(Icons.color_lens,
                                    color: Color(0xfffa5a5a5), size: s60),
                                onTap: () {}),
                          ],
                        )),
                    SizedBox(height: screenHeightDp / 32),
                    Container(
                      width: screenWidthDp,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: screenWidthDp / 13,
                                  height: screenWidthDp / 13,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: Colors.transparent)),
                                  child: Checkbox(
                                    tristate: false,
                                    activeColor: Color(0xfff707070),
                                    value: private,
                                    onChanged: (bool value) {
                                      private = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "\t" + "ไม่ระบุตัวตน",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: screenWidthDp / 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //ออกจากหน้าปากระดาษ
                        ],
                      ),
                    ),
                    //กระดาษที่ไว้เขียนไงจ้ะ
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidthDp / 72),
                      width: screenWidthDp,
                      height: screenHeightDp / 1.8,
                      //ใช้สแต็กเอา
                      child: Stack(
                        children: <Widget>[
                          //รูปกระดาษ
                          Container(
                            child: SvgPicture.asset(
                              'assets/${texture.textures[textureIndex]}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(s10 / 5),
                            width: screenWidthDp / 1.04,
                            height: screenWidthDp / 1.04 * 1.115,
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            decoration: BoxDecoration(
                                // color: Colors.red,
                                // image: DecorationImage(
                                //     image: AssetImage(
                                //         'assets/${texture.textures[textureIndex]}'),
                                //     fit: BoxFit.cover)

                                ),
                            child: Form(
                              key: _key,
                              child: TextFormField(
                                maxLength: 250,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.35, fontSize: screenWidthDp / 14),
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(height: 0.0),
                                  counterText: "",
                                  counterStyle:
                                      TextStyle(color: Colors.transparent),
                                  border:
                                      InputBorder.none, //สำหรับให้เส้นใต้หาย
                                  hintText: 'เขียนบางอย่างที่คุณอยากบอก',
                                  hintStyle: TextStyle(
                                    fontSize: screenWidthDp / 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? toast.validateToast(
                                          "ลองเขียนข้อความบางอย่างสิ")
                                      : null;
                                },
                                onSaved: (val) {
                                  scrapData.text = val.trim();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenWidthDp / 42),
                      height: screenWidthDp / 7.5,
                    ),
                    // เลือกกระดาษ
                    // Container(
                    //     width: screenWidthDp,
                    //คตนจ      height: screenHeightDp / 8.1,
                    //     margin: EdgeInsets.only(top: screenWidthDp / 42),
                    //     child: ListView(
                    //       physics: AlwaysScrollableScrollPhysics(),
                    //       scrollDirection: Axis.horizontal,
                    //       children: texture.textures
                    //           .map((fileName) => paperBlock(fileName))
                    //           .toList(),
                    //     )),

                    //SizedBox(height: screenHeightDp / 64),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              width: screenWidthDp / 4.2,
                              height: screenWidthDp / 8,
                              alignment: Alignment.center,
                              child: Text(
                                'ปาใส่',
                                style: TextStyle(
                                    color: Color(0xff26A4FF),
                                    fontSize: screenWidthDp / 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              if (_key.currentState.validate()) {
                                _key.currentState.save();
                                scrapData.private = private;
                                scrapData.textureIndex = textureIndex;
                                searchPeopleDialog();
                              }
                            }),
                        SizedBox(width: appBarHeight / 2.8),
                        GestureDetector(
                            child: Container(
                              width: screenWidthDp / 4.2,
                              height: screenWidthDp / 8,
                              decoration: BoxDecoration(
                                  color: Color(0xff26A4FF),
                                  borderRadius: BorderRadius.circular(5)),
                              alignment: Alignment.center,
                              child: Text('โยนไว้',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidthDp / 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            onTap: () {
                              if (_key.currentState.validate()) {
                                _key.currentState.save();
                                scrapData.private = private;
                                scrapData.textureIndex = textureIndex;
                                nav.pushReplacement(context, LitteringScrap());
                              }
                            }),
                      ],
                    ),
                    // SizedBox(height: screenHeightDp / 32),
                  ],
                ),
              ),
            ),

            // แปะโฆษณา
            // Positioned(
            //     bottom: 0,
            //     child: Container(
            //       child: AdmobBanner(
            //           adUnitId: AdmobService().getBannerAdId(),
            //           adSize: AdmobBannerSize.FULL_BANNER),
            //     )),
            StreamLoading(stream: scrap.loading, blur: true)
          ],
        ),
      ),
    );
  }

  Widget paperBlock(String fileName) {
    var requiredAtt = texture.point[fileName];
    var fileIndex = texture.textures.indexOf(fileName);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    return userStream.att >= requiredAtt
        ? GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: screenWidthDp / 42),
              child: AspectRatio(
                  aspectRatio: 0.826,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset('assets/$fileName'),
                      ),
                      Container(
                          // height: screenWidthDp/6,
                          // width: screenWidthDp/6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            // image: DecorationImage(
                            //     image: AssetImage('assets/$fileName'),
                            //     fit: BoxFit.cover),
                          ),
                          child: fileIndex == textureIndex
                              ? Center(
                                  child: Container(
                                      padding:
                                          EdgeInsets.all(screenWidthDp / 81),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.72),
                                          borderRadius: BorderRadius.circular(
                                              screenWidthDp)),
                                      child: Icon(Icons.check,
                                          color: Colors.white, size: s38)),
                                )
                              : SizedBox()),
                    ],
                  )),
            ),
            onTap: () {
              scrapData.textureIndex = fileIndex;
              setState(() => textureIndex = fileIndex);
            },
          )
        : SizedBox();
  }

  searchPeopleDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => SearchPeopleDialog());
  }
}

class SearchPeopleDialog extends StatefulWidget {
  @override
  _SearchPeopleDialogState createState() => _SearchPeopleDialogState();
}

class _SearchPeopleDialogState extends State<SearchPeopleDialog> {
  var searching = false;
  var _controller = TextEditingController();
  var focus = FocusNode();
  StreamController<String> streamController = StreamController.broadcast();

  @override
  void dispose() {
    _controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: screenWidthDp,
          height: screenHeightDp,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                  child: Container(
                      color: Colors.white10,
                      width: screenWidthDp,
                      height: screenHeightDp),
                  onTap: () => nav.pop(context)),
              Center(
                child: Container(
                  height: screenHeightDp / 1.21,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            height: screenWidthDp / 8 / 1.2,
                            padding: EdgeInsets.all(screenWidthDp / 100),
                            margin: EdgeInsets.only(
                                left: screenWidthDp / 25,
                                right: screenWidthDp / 25,
                                top: screenWidthDp / 32),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                //color: Color(0xff262626),
                                color: Colors.black,
                                border: Border.all(color: Color(0xfff26A4FF))),
                            child: Stack(children: <Widget>[
                              TextField(
                                controller: _controller,
                                focusNode: focus,
                                style: TextStyle(
                                    color: Colors.white, fontSize: s42),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'ค้นหาผู้คน',
                                  contentPadding: EdgeInsets.all(4.8),
                                  hintStyle: TextStyle(
                                      color: Colors.white60, fontSize: s42),
                                  // fillColor: Colors.red,
                                ),
                                onTap: () {
                                  focus.requestFocus();
                                  setState(() => searching = true);
                                },
                                onChanged: (val) {
                                  var trim = val.trim();
                                  trim[0] == '@'
                                      ? streamController.add(trim.substring(1))
                                      : streamController.add(trim);
                                },
                              ),
                              searching
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.only(
                                          right: screenWidthDp / 46),
                                      child: GestureDetector(
                                          child: Icon(Icons.clear,
                                              color: Color(0xfff26A4FF),
                                              size: s42),
                                          onTap: () {
                                            focus.unfocus();
                                            _controller.clear();
                                            streamController.add(null);
                                            setState(() => searching = false);
                                          }),
                                    )
                                  : SizedBox(),
                            ])),
                        Expanded(
                          child: StreamBuilder(
                              stream: streamController.stream
                                  .debounce(Duration(milliseconds: 540)),
                              builder: (context, snapshot) {
                                return Subpeople(
                                    searchText: snapshot?.data,
                                    hasAppbar: false);
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
