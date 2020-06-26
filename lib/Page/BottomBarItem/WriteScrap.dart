import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/LitteringScrap.dart';
import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';

class WriteScrap extends StatefulWidget {
  @override
  _WriteScrapState createState() => _WriteScrapState();
}

class _WriteScrapState extends State<WriteScrap>
    with AutomaticKeepAliveClientMixin {
  int textureIndex = 0;
  bool showtheme = false;
  final pageController = PageController();
  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context,
      {LatLng latLng,
      Map data,
      String ref,
      String thrownUID,
      bool isThrow = false,
      String region,
      bool isThrowBack = false}) {
    screenutilInit(context);
    var _key = GlobalKey<FormState>();

    bool private = false, loading = false;

    Size a = MediaQuery.of(context).size;
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    return StatefulBuilder(builder: (context, StateSetter setState) {
      scrap.loading.listen((value) => setState(() => loading = value));
      return Scaffold(
        backgroundColor: Colors.grey[900],
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                  child: Container(
                    width: a.width,
                    height: a.height,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              Container(
                  height: appBarHeight / 1.42,
                  width: screenWidthDp,
                  padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 21),
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: s52,
                        ),
                        onTap: () => nav.pop(context),
                      ),
                      Text('เขียนสแครปของคุณ',
                          style: TextStyle(color: Colors.white, fontSize: s46)),
                      GestureDetector(
                          child: Icon(Icons.color_lens,
                              color: Colors.white, size: s60),
                          onTap: () {
                            setState(() {
                              //showtheme = true;
                            });
                          }),
                    ],
                  )),
              Container(
                width: a.width,
                margin: EdgeInsets.only(
                    top: a.height / 8,
                    right: a.width / 60,
                    left: a.width / 60,
                    bottom: a.width / 8),
                child: ListView(
                  children: <Widget>[
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: a.height,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
                                isThrowBack
                                    ? SizedBox()
                                    : Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: a.width / 13,
                                              height: a.width / 13,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color:
                                                          Colors.transparent)),
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
                                                    fontSize: a.width / 20),
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
                            margin: EdgeInsets.only(
                                top: a.width / 150,
                                left: s10 / 2,
                                right: s10 / 2),
                            width: a.width / 1,
                            height: a.height / 1.8,
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
                                Positioned(
                                    child: Container(
                                  color: Colors.transparent,
                                  width: a.width,
                                  height: a.height,
                                  alignment: Alignment.center,
                                  child: Container(
                                    //color: Colors.red,
                                    padding: EdgeInsets.only(
                                      left: 25,
                                      right: 25,
                                    ),
                                    // width: a.width,
                                    child: Form(
                                      key: _key,
                                      child: TextFormField(
                                        maxLength: 250,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            height: 1.35,
                                            fontSize: a.width / 14),
                                        maxLines: null,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0.0),
                                          counterText: "",
                                          counterStyle: TextStyle(
                                              color: Colors.transparent),
                                          border: InputBorder
                                              .none, //สำหรับให้เส้นใต้หาย
                                          hintText:
                                              'เขียนบางอย่างที่คุณอยากบอก',
                                          hintStyle: TextStyle(
                                            fontSize: a.width / 18,
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
                                )),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: screenWidthDp / 21),
                                child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xfff333333),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: a.width / 4.2,
                                      height: a.width / 8,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                            color: Color(0xfffD8D8D8),
                                            fontSize: a.width / 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                              SizedBox(
                                width: appBarHeight / 2.8,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: screenWidthDp / 21),
                                child: GestureDetector(
                                    child: Container(
                                      width: a.width / 4.2,
                                      height: a.width / 8,
                                      decoration: BoxDecoration(
                                          color: isThrow
                                              ? Colors.white
                                              : Color(0xff26A4FF),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      alignment: Alignment.center,
                                      child: Text(
                                          isThrow
                                              ? "ปาใส่"
                                              : isThrowBack
                                                  ? 'ปากลับ'
                                                  : 'โยนไว้',
                                          style: TextStyle(
                                              color: isThrow
                                                  ? Color(0xff26A4FF)
                                                  : Colors.white,
                                              fontSize: a.width / 18,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    onTap: () {
                                      if (_key.currentState.validate()) {
                                        _key.currentState.save();
                                        scrapData.private = private;
                                        if (isThrow) {
                                          scrap.throwTo(context,
                                              data: data,
                                              thrownUID: thrownUID,
                                              collRef: ref);
                                        } else if (isThrowBack) {
                                          scrap.throwBack(context,
                                              thrownUID: thrownUID,
                                              region: region);
                                        } else {
                                          nav.pushReplacement(
                                              context, LitteringScrap());
                                        }
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              showtheme == true ? showTheme() : SizedBox(),
              loading ? Loading() : SizedBox()
            ],
          ),
        ),
      );
    });
    // *! ---------------
    //Scaffold(
    //   backgroundColor: Colors.black,
    //   body: SafeArea(
    //     child: Stack(
    //       children: <Widget>[
    //         Container(
    //           color: Colors.grey[900],
    //           width: screenWidthDp,
    //           height: screenHeightDp,
    //           child: SingleChildScrollView(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: <Widget>[
    //                 Container(
    //                     height: appBarHeight / 1.42,
    //                     width: screenWidthDp,
    //                     padding: EdgeInsets.symmetric(
    //                         horizontal: screenWidthDp / 21),
    //                     color: Colors.transparent,
    //                     alignment: Alignment.center,
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: <Widget>[
    //                         GestureDetector(
    //                           child: Icon(
    //                             Icons.arrow_back_ios,
    //                             color: Colors.white,
    //                             size: s52,
    //                           ),
    //                           onTap: () => nav.pop(context),
    //                         ),
    //                         Text('เขียนสแครปของคุณ',
    //                             style: TextStyle(
    //                                 color: Colors.white, fontSize: s46)),
    //                         GestureDetector(
    //                             child: Icon(Icons.color_lens,
    //                                 color: Colors.white, size: s60),
    //                             onTap: () {
    //                               setState(() {
    //                                 showtheme = !showtheme;
    //                               });
    //                             }),
    //                       ],
    //                     )),
    //                 SizedBox(height: screenHeightDp / 32),
    //                 Container(
    //                   width: screenWidthDp,
    //                   alignment: Alignment.center,
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: <Widget>[
    //                       //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
    //                       Container(
    //                         child: Row(
    //                           children: <Widget>[
    //                             Container(
    //                               width: screenWidthDp / 13,
    //                               height: screenWidthDp / 13,
    //                               decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(50),
    //                                   border: Border.all(
    //                                       color: Colors.transparent)),
    //                               child: Checkbox(
    //                                 tristate: false,
    //                                 activeColor: Color(0xfff707070),
    //                                 value: private,
    //                                 onChanged: (bool value) {
    //                                   private = value;
    //                                   setState(() {});
    //                                 },
    //                               ),
    //                             ),
    //                             Container(
    //                               child: Text(
    //                                 "\t" + "ไม่ระบุตัวตน",
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.bold,
    //                                     color: Colors.white,
    //                                     fontSize: screenWidthDp / 20),
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       //ออกจากหน้าปากระดาษ
    //                     ],
    //                   ),
    //                 ),
    //                 //กระดาษที่ไว้เขียนไงจ้ะ
    //                 Container(
    //                   margin:
    //                       EdgeInsets.symmetric(horizontal: screenWidthDp / 72),
    //                   width: screenWidthDp,
    //                   height: screenHeightDp / 1.8,
    //                   //ใช้สแต็กเอา
    //                   child: Stack(
    //                     children: <Widget>[
    //                       //รูปกระดาษ
    //                       Container(
    //                         child: SvgPicture.asset(
    //                           'assets/${texture.textures[textureIndex]}',
    //                           fit: BoxFit.cover,
    //                         ),
    //                       ),
    //                       Container(
    //                         alignment: Alignment.center,
    //                         margin: EdgeInsets.all(s10 / 5),
    //                         width: screenWidthDp / 1.04,
    //                         height: screenWidthDp / 1.04 * 1.115,
    //                         padding: EdgeInsets.symmetric(horizontal: 25),
    //                         decoration: BoxDecoration(
    //                             // color: Colors.red,
    //                             // image: DecorationImage(
    //                             //     image: AssetImage(
    //                             //         'assets/${texture.textures[textureIndex]}'),
    //                             //     fit: BoxFit.cover)

    //                             ),
    //                         child: Form(
    //                           key: _key,
    //                           child: TextFormField(
    //                             maxLength: 250,
    //                             textAlign: TextAlign.center,
    //                             style: TextStyle(
    //                                 height: 1.35, fontSize: screenWidthDp / 14),
    //                             maxLines: null,
    //                             keyboardType: TextInputType.text,
    //                             decoration: InputDecoration(
    //                               errorStyle: TextStyle(height: 0.0),
    //                               counterText: "",
    //                               counterStyle:
    //                                   TextStyle(color: Colors.transparent),
    //                               border:
    //                                   InputBorder.none, //สำหรับให้เส้นใต้หาย
    //                               hintText: 'เขียนบางอย่างที่คุณอยากบอก',
    //                               hintStyle: TextStyle(
    //                                 fontSize: screenWidthDp / 18,
    //                                 color: Colors.grey,
    //                               ),
    //                             ),
    //                             validator: (val) {
    //                               return val.trim() == ""
    //                                   ? toast.validateToast(
    //                                       "ลองเขียนข้อความบางอย่างสิ")
    //                                   : null;
    //                             },
    //                             onSaved: (val) {
    //                               scrapData.text = val.trim();
    //                             },
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Container(
    //                   margin: EdgeInsets.only(top: screenWidthDp / 42),
    //                   height: screenWidthDp / 7.5,
    //                 ),
    //                 // เลือกกระดาษ

    //                 // Container(
    //                 //     width: screenWidthDp,
    //                 //     height: screenHeightDp / 8.1,
    //                 //     margin: EdgeInsets.only(top: screenWidthDp / 42),
    //                 //     child: ListView(
    //                 //       physics: AlwaysScrollableScrollPhysics(),
    //                 //       scrollDirection: Axis.horizontal,
    //                 //       children: texture.textures
    //                 //           .map((fileName) => paperBlock(fileName))
    //                 //           .toList(),
    //                 //     )),

    //                 //SizedBox(height: screenHeightDp / 64),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     GestureDetector(
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                               color: Colors.white,
    //                               borderRadius: BorderRadius.circular(5)),
    //                           width: screenWidthDp / 4.2,
    //                           height: screenWidthDp / 8,
    //                           alignment: Alignment.center,
    //                           child: Text(
    //                             'ปาใส่',
    //                             style: TextStyle(
    //                                 color: Color(0xff26A4FF),
    //                                 fontSize: screenWidthDp / 18,
    //                                 fontWeight: FontWeight.bold),
    //                           ),
    //                         ),
    //                         onTap: () {
    //                           if (_key.currentState.validate()) {
    //                             _key.currentState.save();
    //                             scrapData.private = private;
    //                             scrapData.textureIndex = textureIndex;
    //                             searchPeopleDialog();
    //                           }
    //                         }),
    //                     SizedBox(width: appBarHeight / 2.8),
    //                     GestureDetector(
    //                         child: Container(
    //                           width: screenWidthDp / 4.2,
    //                           height: screenWidthDp / 8,
    //                           decoration: BoxDecoration(
    //                               color: Color(0xff26A4FF),
    //                               borderRadius: BorderRadius.circular(5)),
    //                           alignment: Alignment.center,
    //                           child: Text('โยนไว้',
    //                               style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: screenWidthDp / 18,
    //                                   fontWeight: FontWeight.bold)),
    //                         ),
    //                         onTap: () {
    //                           if (_key.currentState.validate()) {
    //                             _key.currentState.save();
    //                             scrapData.private = private;
    //                             scrapData.textureIndex = textureIndex;
    //                             nav.pushReplacement(context, LitteringScrap());
    //                           }
    //                         }),
    //                   ],
    //                 ),
    //                 // SizedBox(height: screenHeightDp / 32),
    //               ],
    //             ),
    //           ),
    //         ),
    //         showtheme == true ? showTheme() : SizedBox(),
    //         StreamLoading(stream: scrap.loading, blur: true)
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget showTheme() {
    return Container(
      height: screenHeightDp,
      width: screenWidthDp,
      color: Colors.grey[900],
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Column(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidthDp / 21),
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
                Container(
                    width: screenWidthDp,
                    height: screenWidthDp / 2.16 * 1.21,

                    // height: screenHeightDp / 8.1,
                    margin: EdgeInsets.only(
                        top: screenWidthDp / 42, bottom: screenWidthDp / 42),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidthDp / 21),
                    child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: texture.textures
                            .map((fileName) => paperBlock(fileName))
                            .toList())),
              ],
            ),
            Positioned(
              right: screenWidthDp / 21,
              top: screenWidthDp / 42,
              child: Container(
                child: GestureDetector(
                    child:
                        Icon(Icons.save, color: Color(0xffff5f5f5), size: s60),
                    onTap: () {
                      setState(() {
                        showtheme = !showtheme;
                      });
                    }),
              ),
            ),
          ],
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
    var fileIndex = texture.textures.indexOf(fileName);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    return userStream.att >= requiredAtt
        ? GestureDetector(
            child: Container(
              // width: screenWidthDp / 2.3,
              // height: screenWidthDp,
              height: screenWidthDp / 2.16 * 1.21,
              width: screenWidthDp / 2.16,
              margin: EdgeInsets.only(right: screenWidthDp / 42),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: SvgPicture.asset(
                      'assets/$fileName',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: fileIndex == textureIndex
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
  Timer timer;
  PublishSubject<String> searchController = PublishSubject<String>();

  _onSearchChanged() {
    if (timer?.isActive ?? false) timer.cancel();
    timer = Timer(const Duration(milliseconds: 540), () {
      var trim = _controller.text.trim();
      trim.length > 0 && trim[0] == '@'
          ? searchController.add(trim.substring(1))
          : searchController.add(trim);
    });
  }

  @override
  void initState() {
    _controller.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.removeListener(_onSearchChanged);
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
                  margin: EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
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
                                  }),
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
                                            searchController.add(null);
                                            setState(() => searching = false);
                                          }),
                                    )
                                  : SizedBox(),
                            ])),
                        Expanded(
                          child: StreamBuilder(
                              stream: searchController.stream,
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
