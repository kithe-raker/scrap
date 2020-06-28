import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/models/PlaceModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/services/config.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/SearchPlaceBox.dart';
import 'package:scrap/widget/streamWidget/StreamLoading.dart';

class LitteringScrap extends StatefulWidget {
  @override
  _LitteringScrapState createState() => _LitteringScrapState();
}

class _LitteringScrapState extends State<LitteringScrap> {
  final dio = Dio();
  bool initedSuggestion = false;
  PlaceModel selected;
  List<PlaceModel> placesSearched = [], suggestPlaces = [];

  @override
  void initState() {
    initSuggestPlaces();
    super.initState();
  }

  Future<void> initSuggestPlaces() async {
    try {
      var location = Provider.of<Position>(context, listen: false);
      String baseURL =
          'https://autosuggest.search.hereapi.com/v1/autosuggest?at=${location.latitude},${location.longitude}';
      String request =
          '$baseURL&q=โรงเรียน&resultTypes=place&apiKey=${hereConfig.apiKey}';

      Response response = await dio.get(request);
      final predictions = response.data['items'];

      predictions.forEach((dat) {
        if (suggestPlaces.length < 6)
          suggestPlaces.add(PlaceModel.fromJSON(dat));
      });
    } catch (e) {}
    setState(() => initedSuggestion = true);
  }

  Future<DataSnapshot> placeTransaction(String placeId) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var placeAll = FirebaseDatabase(app: db.placeAll);
    var ref = placeAll.reference().child('places/$placeId/allCount');
    return ref.once();
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
            Column(
              children: <Widget>[
                Expanded(
                  child: initedSuggestion
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidthDp / 27),
                          child: ListView(
                            children: <Widget>[
                              SizedBox(height: screenWidthDp / 7.2),
                              placesSearched.length > 0
                                  ? Column(
                                      children: placesSearched
                                          .map((place) => placeBlock(place))
                                          .toList(),
                                    )
                                  : SizedBox(),
                              SizedBox(height: screenHeightDp / 54),
                              Text(
                                'ไม่ไกลจากคุณ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: s54,
                                    fontWeight: FontWeight.bold),
                              ),
                              suggestPlaces.length > 0
                                  ? Column(
                                      children: suggestPlaces
                                          .map((place) => placeBlock(place))
                                          .toList(),
                                    )
                                  : SizedBox(),
                              SizedBox(height: screenHeightDp / 54)
                            ],
                          ),
                        )
                      : Center(child: LoadNoBlur()),
                ),
                GestureDetector(
                    child: Container(
                      width: screenWidthDp,
                      height: screenHeightDp / 11.2,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidthDp / 21),
                      alignment: Alignment.center,
                      color: selected == null ? Colors.grey[600] : Color(0xff26A4FF),
                      child: selected == null
                          ? Text(
                              'เลือกบริเวณที่จะโยนไป',
                              style: TextStyle(
                                  fontSize: s54,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ThaiSans'),
                            )
                          : AutoSizeText.rich(
                              TextSpan(
                                style: TextStyle(
                                    fontSize: s54,
                                    color: Colors.white,
                                    fontFamily: 'ThaiSans'),
                                children: <TextSpan>[
                                  TextSpan(text: 'โยนไปแถวๆ '),
                                  TextSpan(
                                      text: selected.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                    ),
                    onTap: () {
                      if (selected != null)
                        scrap.litter(context, place: selected);
                    })
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: screenHeightDp / 54),
                padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 27),
                child: SearchPlaceBox(
                  onSelect: (place) {
                    selected = place;
                    if (!placesSearched.contains(place))
                      setState(() => placesSearched.insert(0, place));
                  },
                ),
              ),
            ),
            Center(child: StreamLoading(stream: scrap.loading, blur: true))
          ],
        ),
      ),
    );
  }

// 'โยนไปบริเวณ${selected.name}'
  Widget placeBlock(PlaceModel place) {
    return GestureDetector(
      child: Container(
          height: screenHeightDp / 6,
          // padding: EdgeInsets.symmetric(vertical: screenHeightDp / 72),
          margin: EdgeInsets.only(top: screenHeightDp / 54),
          decoration: BoxDecoration(
              color: Color(0xff2E2E2E),
              borderRadius: BorderRadius.circular(screenWidthDp / 32)),
          child: Stack(
            children: <Widget>[
              Center(
                child: ListTile(
                  title: Text(
                    place.name,
                    style: TextStyle(
                        fontSize: s46,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: AutoSizeText(
                    place.description,
                    maxLines: 2,
                    minFontSize: 21,
                    style: TextStyle(
                        fontSize: 22, color: Colors.white70, height: 1.2),
                  ),
                ),
              ),
              Positioned(
                  top: screenWidthDp / 42,
                  right: screenWidthDp / 42,
                  child: transactionBox(place.placeId)),
              place == selected
                  ? Container(
                      color: Colors.black38,
                      child: Center(
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.check,
                                  size: s52, color: Color(0xff26A4FF)))),
                    )
                  : SizedBox()
            ],
          )),
      onTap: () {
        selected = place == selected ? null : place;
        setState(() {});
      },
    );
  }

  Widget transactionBox(String placeId) {
    return FutureBuilder(
        future: placeTransaction(placeId),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData && snapshot?.data?.value != null) {
            var trans = snapshot.data?.value ?? 0;
            return trans < 0
                ? Container(
                    padding: EdgeInsets.only(
                        left: screenWidthDp / 64, right: screenWidthDp / 42),
                    decoration: BoxDecoration(
                        color: Color(0xff585858),
                        borderRadius:
                            BorderRadius.circular(screenWidthDp / 18)),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset('assets/paper.svg',
                            // color: Color(0xfff434343),
                            width: screenWidthDp / 14,
                            height: screenWidthDp / 14,
                            fit: BoxFit.contain),
                        Text(
                          trans.abs().toString(),
                          style:
                              TextStyle(fontSize: s42, color: Colors.white70),
                        )
                      ],
                    ),
                  )
                : SizedBox();
          } else
            return SizedBox();
        });
  }
}
