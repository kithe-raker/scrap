import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class TestT extends StatefulWidget {
  @override
  _TestTState createState() => _TestTState();
}

class _TestTState extends State<TestT> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
              child: RaisedButton(
            onPressed: () async {
              var widgetToImg = Container(
                  width: screenWidthDp / 1.04,
                  height: screenWidthDp / 1.04 * 1.115,
                  child: Stack(
                    //addscrappaper
                    children: <Widget>[
                      SvgPicture.asset('assets/paperscrap.svg',
                          fit: BoxFit.cover),
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Text('ทดสอบๆๆ',
                              style: TextStyle(
                                  height: 1.35,
                                  fontFamily: 'ThaiSans',
                                  color: Colors.black,
                                  fontSize: s60),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ));
              var img = await createImageFromWidget(widgetToImg,
                  wait: Duration(milliseconds: 1750));
              var now = DateTime.now().toIso8601String();
              var documentDirectory = await getApplicationDocumentsDirectory();
              var filePathAndName = documentDirectory.path + '/$now.jpg';
              File file2 = new File(filePathAndName);
              file2.writeAsBytesSync(img);
              print(file2.uri);
            },
            child: Text('data'),
          ))),
    );
  }

  Future<Uint8List> createImageFromWidget(Widget widget,
      {Duration wait}) async {
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
}
