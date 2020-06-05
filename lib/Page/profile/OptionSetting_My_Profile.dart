import 'dart:async';
import 'dart:io';
import 'dart:wasm';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/Page/setting/ChangePassword.dart';
import 'package:scrap/Page/setting/ChangePhone.dart';
import 'package:scrap/function/aboutUser/BlockingFunction.dart';
import 'package:scrap/function/aboutUser/ReportApp.dart';
import 'package:scrap/function/aboutUser/SettingFunction.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/dialog/ScrapDialog.dart';
import 'package:scrap/widget/footer.dart';
import 'package:scrap/widget/guide.dart';
import 'package:scrap/widget/peoplethrowpaper.dart';
import 'package:scrap/widget/wrap.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:webview_flutter/webview_flutter.dart';

// stateless  ที่ทำให้ อ่าน webview ได้ [plugin webview]
// มันจะพาไปหน้า ที่ เราใส่แค่ url
// ใช้ navigator ไปยัง url เลย
// ex.   Navigator.of(context).push(MaterialPageRoute(
//ฟังก์ชั่นส่งไปยัง MyWebView ซึ่งเป็น stl less มาจาก plugin webview
// builder: (BuildContext context) => MyWebView(
//       title: name,
//       selectedUrl: url,
//     )));

class MyWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  MyWebView({
    @required this.title,
    @required this.selectedUrl,
  });
  Widget web() {
    return WebView(
      initialUrl: selectedUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: appBarHeight / 1.5), child: web()),
          appbar_ListOptionSetting(context, Icons.web, title),
        ],
      )),
    );
  }
}

