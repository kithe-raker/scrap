import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/method/Globalkey.dart';
import 'package:scrap/widget/PlaceText.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:social_share/social_share.dart';

class ShareFunction {
  final loadStatus = BehaviorSubject<bool>();

  Future<void> shareInstagram(
      {@required String text,
      @required String writer,
      @required int paperIndex,
      @required DateTime time,
      String placeName}) async {
    loadStatus.add(true);
    var checker = await SocialShare.checkInstalledAppsForShare();
    if (checker['instagram'] == true) {
      var img = await getScrapImage(
          text: text,
          writer: writer,
          placeName: placeName,
          paperIndex: paperIndex,
          time: time);
      await SocialShare.shareInstagramStory(
          img.path, "#212121", "#000000", "https://scrap.bualoitech.com/");
      loadStatus.add(false);
      await img.delete();
    } else {
      loadStatus.add(false);
      toast("โหลดไอจีก่อนฮะ");
    }
  }

  Future<void> shareFacebook(
      {@required String text,
      @required String writer,
      @required int paperIndex,
      @required DateTime time,
      String placeName}) async {
    loadStatus.add(true);
    var checker = await SocialShare.checkInstalledAppsForShare();
    if (checker['facebook'] == true) {
      var img = await getScrapImage(
          text: text,
          writer: writer,
          placeName: placeName,
          paperIndex: paperIndex,
          time: time);
      await SocialShare.shareFacebookStory(
          img.path, "#212121", "#000000", "https://scrap.bualoitech.com/",
          appId: Platform.isAndroid ? '152617042778122' : null);
      loadStatus.add(false);
      await img.delete();
    } else {
      loadStatus.add(false);
      toast("โหลดเฟซบุ๊คก่อนฮะ");
    }
  }

  Future<File> getScrapImage(
      {@required String text,
      @required String writer,
      @required int paperIndex,
      @required DateTime time,
      String placeName = ''}) async {
    screenutilInit(myGlobals.scaffoldKey.currentContext);
    var scrapWidget = SizedBox(
        height: screenWidthDp / 1.04 * 1.115 + screenHeightDp / 7.2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: screenWidthDp / 1.04,
                height: screenWidthDp / 1.04 * 1.115,
                child: Stack(
                  children: <Widget>[
                    SvgPicture.asset(
                        'assets/${texture.textures[paperIndex ?? 0] ?? 'paperscrap.svg'}',
                        fit: BoxFit.cover),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Text(text,
                            style: TextStyle(
                                height: 1.35,
                                fontFamily: 'ThaiSans',
                                color: Colors.black,
                                fontSize: s60),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidthDp / 36),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 36),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        writer == 'ไม่ระบุตัวตน' ? 'ใครบางคน' : '@$writer',
                        style: TextStyle(
                            fontSize: s48,
                            height: 1.1,
                            fontFamily: 'ThaiSans',
                            color: writer == 'ไม่ระบุตัวตน'
                                ? Colors.white
                                : Color(0xff26A4FF)),
                      ),
                      PlaceText(time: time, placeName: placeName)
                    ]),
              ),
            ]));
    var img = await createImageFromWidget(scrapWidget);
    var now = DateTime.now().toIso8601String();
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filePathAndName = documentDirectory.path + '/$now.jpg';
    File file = new File(filePathAndName);
    file.writeAsBytesSync(img);
    return file;
  }

  Future<Uint8List> createImageFromWidget(Widget widget,
      {Duration wait = const Duration(milliseconds: 1750)}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    Size logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;
    Size imageSize = ui.window.physicalSize;
    final RenderView renderView = RenderView(
      window: null,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(textDirection: TextDirection.ltr, child: widget),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    if (wait != null) {
      await Future.delayed(wait);
    }

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image = await repaintBoundary.toImage(
        pixelRatio: imageSize.width / logicalSize.width);
    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData.buffer.asUint8List();
  }

  void toast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}

final share = ShareFunction();
