import 'package:flutter/material.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/models/TopPlaceModel.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/explore/PlaceWidget.dart';
import 'package:scrap/widget/guide.dart';

class PlaceResult extends StatefulWidget {
  final String searchText;
  PlaceResult({@required this.searchText});
  @override
  _PlaceResultState createState() => _PlaceResultState();
}

class _PlaceResultState extends State<PlaceResult>
    with AutomaticKeepAliveClientMixin {
  Future<List<TopPlaceModel>> searchPlace() async {
    List<TopPlaceModel> places = [];
    if (widget.searchText.length > 0) {
      var docs = await fireStore
          .collection('Places')
          .where('name', isGreaterThanOrEqualTo: widget.searchText)
          .limit(8)
          .getDocuments();
      if (docs.documents.length > 0)
        docs.documents
            .forEach((doc) => places.add(TopPlaceModel.fromJSON(doc.data)));
    }
    return places;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: screenHeightDp / 72),
        child: FutureBuilder(
            future: searchPlace(),
            builder: (context, AsyncSnapshot<List<TopPlaceModel>> snapshot) {
              if (snapshot.hasData) {
                var places = snapshot.data;
                return places.length > 0
                    ? ListView(
                        children: places
                            .map((place) => PlaceWidget(place: place))
                            .toList(),
                      )
                    : widget.searchText.length > 0
                        ? Center(
                            child: guide(Size(screenWidthDp, screenHeightDp),
                                'ไม่เจอบริเวณดังกล่าว'))
                        : Center(
                            child: guide(Size(screenWidthDp, screenHeightDp),
                                'ค้นหาบริเวณต่างๆ'));
              } else {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin: EdgeInsets.only(top: screenHeightDp / 6.4),
                      child: LoadNoBlur()),
                );
              }
            }),
      ),
    );
  }
}