//textfield popup
void showPopup(BuildContext context) {
  int _charCount = 0;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter a) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: screenHeightDp / 2,
                  width: screenWidthDp / 1.1,
                  child: Container(
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomPadding: false,
                      body: Container(
                        width: screenWidthDp,
                        height: appBarHeight * 3.65,
                        decoration: BoxDecoration(
                            color: Color(0xff1a1a1a),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '\t\tเพิ่มสเตตัส',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: s52,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(right: appBarHeight / 10),
                                  child: GestureDetector(
                                      child: Container(
                                        height: appBarHeight / 2.8,
                                        width: appBarHeight / 2.8,
                                        decoration: BoxDecoration(
                                            color: Color(0xfff000000),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(appBarHeight))),
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.blue,
                                          size: s42,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: appBarHeight / 7,
                            ),
                            Divider(
                              height: 1.0,
                              color: Color(0xff222222),
                            ),
                            SizedBox(
                              height: appBarHeight / 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  // color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s48,
                                ),
                                minLines: 4,
                                maxLines: 4,
                                maxLength: 60,
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Color(0xff222222),
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                  hintText: 'เขียนข้อความของคุณ',
                                  hintStyle: TextStyle(
                                    fontSize: s48,
                                    height: 0.08,
                                    color: Color(0xffA2A2A2).withOpacity(0.43),
                                    //color: AppColors.textFieldInput
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                ),
                                onChanged: (String value) {
                                  a(() {
                                    _charCount = value.length;
                                    print(_charCount);
                                  });
                                },
                              ),
                              width: appBarHeight * 4.2,
                              height: appBarHeight * 2.3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: screenWidthDp / 5,
                                  height: appBarHeight / 2.3,
                                  decoration: BoxDecoration(
                                      color: Color(0xff000000),
                                      borderRadius: BorderRadius.circular(
                                          screenHeightDp)),
                                  child: Center(
                                    child: Text(
                                      ' ' + _charCount.toString() + '\t/\t60 ',
                                      style: TextStyle(
                                        color: Colors.white30,
                                        fontSize: s42,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: appBarHeight,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        appBarHeight / 3,
                                        appBarHeight / 25,
                                        appBarHeight / 3,
                                        appBarHeight / 25),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff26A4FF),
                                        borderRadius: BorderRadius.circular(
                                            screenHeightDp)),
                                    child: Center(
                                      child: Text(
                                        'เพิ่ม',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontSize: s48,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      });
}

//การตั้งค่า
class OptionSetting extends StatefulWidget {
  @override
  _OptionSettingState createState() => _OptionSettingState();
}

class _OptionSettingState extends State<OptionSetting> {
  StreamSubscription loadStatus;
  bool loading = false;

  @override
  void initState() {
    loadStatus =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

// ตัวให้ logout
  Widget logout() {
    return FlatButton(
        onPressed: () {
          authService.signOut(context);
        },
        child: Container(
          margin: EdgeInsets.only(
              left: appBarHeight / 100, bottom: appBarHeight / 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: s60,
                  ),
                  SizedBox(
                    width: screenWidthDp / 50,
                  ),
                  Text(
                    'ออกจากระบบ',
                    style: TextStyle(color: Colors.white, fontSize: s52),
                  )
                ],
              ),
              SizedBox()
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      appbarOptionSetting(context),
                      SizedBox(height: screenWidthDp / 15),
                      list_OptionSetting(context, Icons.face,
                          'จัดการบัญชีของฉัน', Manage_MyProfile()),
                      list_OptionSetting(context, Icons.history,
                          'ประวัติการโยนสแครป', HistoryScrap()),
                      //ไปยัง เว็บ ข้อกำหนดการให้บริการ
                      list_OptionSettingweb(
                          context,
                          Icons.description,
                          'ข้อกำหนดการให้บริการ',
                          'https://scrap.bualoitech.com/termsofservice-and-policy.html#term'),
                      //ไปยัง เว็บ สารจากผู้พัฒนา
                      list_OptionSettingweb(
                          context,
                          Icons.markunread,
                          'สารจากผู้พัฒนา',
                          'https://scrap.bualoitech.com/massage-from-us.html'),
                      list_OptionSetting(context, Icons.bug_report,
                          'แจ้งปัญหาระบบ', ReportToScrap_MyProfile()),
                      list_OptionSetting(context, Icons.block,
                          'ประวัติการบล็อค', BlockUser_MyProfile()),
                      //ออกจากระบบ
                      logout(),
                      //ระยะห่างจาก ออกจากระบบ ถึง scrap version บลาๆๆๆ
                      SizedBox(
                        height: screenWidthDp / 5,
                      ),
                      // ไฟล์ svg ชัดกว่า png,jpg
                      Container(
                        child: Column(
                          children: [
                            GestureDetector(
                              child: ClipRRect(
                                  child: SvgPicture.asset(
                                      'assets/scraplogofinal.svg',
                                      width: a.width / 4,
                                      fit: BoxFit.contain)),
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            ),
                            Text(
                              'version 2.0.1\n\n',
                              style:
                                  TextStyle(color: Colors.white, fontSize: s42),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            loading ? Loading() : SizedBox(),
          ],
        ),
      ),
    );
  }
}

// appbar ที่หน้า optionsetting
Widget appbarOptionSetting(BuildContext context) {
  return Container(
    height: appBarHeight / 1.42,
    width: screenWidthDp,
    color: Colors.black,
    padding: EdgeInsets.symmetric(
      horizontal: screenWidthDp / 21,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
            child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
            onTap: () {
              Navigator.pop(context);
            }),
        Text(
          'การตั้งค่า',
          style: TextStyle(
            fontSize: s52,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
            child: Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: s65,
            ),
            onTap: () {
              // null only
            }),
        //SizedBox(),
      ],
    ),
  );
}

// list_OptionSetting เป็น Widget ที่แสดงลิสต์ต่างๆในการตั้งค่า
// (context , ชื่อicon, ชื่อการตั้งค่า, หน้าstatefulที่หลังจากกด)

Widget list_OptionSetting(context, icon, name, stateful) {
  return FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => stateful));
      },
      child: Container(
        margin:
            EdgeInsets.only(left: appBarHeight / 100, bottom: appBarHeight / 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: s60,
                ),
                SizedBox(
                  width: screenWidthDp / 50,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: s52),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: s42,
            )
          ],
        ),
      ));
}

