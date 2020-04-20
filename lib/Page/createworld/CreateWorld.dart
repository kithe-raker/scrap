import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/world/worldFunction.dart';
import 'package:scrap/provider/createWorldProvider.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/widget/Loading.dart';

class CreateWorld extends StatefulWidget {
  @override
  _CreateWorldState createState() => _CreateWorldState();
}

class _CreateWorldState extends State<CreateWorld> {
  File image;
  String worldName, descript;
  var _key = GlobalKey<FormState>();
  bool loading = false;
  StreamSubscription loadStatus;

  sendCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  sendPic() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  @override
  void initState() {
    loadStatus =
        worldFunction.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final worldInfo = Provider.of<CreateWorldProvider>(context, listen: false);
    ScreenUtil.init(context,
        width: defaultScreenWidth,
        height: defaultScreenHeight,
        allowFontScaling: fontScaling);
    return Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: AppColors.black,
                    width: screenWidthDp,
                    height: screen.setHeight(130),
                    padding: EdgeInsets.only(
                      top: screen.setHeight(15),
                      right: screen.setWidth(20),
                      left: screen.setWidth(20),
                      bottom: screen.setHeight(15),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              width: screen.setWidth(100),
                              height: screen.setHeight(75),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp),
                                  color: AppColors.arrowBackBg),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.arrowBackIcon,
                                size: screen.setSp(48),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(
                                context,
                              );
                            },
                          ),
                        ]),
                  ),
                ],
              ),
              Form(
                key: _key,
                child: Container(
                  margin: EdgeInsets.only(
                    top: screen.setHeight(130),
                  ),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidthDp,
                        minHeight: screenHeightDp -
                            statusBarHeight -
                            screen.setHeight(130),
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              flex: 12,
                              child: Container(
                                width: screenWidthDp,
                                margin: EdgeInsets.only(
                                  right: screen.setWidth(70),
                                  left: screen.setWidth(70),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'เริ่มกันเลย!',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: screen.setSp(65),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'เพิ่มข้อมูลเพื่อให้ผู้คนรู้จักโลกของคุณ',
                                      style: TextStyle(
                                        height: 0.8,
                                        color: AppColors.white,
                                        fontSize: screen.setSp(40),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 70,
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: screen.setWidth(70),
                                  left: screen.setWidth(70),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: screenHeightDp / 40,
                                          bottom: screenHeightDp / 60),
                                      child: Center(
                                        child: Stack(
                                          children: <Widget>[
                                            InkWell(
                                              child: Container(
                                                height: screen.setWidth(300),
                                                width: screen.setWidth(300),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .imagePlaceholder,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidthDp),
                                                  border: Border.all(
                                                    color: AppColors
                                                        .imagePlaceholderBoder,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: image == null
                                                    ? SizedBox()
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(300),
                                                        child: Image.file(
                                                          image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                              ),
                                              onTap: () {
                                                selectImg(context);
                                              },
                                            ),
                                            Positioned(
                                              right: screen.setWidth(20),
                                              bottom: screen.setWidth(0),
                                              child: Container(
                                                height: screen.setWidth(56),
                                                width: screen.setWidth(56),
                                                decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          ScreenUtil
                                                              .screenWidthDp),
                                                ),
                                                child: Icon(
                                                  Icons.create,
                                                  color: AppColors.iconDark,
                                                  size: screen.setSp(38),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'ชื่อโลก',
                                      style: TextStyle(
                                        // height: 0.8,
                                        color: AppColors.textFieldLabel,
                                        fontSize: screen.setSp(40),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidthDp,
                                      height: screen.setHeight(110),
                                      margin: EdgeInsets.only(
                                          bottom: screenHeightDp / 60,
                                          top: screenHeightDp / 80),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            screenWidthDp),
                                        color: AppColors.textField,
                                      ),
                                      child: Center(
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.textFieldInput,
                                            fontSize: screen.setSp(40),
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'ชื่อโลกของคุณ',
                                            hintStyle: TextStyle(
                                              color: AppColors.hintText,
                                              fontSize: screen.setSp(40),
                                            ),
                                          ),
                                          validator: (val) {
                                            return val.trim() == ''
                                                ? 'กรุณาใส่ชื่อโลกของคุณ'
                                                : null;
                                          },
                                          onSaved: (val) =>
                                              worldInfo.worldName = val.trim(),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'คำอธิบายสั้น ๆ',
                                      style: TextStyle(
                                        // height: 0.8,
                                        color: AppColors.textFieldLabel,
                                        fontSize: screen.setSp(40),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidthDp,
                                      height: screen.setHeight(110),
                                      margin: EdgeInsets.only(
                                          bottom: screenHeightDp / 60,
                                          top: screenHeightDp / 80),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            screenWidthDp),
                                        color: AppColors.textField,
                                      ),
                                      child: Center(
                                        child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.textFieldInput,
                                            fontSize: screen.setSp(40),
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'เกี่ยวกับโลกของคุณ',
                                            hintStyle: TextStyle(
                                              color: AppColors.hintText,
                                              fontSize: screen.setSp(40),
                                            ),
                                          ),
                                          validator: (val) {
                                            return val.trim() == ''
                                                ? 'กรุณาใส่คำอธิบายโลกของคุณ'
                                                : null;
                                          },
                                          onSaved: (val) =>
                                              worldInfo.descript = val.trim(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 18,
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      width: screenWidthDp,
                                      height: screen.setHeight(110),
                                      margin: EdgeInsets.only(
                                        right: screen.setWidth(70),
                                        left: screen.setWidth(70),
                                      ),
                                      // margin:
                                      //     EdgeInsets.only(bottom: screenHeightDp / 40),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            screenWidthDp),
                                        color: AppColors.whiteButton,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'ต่อไป',
                                          style: TextStyle(
                                            color: AppColors.whiteButtonText,
                                            fontSize: screen.setSp(45),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      if (_key.currentState.validate()) {
                                        _key.currentState.save();
                                        worldInfo.image = image;
                                        worldFunction.toConfigWorld(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              loading ? Loading() : SizedBox()
            ],
          ),
        ));
  }

  selectImg(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        contentPadding: EdgeInsets.all(3),
        content: Container(
          height: scr.height / 3.8,
          width: scr.width / 1.1,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  "อัปโหลดรูปภาพ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  iconImg(
                    Icons.image,
                    () {
                      sendPic();
                      Navigator.pop(context);
                    },
                  ),
                  iconImg(Icons.camera_alt, () {
                    sendCam();
                    Navigator.pop(context);
                  })
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ยกเลิก',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget iconImg(IconData icon, Function func) {
    Size scr = MediaQuery.of(context).size;
    return Container(
      width: scr.width / 1.1 / 2.8,
      height: scr.height / 6.4,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(18)),
      child: IconButton(
          icon: Icon(
            icon,
            size: scr.width / 6,
            color: Colors.grey[800],
          ),
          onPressed: func),
    );
  }
}
