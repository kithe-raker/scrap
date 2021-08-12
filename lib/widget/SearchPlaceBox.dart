import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:scrap/models/PlaceModel.dart';
import 'package:scrap/services/config.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/guide.dart';
import 'package:stream_transform/stream_transform.dart';

class SearchPlaceBox extends StatefulWidget {
  final Function(PlaceModel) onSelect;
  SearchPlaceBox({this.onSelect});
  @override
  _SearchPlaceBoxState createState() => _SearchPlaceBoxState();
}

class _SearchPlaceBoxState extends State<SearchPlaceBox> {
  List<PlaceModel> places = [];
  var node = FocusNode();
  TextEditingController tx = TextEditingController();
  bool isSearching = false;
  StreamController<String> streamController = StreamController();
  final dio = Dio();

  @override
  void initState() {
    streamController.stream
        .debounce(Duration(milliseconds: 560))
        .listen((value) => getLocationResults(value));
    super.initState();
  }

  Future<void> getLocationResults(String input) async {
    places.clear();
    if (input.length > 0) {
      try {
        var location = Provider.of<Position>(context, listen: false) ??
            Position(latitude: 13.754661, longitude: 100.500931);
        String baseURL =
            'https://autosuggest.search.hereapi.com/v1/autosuggest?at=${location.latitude},${location.longitude}';
        String request =
            '$baseURL&q=$input&resultTypes=place&apiKey=${hereConfig.apiKey}';

        Response response = await dio.get(request);
        final predictions = response.data['items'];

        await Future.forEach(predictions, (dat) async {
          var info = dat;
          if (info['position']['lat'] == null)
            info = await getPlacePosition(dat['id']);
          places.add(PlaceModel.fromJSON(info));
        });
      } catch (e) {}
    }
    setState(() {});
  }

  Future getPlacePosition(String id) async {
    String baseUrl = 'https://lookup.search.hereapi.com/v1/lookup';
    String request = '$baseUrl?id=$id&apiKey=${hereConfig.apiKey}';
    Response response = await dio.get(request);
    return response.data;
  }

  @override
  void dispose() {
    tx.dispose();
    node.dispose();
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Container(
      height: isSearching
          ? screenWidthDp / 8 / 1.2 + screenHeightDp / 2.1
          : screenWidthDp / 8 / 1.2,
      decoration: BoxDecoration(
          color: isSearching ? Colors.grey[900] : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSearching
              ? [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6.0,
                      spreadRadius: 3.0,
                      offset: Offset(0.0, 3.2))
                ]
              : null),
      child: Column(
        children: <Widget>[
          Container(
            height: screenWidthDp / 8 / 1.2,
            padding: EdgeInsets.all(screenWidthDp / 100),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.black,
                border: Border.all(color: Color(0xfff26A4FF))),
            child: Stack(
              children: <Widget>[
                TextFormField(
                    focusNode: node,
                    controller: tx,
                    style: TextStyle(color: Colors.white, fontSize: s42),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(4.8),
                      hintText: 'ค้นหาสถานที่',
                      hintStyle:
                          TextStyle(color: Colors.white60, fontSize: s42),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onTap: () => setState(() => isSearching = true),
                    onFieldSubmitted: (val) {
                      if (tx.text.trim().length < 1)
                        setState(() => isSearching = false);
                    },
                    onChanged: (val) => streamController.add(val.trim())),
                tx.text.trim().length > 0 || isSearching
                    ? Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: screenWidthDp / 46),
                        child: GestureDetector(
                            child: Icon(Icons.clear,
                                color: Color(0xfff26A4FF), size: s42),
                            onTap: () {
                              node.unfocus();
                              tx.clear();
                              setState(() => isSearching = false);
                            }),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          isSearching
              ? Container(
                  height: screenHeightDp / 2.1,
                  child: places.length > 0
                      ? ListView(
                          children:
                              places.map((plc) => resultWidget(plc)).toList())
                      : Center(
                          child: guide(Size(screenWidthDp, screenHeightDp),
                              'ค้นหาสถานที่')),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget resultWidget(PlaceModel placeModel) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 27),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 1.2))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(placeModel.name,
                maxLines: 1,
                style: TextStyle(
                    fontSize: s46,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start),
            AutoSizeText(placeModel.description,
                maxLines: 1,
                minFontSize: 18,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 19, color: Colors.white.withOpacity(0.42)),
                textAlign: TextAlign.start),
          ],
        ),
      ),
      onTap: () async {
        node.unfocus();
        tx.text = placeModel.name;
        setState(() => isSearching = false);
        widget.onSelect(placeModel);
      },
    );
  }
}
