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
import 'package:scrap/models/TopPlaceModel.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/dialog/WatchVideoDialog.dart';
import 'package:scrap/widget/showcontract.dart';
import 'package:scrap/widget/streamWidget/StreamLoading.dart';

import '../ShowTheme.dart';

class WriteScrap extends StatefulWidget {
  final Map data;
  final TopPlaceModel place;
  final String ref;
  final String thrownUid;
  final bool isThrow;
  final bool isThrowBack;
  final String region;
  final bool main;
  WriteScrap(
      {this.data,
      this.place,
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
  bool private = false;
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
                              color: Colors.white, size: s42),
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
                          Container(
                            height: screenWidthDp / 10.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                widget.isThrowBack
                                    ? SizedBox()
                                    : Row(
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
                                          Text("\t" + "ไม่ระบุตัวตน",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: s42))
                                        ],
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: (screenWidthDp -
                                              screenWidthDp / 1.04) /
                                          2),
                                  child: StreamBuilder<Object>(
                                      initialData: userStream.papers ?? 5,
                                      stream: userStream.paperSubject,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return floatButton(snapshot.data);
                                        } else
                                          return SizedBox();
                                      }),
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
                                    'assets/${texture.textures[scrapData.textureIndex] ?? 'paperscrap.svg'}',
                                    fit: BoxFit.cover),
                                Center(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
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
                                          hintText:
                                              'เขียนบางอย่างที่คุณอยากบอก',
                                          hintStyle: TextStyle(
                                              fontSize: s46,
                                              color: Colors.grey),
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
                                            borderRadius:
                                                BorderRadius.circular(5)),
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
                                                    builder: (BuildContext
                                                            context) =>
                                                        SearchPeopleDialog())
                                                : dialogcontract(context,
                                                    onPromise: () async {
                                                    await userinfo
                                                        .promiseUser();
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
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
                                          if (userStream.papers > 0) {
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
                                                widget.place != null
                                                    ? scrap.litter(context,
                                                        place: widget.place
                                                            .toPlaceModel())
                                                    : nav.pushReplacement(
                                                        context,
                                                        LitteringScrap());
                                              }
                                            }
                                          } else
                                            toast.toast('กระดาษของคุณหมดแล้ว');
                                        }))
                              ])
                        ]),
                  ),
                ),
              ],
            ),
            StreamLoading(stream: scrap.loading, blur: true)
          ],
        ),
      ),
    );
  }

  searchPeopleDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => SearchPeopleDialog());
  }

  Widget floatButton(int papers) {
    final user = Provider.of<UserData>(context, listen: false);
    return GestureDetector(
      child: Container(
          child: papers > 0
              ? RichText(
                  text: TextSpan(
                  style: TextStyle(
                      fontSize: screenWidthDp / 18,
                      color: Colors.white,
                      fontFamily: 'ThaiSans'),
                  children: <TextSpan>[
                    TextSpan(text: 'เหลือกระดาษ '),
                    TextSpan(
                        text: '$papers',
                        style: TextStyle(
                            fontSize: screenWidthDp / 16,
                            fontWeight: FontWeight.bold)),
                    TextSpan(text: ' แผ่น')
                  ],
                ))
              : Text(
                  'กระดาษของคุณหมดแล้ว',
                  style: TextStyle(
                      fontSize: screenWidthDp / 18,
                      color: Colors.white,
                      fontFamily: 'ThaiSans'),
                )),
      onTap: () {
        papers == 5
            ? toast.toast('กระดาษของคุณยังเต็มอยู่')
            : dialogvideo(context, user.uid);
      },
    );
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
