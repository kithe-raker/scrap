import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authentication/not_registered/CreateProfile2.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/widget/AppBar.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/warning.dart';

class CreateProfile1 extends StatefulWidget {
  @override
  _CreateProfile1State createState() => _CreateProfile1State();
}

class _CreateProfile1State extends State<CreateProfile1> {
  final nav = Nav();
  var _key = GlobalKey<FormState>();
  String pName;
  dynamic image;
  bool loading = false;
  var user;
  StreamSubscription loadStatus;
  var nameController = TextEditingController();
  var _pennameField = TextEditingController();

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

  initUserInfo() async {
    user = await fireAuth.currentUser();
    nameController.text = user?.displayName ?? null;
    image = user?.photoUrl ?? null;
    loading = false;
    setState(() {});
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
  }

  validator() async {
    authService.load.add(true);
    if (image != null || user?.photoUrl != null) {
      var docs = await authService.getDocuments('pName', pName);
      var data = docs.documents[0];
      docs.documents.length < 1 || data.documentID == user.uid
          ? register()
          : authService.warn('นามนี้ได้ทำการลงทะเบียนไว้แล้ว', context);
    } else
      authService.warn('กรุณาเลือกรูปโปรไฟล์ของท่าน', context);
  }

  register() async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    authenInfo.img = image;
    authenInfo.pName = pName;
    await fireStore
        .collection('Account')
        .document(user.uid)
        .setData({'pName': pName}, merge: true);
    nav.push(context, CreateProfile2());
    authService.load.add(false);
  }

  @override
  void initState() {
    initUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    nameController.dispose();
    _pennameField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: fontScaling,
    );
    return Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              AppBarWithArrow(),
              Container(
                margin: EdgeInsets.only(
                  top: appBarHeight,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidthDp,
                      minHeight:
                          screenHeightDp - statusBarHeight - appBarHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            flex: 15,
                            child: Container(
                              width: screenWidthDp,
                              margin: EdgeInsets.only(
                                left: 70.w,
                                right: 70.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'เกือบเสร็จแล้ว!',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: s65,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'เพิ่มข้อมูลของคุณเพื่อให้ผู้คนค้นหาคุณเจอ',
                                    style: TextStyle(
                                      height: 0.8,
                                      color: AppColors.white,
                                      fontSize: s40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 40,
                            child: Container(
                              width: screenWidthDp,
                              margin: EdgeInsets.only(
                                left: 70.w,
                                right: 70.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: screenHeightDp / 40,
                                        bottom: screenHeightDp / 40),
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Container(
                                              height: 300.w,
                                              width: 300.w,
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.imagePlaceholder,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidthDp),
                                                border: Border.all(
                                                  color: AppColors
                                                      .imagePlaceholderBoder,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                  child: image == null
                                                      ? Image.network(
                                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                                          fit: BoxFit.cover)
                                                      : image.runtimeType ==
                                                              String
                                                          ? Image.network(
                                                              user.photoUrl,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              image,
                                                              fit: BoxFit.cover,
                                                            ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    300,
                                                  )),
                                            ),
                                            onTap: () {
                                              selectImg(context);
                                            },
                                          ),
                                          Positioned(
                                            right: 20.w,
                                            bottom: 0,
                                            child: Container(
                                              height: 55.w,
                                              width: 55.w,
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidthDp),
                                              ),
                                              child: Icon(
                                                Icons.create,
                                                color: AppColors.iconDark,
                                                size: s34,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: Container(
                              width: screenWidthDp,
                              margin: EdgeInsets.only(
                                left: 70.w,
                                right: 70.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'นามปากกา',
                                          style: TextStyle(
                                            fontFamily: 'ThaiSans',
                                            color: AppColors.white,
                                            fontSize: s40,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' (ผู้คนจะรู้จักคุณในชื่อนี้)',
                                          style: TextStyle(
                                            fontFamily: 'ThaiSans',
                                            color: AppColors.white38,
                                            fontSize: s38,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Form(
                                    key: _key,
                                    child: Container(
                                      width: screenWidthDp,
                                      height: textFieldHeight,
                                      margin: EdgeInsets.only(
                                        bottom: screenHeightDp / 60,
                                        top: screenHeightDp / 80,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            screenWidthDp),
                                        color: AppColors.textField,
                                      ),
                                      child: Center(
                                        child: TextFormField(
                                          controller: _pennameField,
                                          textInputAction: TextInputAction.done,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: s40,
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            counterStyle:
                                                TextStyle(fontSize: 0),
                                            errorStyle: TextStyle(
                                                fontSize: 0, height: 0),
                                            border: InputBorder.none,
                                            hintText: '@penname',
                                            hintStyle: TextStyle(
                                              color: AppColors.white30,
                                              fontSize: s40,
                                            ),
                                          ),
                                          validator: ((val) {
                                            return val.trim() == ''
                                                ? alert(
                                                    infoTitle,
                                                    "กรุณากรอกนามปากกาของคุณ",
                                                    context)
                                                : null;
                                          }),
                                          onSaved: (name) =>
                                              pName = name.trim(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 25,
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    height: textFieldHeight,
                                    width: screenWidthDp,
                                    margin: EdgeInsets.only(
                                      left: 70.w,
                                      right: 70.w,
                                    ),
                                    // margin:
                                    //     EdgeInsets.only(bottom: screenHeightDp / 40),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
                                      color: AppColors.blueButton,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ต่อไป',
                                        style: TextStyle(
                                          color: AppColors.blueButtonText,
                                          fontSize: ScreenUtil().setSp(45),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (_key.currentState.validate()) {
                                      _key.currentState.save();
                                      validator();
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
