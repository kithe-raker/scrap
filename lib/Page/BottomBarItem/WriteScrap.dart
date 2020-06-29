import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/LitteringScrap.dart';
import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/showcontract.dart';
import 'package:scrap/widget/streamWidget/StreamLoading.dart';

import '../ShowTheme.dart';

class WriteScrap extends StatefulWidget {
  final Map data;
  final String ref;
  final String thrownUid;
  final bool isThrow;
  final bool isThrowBack;
  final String region;
  final bool main;
  WriteScrap(
      {this.data,
      this.isThrow = false,
      this.isThrowBack = false,
      this.ref,
      this.region,
      this.thrownUid,
      this.main = false});
  @override
  _WriteScrapState createState() => _WriteScrapState();
}

class _WriteScrapState extends State<WriteScrap> {
  int textureIndex = 0;
  var _key = GlobalKey<FormState>();
  bool private = false, showtheme = false;
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowTheme()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    print(result);
    setState(() {});

    print(textureIndex);
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    final user = Provider.of<UserData>(context, listen: false);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    height: appBarHeight / 1.42,
                    width: screenWidthDp,
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: s52),
                          onTap: () => nav.pop(context),
                        ),
                        Text('เขียนสแครปของคุณ',
                            style:
                                TextStyle(color: Colors.white, fontSize: s46)),
                        Container(
                          margin: EdgeInsets.only(right: screenWidthDp / 72),
                          child: GestureDetector(
                              // child: Icon(Icons.color_lens,
                              //     color: Colors.white, size: s60),
                              child: Container(
                                height: screenWidthDp / 15,
                                width: screenWidthDp / 15,
                                child: SvgPicture.asset(
                                    'assets/paperchange.svg',
                                    color: Colors.white,
                                    fit: BoxFit.contain),
                              ),
                              onTap: () async {
                                _navigateAndDisplaySelection(context);
                              }),
                        ),
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: screenHeightDp / 24),
                        widget.isThrowBack
                            ? SizedBox(height: screenWidthDp / 13)
                            : Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: <Widget>[
                                    SizedBox(
                                      height: screenWidthDp / 13,
                                      width: screenWidthDp / 13,
                                      child: Checkbox(
                                          tristate: false,
                                          activeColor: Color(0xfff707070),
                                          value: private,
                                          onChanged: (bool value) {
                                            private = value;
                                            setState(() {});
                                          }),
                                    ),
                                    Text(
                                      "\t" + "ไม่ระบุตัวตน",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: s42),
                                    )
                                  ],
                                ),
                              ),
                        SizedBox(height: 5.4),
                        Container(
                          width: screenWidthDp / 1.04,
                          height: screenWidthDp / 1.04 * 1.115,
                          child: Stack(
                            children: <Widget>[
                              SvgPicture.asset(
                                  'assets/${texture.textures[scrapData.textureIndex]}',
                                  fit: BoxFit.cover),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Form(
                                    key: _key,
                                    child: TextFormField(
                                      maxLength: 250,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 1.35, fontSize: s54),
                                      maxLines: null,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(height: 0.0),
                                        counterText: "",
                                        counterStyle: TextStyle(
                                            color: Colors.transparent),
                                        border: InputBorder
                                            .none, //สำหรับให้เส้นใต้หาย
                                        hintText: 'เขียนบางอย่างที่คุณอยากบอก',
                                        hintStyle: TextStyle(
                                          fontSize: s46,
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
                              ),
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
                                        color: widget.main
                                            ? Colors.white
                                            : Color(0xfff333333),
                                        borderRadius: BorderRadius.circular(5)),
                                    width: screenWidthDp / 4.2,
                                    height: screenWidthDp / 8,
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.main ? 'ปาใส่' : 'ยกเลิก',
                                      style: TextStyle(
                                          color: widget.main
                                              ? Color(0xff26A4FF)
                                              : Color(0xfffD8D8D8),
                                          fontSize: s46,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  onTap: () {
                                    if (widget.main) {
                                      if (_key.currentState.validate()) {
                                        _key.currentState.save();
                                        scrapData.private = private;
                                        user.promise
                                            ? showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        SearchPeopleDialog())
                                            : dialogcontract(context,
                                                onPromise: () async {
                                                await userinfo.promiseUser();
                                                user.promise = true;
                                                nav.pop(context);
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        SearchPeopleDialog());
                                              });
                                      }
                                    } else
                                      nav.pop(context);
                                  }),
                            ),
                            SizedBox(width: appBarHeight / 2.8),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenWidthDp / 21),
                              child: GestureDetector(
                                  child: Container(
                                    width: screenWidthDp / 4.2,
                                    height: screenWidthDp / 8,
                                    decoration: BoxDecoration(
                                        color: widget.isThrow
                                            ? Colors.white
                                            : Color(0xff26A4FF),
                                        borderRadius: BorderRadius.circular(5)),
                                    alignment: Alignment.center,
                                    child: Text(
                                        widget.isThrow
                                            ? "ปาใส่"
                                            : widget.isThrowBack
                                                ? 'ปากลับ'
                                                : 'โยนไว้',
                                        style: TextStyle(
                                            color: widget.isThrow
                                                ? Color(0xff26A4FF)
                                                : Colors.white,
                                            fontSize: s46,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  onTap: () {
                                    if (_key.currentState.validate()) {
                                      _key.currentState.save();
                                      scrapData.private = private;
                                      if (widget.isThrow) {
                                        scrap.throwTo(context,
                                            data: widget.data,
                                            thrownUID: widget.thrownUid,
                                            collRef: widget.ref);
                                      } else if (widget.isThrowBack) {
                                        scrap.throwBack(context,
                                            thrownUID: widget.thrownUid,
                                            region: widget.region);
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
                ),
              ],
            ),
            showtheme == true ? showTheme() : SizedBox(),
            StreamLoading(stream: scrap.loading, blur: true)
          ],
        ),
      ),
    );
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
    timer?.cancel();
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