//webview

// list_OptionSettingweb เป็น Widget ที่แสดงลิสต์ที่มากจากเว็บในการตั้งค่า
// (context , ชื่อicon, ชื่อการตั้งค่า, url )
Widget list_OptionSettingweb(context, iconweb, String name, String url) {
  return FlatButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            //ฟังก์ชั่นส่งไปยัง MyWebView ซึ่งเป็น stl less มาจาก plugin webview
            builder: (BuildContext context) => MyWebView(
                  title: name,
                  selectedUrl: url,
                )));
      },
      child: Container(
        margin:
            EdgeInsets.only(left: appBarHeight / 100, bottom: appBarHeight / 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  iconweb,
                  color: Colors.white,
                  size: s60,
                ),
                SizedBox(
                  width: screenWidthDp / 50,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: s52),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: s42,
            )
          ],
        ),
      ));
}

// Appbar ในหน้า statefulต่างๆ ที่หลังจากกด
Widget appbar_ListOptionSetting(BuildContext context, icon, name) {
  return Container(
    height: appBarHeight / 1.42,
    width: screenWidthDp,
    color: Colors.black,
    padding: EdgeInsets.symmetric(
      horizontal: screenWidthDp / 21,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
            child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
            onTap: () {
              Navigator.pop(context);
            }),
        Text(
          '\t' + name,
          style: TextStyle(
            fontSize: s52,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // เปลี่ยนเป็น sizedbox ก็ได้
        GestureDetector(
            child: Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: s65,
            ),
            onTap: () {
              // null only
            }),
      ],
    ),
  );
}

//หน้า จัดการบัญชีของฉัน
class Manage_MyProfile extends StatefulWidget {
  @override
  _Manage_MyProfileState createState() => _Manage_MyProfileState();
}

class _Manage_MyProfileState extends State<Manage_MyProfile> {
  bool initInfoFinish = false, loading = false;
  String status, id;
  var _key = GlobalKey<FormState>();
  File image;
  StreamSubscription loadStream;

