import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scrap/services/admob_service.dart';

class GridSubscripe1 extends StatefulWidget {
  @override
  _GridSubscripe1State createState() => _GridSubscripe1State();
}

class _GridSubscripe1State extends State<GridSubscripe1> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize(AdmobService().getAdmobAppId());
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: ListView(
                children: [
                  Container(
                    width: a.width,
                    child: Wrap(
                      children: [
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        admob(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        block(),
                        admob()

                      ],
                    ),
                  ),
                ],
              ),
    );
  }
  Widget block() {
    Size a = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: a.width / 80, left: a.width / 80),
      width: a.width / 2.1,
      height: a.width / 2.1,
      color: Colors.white,
    );
  }

  Widget admob(){
    Size a = MediaQuery.of(context).size;
    return   Container(
              margin: EdgeInsets.only(top:a.width/80),
                width: a.width,
                color: Colors.grey,
                child:
                AdmobBanner(
                    adUnitId: AdmobService().getBannerAdId(),
                    adSize: AdmobBannerSize.LARGE_BANNER),
              );
 
  }
}