  @override
  void initState() {
    initUser();
    loadStream =
        setting.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  initUser() async {
    var data = await userinfo.readContents();
    status = data['status'];
    setState(() => initInfoFinish = true);
  }

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
  void dispose() {
    loadStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    screenutilInit(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              initInfoFinish
                  ? SingleChildScrollView(
                      child: Form(
                        key: _key,
                        child: Column(
                          children: [
                            appbar_ListOptionSetting(
                                context, Icons.face, 'จัดการบัญชีของฉัน'),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: screenHeightDp / 5.5,
                              width: screenWidthDp / 1.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color(0xff1a1a1a),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: screenWidthDp / 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        child: Container(
                                          height: screenWidthDp / 4,
                                          width: screenWidthDp / 4,
                                          margin: EdgeInsets.only(
                                              right: screenHeightDp / 42),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenHeightDp),
                                              image: DecorationImage(
                                                  image: FileImage(image == null
                                                      ? File(user.img)
                                                      : image),
                                                  fit: BoxFit.cover)),
                                        ),
                                        onTap: () => selectImg(context)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                              maxLength: 16,
                                              initialValue: user.id ?? 'name',
                                              style: TextStyle(
                                                  fontSize: s60,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              decoration: InputDecoration(
                                                  counterText: '',
                                                  border: InputBorder.none,
                                                  prefixText: '@',
                                                  prefixStyle: TextStyle(
                                                      fontSize: s60,
                                                      height: 0.1,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              validator: (val) {
                                                var trim = val.trim();
                                                return trim.length < 1
                                                    ? toast.validateToast(
                                                        'ใส่ไอดีของคุณ')
                                                    : null;
                                              },
                                              onSaved: (val) =>
                                                  id = val.trim()),
                                          Text(
                                            'Thailand',
                                            style: TextStyle(
                                              fontSize: s60,
                                              height: 0.1,
                                              color: Color(0xfff26A4FF),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: screenHeightDp / 42)
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: appBarHeight / 15),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 10,
                              ),
                              height: screenHeightDp / 3,
                              width: screenWidthDp / 1.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color(0xff1a1a1a),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'แก้ไขสเตตัสของคุณ',
                                      style: TextStyle(
                                        fontSize: s48,
                                        color: Color(0xfff26A4FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: screenHeightDp / 3.85,
                                    padding: EdgeInsets.only(
                                      left: screenWidthDp / 30,
                                      right: screenWidthDp / 30,
                                      bottom: screenWidthDp / 30,
                                    ),
                                    /*   margin:
                                        EdgeInsets.symmetric(horizontal: 12),*/
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Color(0xff222222),
                                    ),
                                    child: TextFormField(
                                        initialValue: status ?? '',
                                        maxLength: 60,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: s42,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                            counterText: '',
                                            border: InputBorder.none,
                                            hintText: 'สเตตัสของคุณ',
                                            hintStyle: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: s42,
                                                color: Colors.white54,
                                                fontWeight: FontWeight.bold)),
                                        onSaved: (val) => status = val.trim()),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 10,
                              ),
                              height: screenHeightDp / 4.5,
                              width: screenWidthDp / 1.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Color(0xff1a1a1a),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'เบอร์โทรศัพท์',
                                    style: TextStyle(
                                      fontSize: s42,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(phoneFormat(user.phone ?? '0000000000'),
                                      style: TextStyle(
                                          fontSize: s65,
                                          color: Color(0xfff26A4FF))),
                                  GestureDetector(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: s52,
                                          ),
                                          SizedBox(
                                            width: screenWidthDp / 50,
                                          ),
                                          Text(
                                            'เปลี่ยนเบอร์โทรศัพท์',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: s42,
                                                color: Colors.white),
                                          )
                                        ]),
                                    onTap: () {
                                      nav.push(context, ChangePhone());
                                    },
                                  ),
                                  SizedBox(height: appBarHeight / 9),
                                  GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                            size: s52,
                                          ),
                                          SizedBox(
                                            width: screenWidthDp / 50,
                                          ),
                                          Text(
                                            'เปลี่ยนรหัสผ่าน',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: s42,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () =>
                                          nav.push(context, ChangePassword())),
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                width: screenWidthDp / 3.2,
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidthDp / 21,
                                    vertical: screenWidthDp / 72),
                                decoration: BoxDecoration(
                                  color: Color(0xfff26A4FF),
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp / 54),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('บันทึก',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: s54,
                                          color: Colors.white,
                                        )),
                                    SizedBox(width: 2.1),
                                    Icon(Icons.save,
                                        color: Colors.white, size: s46)
                                  ],
                                ),
                              ),
                              onTap: () async {
                                if (_key.currentState.validate()) {
                                  setting.loading.add(true);
                                  _key.currentState.save();
                                  if (id != user.id) {
                                    await authService.hasAccount('id', id)
                                        ? toast.toast('ไอดีนี้มีคนใช้แล้ว')
                                        : setting.updateProfile(context,
                                            id: id,
                                            status: status,
                                            image: image);
                                  } else
                                    setting.updateProfile(context,
                                        id: id, status: status, image: image);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
              loading ? Loading() : SizedBox()
            ],
          )),
    );
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

  String phoneFormat(String phone) {
    return "${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6, 10)}";
  }
}

// หน้า ประวัติการเขียนสแครป
class HistoryScrap extends StatefulWidget {
  @override
  _HistoryScrapState createState() => _HistoryScrapState();
}

class _HistoryScrapState extends State<HistoryScrap> {
  var controller = RefreshController();
  var textGroup = AutoSizeGroup();
  List<DocumentSnapshot> scraps = [];
  List<DocumentSnapshot> throwScrap = [];
  bool initFinish = false;
  String dropdownValue = 'ประวัติการโยนสแครป';

  @override
  void initState() {
    initScrap();
    super.initState();
  }

  initScrap() async {
    final user = Provider.of<UserData>(context, listen: false);
    var docs = await fireStore
        .collection('Users/${user.region}/users/${user.uid}/history')
        .orderBy('scrap.timeStamp', descending: true)
        .limit(8)
        .getDocuments();
    scraps.addAll(docs.documents);
    setState(() => initFinish = true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['timeStamp'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            appBar(),
            Container(
                padding: EdgeInsets.only(top: appBarHeight / 1.35),
                margin: EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
                child: initFinish
                    ? body(dropdownValue == 'ประวัติการโยนสแครป'
                        ? scraps
                        : throwScrap)
                    : Center(child: LoadNoBlur())),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    final user = Provider.of<UserData>(context, listen: false);
    return Container(
      height: appBarHeight / 1.42,
      width: screenWidthDp,
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 21),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
              onTap: () {
                Navigator.pop(context);
              }),
          DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: dropdownValue,
                  style: TextStyle(
                      fontSize: s52,
                      fontFamily: 'ThaiSans',
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  iconSize: s60,
                  onChanged: (String newValue) async {
                    if (newValue == 'ประวัติการปาสแครป' &&
                        throwScrap.length < 1) {
                      setState(() => initFinish = false);
                      var docs = await fireStore
                          .collection(
                              'Users/${user.region}/users/${user.uid}/thrownLog')
                          .orderBy('scrap.timeStamp', descending: true)
                          .limit(8)
                          .getDocuments();
                      throwScrap.addAll(docs.documents);
                      dropdownValue = newValue;
                      setState(() => initFinish = true);
                    } else
                      setState(() => dropdownValue = newValue);
                  },
                  items: <String>['ประวัติการโยนสแครป', 'ประวัติการปาสแครป']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style:
                                TextStyle(fontSize: s54, color: Colors.white)));
                  }).toList())),
          SizedBox()
        ],
      ),
    );
  }

  Widget body(List<DocumentSnapshot> listScraps) {
    final user = Provider.of<UserData>(context, listen: false);
    return StatefulBuilder(builder: (context, StateSetter setList) {
      return listScraps.length > 0
          ? SmartRefresher(
              footer: Footer(),
              enablePullDown: false,
              enablePullUp: true,
              controller: controller,
              onLoading: () async {
                if (listScraps.length > 0) {
                  var ref = dropdownValue == 'ประวัติการปาสแครป'
                      ? fireStore.collection(
                          'Users/${user.region}/users/${user.uid}/history')
                      : fireStore.collection(
                          'Users/${user.region}/users/${user.uid}/thrownLog');
                  var query = await ref
                      .orderBy('scrap.timeStamp', descending: true)
                      .startAfterDocument(listScraps.last)
                      .limit(8)
                      .getDocuments();
                  listScraps.addAll(query.documents);
                  query.documents.length > 0
                      ? setList(() => controller.loadComplete())
                      : controller.loadNoData();
                } else
                  controller.loadNoData();
              },
              physics: BouncingScrollPhysics(),
              child: scrapGrid(listScraps))
          : Center(
              child: guide(dropdownValue == 'ประวัติการโยนสแครป'
                  ? 'ไม่มีประวัติการทิ้ง'
                  : 'ไม่มีประวัติการปา'),
            );
    });
  }

  /*
  Row(children: <Widget>[
              Text(name,
                  style: TextStyle(
                      fontSize: s52,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_drop_down, size: s54, color: Colors.white)
            ]),
   */

  Widget scrapGrid(List docs) {
    return Wrap(
        alignment: WrapAlignment.start,
        spacing: screenWidthDp / 42,
        runSpacing: screenWidthDp / 42,
        children: docs.map((doc) => scrap(doc)).toList());
  }

  Widget scrap(DocumentSnapshot data) {
    return GestureDetector(
      child: Container(
          height: screenWidthDp / 2.16 * 1.21,
          width: screenWidthDp / 2.16,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/paperscrap.jpg'),
                  fit: BoxFit.cover)),
          child: Stack(children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
              child: AutoSizeText(data['scrap']['text'],
                  textAlign: TextAlign.center,
                  group: textGroup,
                  style: TextStyle(fontSize: s46)),
            )),
            data['burnt'] ?? false
                ? Container(
                    margin: EdgeInsets.all(4),
                    height: screenWidthDp / 2.16 * 1.21,
                    width: screenWidthDp / 2.16,
                    color: Colors.black38,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.whatshot,
                              size: 50, color: Color(0xffFF8F3A)),
                          Text('ถูกเผา',
                              style: TextStyle(
                                  color: Colors.white, fontSize: s48)),
                        ]))
                : isExpired(data)
                    ? Container(
                        margin: EdgeInsets.all(4),
                        height: screenWidthDp / 2.16 * 1.21,
                        width: screenWidthDp / 2.16,
                        color: Colors.black38,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history,
                                  size: 50, color: Colors.white),
                              Text('หมดเวลา',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: s48)),
                            ]))
                    : SizedBox()
          ])),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                dropdownValue == 'ประวัติการโยนสแครป'
                    ? ScrapDialog(data: data)
                    : Paperstranger(scrap: data, isHistory: true));
      },
    );
  }

  Widget guide(String text) {
    return Container(
      height: screenHeightDp / 2.4,
      width: screenWidthDp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/paper.svg',
              color: Colors.white60,
              height: screenWidthDp / 3.5,
              fit: BoxFit.contain),
          Text(
            text,
            style: TextStyle(
                fontSize: screenWidthDp / 16,
                color: Colors.white60,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

//กระดาษที่หมดเวลาแล้ว
class TimeOut_Paper_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(4),
          // width: (174/209)*220,//screenWidthDp / 2.2,
          // height: (209/174)*220,//screenHeightDp / 4,
          width: a.width / 2.2,
          height: (a.width / 2.1) * 1.21,
          color: Colors.yellow.shade700,
        ),
        Container(
          margin: EdgeInsets.all(4),
          // width: (174/209)*220,//screenWidthDp / 2.2,
          // height: (209/174)*220,//screenHeightDp / 4,
          width: a.width / 2.2,
          height: (a.width / 2.1) * 1.21,
          color: Colors.black38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 50,
                color: Colors.white,
              ),
              Text(
                'หมดเวลา',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: s48,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// หน้า แจ้งปัญหาระบบ
class ReportToScrap_MyProfile extends StatefulWidget {
  @override
  _ReportToScrap_MyProfileState createState() =>
      _ReportToScrap_MyProfileState();
}

class _ReportToScrap_MyProfileState extends State<ReportToScrap_MyProfile> {
  String text;
  bool loading = false;
  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                appbar_ListOptionSetting(
                    context, Icons.bug_report, 'แจ้งปัญหาระบบ'),
                SizedBox(
                  height: appBarHeight / 3,
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: screenHeightDp / 1.5,
                    width: screenWidthDp / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff202020),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidthDp / 1.1,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xff383838), width: 1))),
                            child: Text(
                              'ถึงผู้พัฒนา',
                              style:
                                  TextStyle(fontSize: s60, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Form(
                              key: key,
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: s52, color: Colors.white),
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'แจ้งรายละเอียดเกี่ยวกับปัญหา',
                                  hintStyle: TextStyle(
                                    fontSize: s54,
                                    height: 0.08,
                                    color: Colors.white30,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ''
                                      ? toast.validateToast(
                                          'ไม่อธิบายแล้วเราจะรู้ได้ยังไง')
                                      : null;
                                },
                                onSaved: (val) {
                                  final report = Provider.of<Report>(context,
                                      listen: false);
                                  report.reportText = val.trim();
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: appBarHeight / 15),
                                margin: EdgeInsets.symmetric(
                                  horizontal: a.width / 40,
                                  vertical: a.width / 40,
                                ),
                                width: a.width / 8,
                                height: a.width / 8,
                                //alignment: Alignment.center,
                                child: Icon(
                                  Icons.send,
                                  color: Color(0xff26A4FF),
                                  size: s60 * 0.8,
                                ),

                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(a.width)),
                              ),
                              onTap: () async {
                                if (key.currentState.validate()) {
                                  key.currentState.save();
                                  setState(() => loading = true);
                                  await reportApp.reportApp(context);
                                  setState(() => loading = false);
                                  toast.toast(
                                      'ขอบคุณสำหรับการรายงานปัญหาของคุณ');
                                  nav.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }
}

// หน้า ประวัติการบล็อค
class BlockUser_MyProfile extends StatefulWidget {
  @override
  _BlockUser_MyProfileState createState() => _BlockUser_MyProfileState();
}

class _BlockUser_MyProfileState extends State<BlockUser_MyProfile> {
  var controller = RefreshController();
  var textGroup = AutoSizeGroup();
  List blockedUid = [];
  List<DocumentSnapshot> blocked = [], blockedScrap = [];
  bool initBlocked = true, loading = false;
  String dropdownValue = 'บัญชีที่ระบุตัวตน';

  @override
  void initState() {
    initBlockedusers();
    super.initState();
  }

  initBlockedusers() async {
    blockedUid = await cacheFriends.getBlockedUser();
    if (blockedUid.length > 0) {
      var queryList = blockedUid.take(12).toList();
      var docs = await fireStore
          .collectionGroup('users')
          .where('uid', whereIn: queryList)
          .getDocuments();
      blocked.addAll(docs.documents);
      blockedUid.length < 12
          ? blockedUid.clear()
          : blockedUid.removeRange(0, 12);
    }
    setState(() => initBlocked = false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(child: appBar()),
              Stack(
                children: <Widget>[
                  initBlocked
                      ? Center(child: LoadNoBlur())
                      : StatefulBuilder(
                          builder: (context, StateSetter setList) {
                          return Container(
                              margin: EdgeInsets.only(top: appBarHeight * 0.9),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidthDp / 36),
                              child: SmartRefresher(
                                  footer: Footer(),
                                  enablePullDown: false,
                                  controller: controller,
                                  onLoading: () async {
                                    var queryList =
                                        blockedUid.take(12).toList();
                                    if (queryList.length > 0) {
                                      var docs = await fireStore
                                          .collectionGroup('users')
                                          .where('uid', whereIn: queryList)
                                          .getDocuments();
                                      blocked.addAll(docs.documents);
                                      blockedUid.length < 12
                                          ? blockedUid.clear()
                                          : blockedUid.removeRange(0, 12);
                                      setList(() {});
                                      docs.documents.length > 0
                                          ? controller.loadComplete()
                                          : controller.loadNoData();
                                    } else {
                                      controller.loadNoData();
                                    }
                                  },
                                  physics: BouncingScrollPhysics(),
                                  child: dropdownValue == 'บัญชีที่ระบุตัวตน'
                                      ? blocked.length > 0
                                          ? Column(
                                              children: blocked
                                                  .map((doc) => blockUser(doc))
                                                  .toList())
                                          : Center(
                                              child: guide(
                                                  Size(screenWidthDp,
                                                      screenHeightDp),
                                                  'ไม่พบผู้ใช้ที่คุณบล็อคอยู่'),
                                            )
                                      : blockedScrap.length > 0
                                          ? scrapGrid(blockedScrap)
                                          : Center(
                                              child: guide(
                                                  Size(screenWidthDp,
                                                      screenHeightDp),
                                                  'ไม่พบผู้ใช้ที่คุณบล็อคอยู่'),
                                            )));
                        }),
                  loading ? Loading() : SizedBox()
                ],
              )
            ],
          ),
        ));
  }

  Widget appBar() {
    final user = Provider.of<UserData>(context, listen: false);
    return Container(
      height: appBarHeight / 1.42,
      width: screenWidthDp,
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 21),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
              onTap: () => Navigator.pop(context)),
          DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: dropdownValue,
                  style: TextStyle(
                      fontSize: s52,
                      fontFamily: 'ThaiSans',
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  iconSize: s60,
                  onChanged: (String newValue) async {
                    if (newValue == 'บัญชีไม่ระบุตัวตน' &&
                        blockedScrap.length < 1) {
                      setState(() => initBlocked = true);
                      var docs = await fireStore
                          .collection(
                              'Users/${user.region}/users/${user.uid}/blockedScraps')
                          .orderBy('scrap.timeStamp', descending: true)
                          .limit(8)
                          .getDocuments();
                      blockedScrap.addAll(docs.documents);
                      dropdownValue = newValue;
                      setState(() => initBlocked = false);
                    } else
                      setState(() => dropdownValue = newValue);
                  },
                  items: <String>['บัญชีที่ระบุตัวตน', 'บัญชีไม่ระบุตัวตน']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style:
                                TextStyle(fontSize: s54, color: Colors.white)));
                  }).toList())),
          SizedBox()
        ],
      ),
    );
  }

  Widget scrapGrid(List<DocumentSnapshot> docs) {
    return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: screenWidthDp / 42,
            crossAxisSpacing: screenWidthDp / 42,
            childAspectRatio: 0.826,
            crossAxisCount: 2),
        children: docs.map((doc) => scrap(doc)).toList());
  }

  Widget scrap(DocumentSnapshot data) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/paperscrap.jpg'), fit: BoxFit.cover)),
        child: Stack(children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
            child: AutoSizeText(data['scrap']['text'],
                textAlign: TextAlign.center,
                group: textGroup,
                style: TextStyle(fontSize: s46)),
          )),
          Positioned(
            top: 0,
            right: screenWidthDp / 108,
            child: RaisedButton(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidthDp / 54)),
              child: Text(
                'ปลดบล็อค',
                style: TextStyle(
                    fontSize: s36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () async {
                setState(() => loading = true);
                blockedScrap.remove(data);
                await blocking.unBlockUser(context,
                    otherUid: data['uid'], public: false);
                setState(() => loading = false);
              },
            ),
          )
        ]));
  }

  Widget blockUser(DocumentSnapshot data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
      color: Colors.transparent,
      width: screenWidthDp,
      height: screenWidthDp / 5,
      margin: EdgeInsets.only(bottom: screenWidthDp / 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: screenWidthDp / 6,
                height: screenWidthDp / 6,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(screenWidthDp),
                    image: DecorationImage(
                        image: NetworkImage(data['img']), fit: BoxFit.cover)),
              ),
              SizedBox(width: screenWidthDp / 30),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("@${data['id']}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidthDp / 18,
                            fontWeight: FontWeight.bold)),
                    Text(data['status'] ?? '',
                        style: TextStyle(color: Colors.grey, fontSize: s38))
                  ],
                ),
              )
            ],
          ),
          RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidthDp / 42)),
            child: Text(
              'ปลดบล็อค',
              style: TextStyle(fontSize: s46, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              setState(() => loading = true);
              cacheFriends.unBlock(uid: data['uid']);
              blocked.remove(data);
              await blocking.unBlockUser(context,
                  otherUid: data['uid'], public: true);
              setState(() => loading = false);
            },
          )
        ],
      ),
    );
  }
}

// หน้า ComingSoon
class ComingSoon extends StatefulWidget {
  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: appbar_ListOptionSetting(context, Icons.block, ' '),
            ),
            Center(
                child: Text(
              'COMINGSOON',
              style: TextStyle(color: Colors.white, fontSize: s70 * 1.5),
            )),
          ],
        ),
      ),
    );
  }
}
