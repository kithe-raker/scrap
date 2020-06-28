import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/bottomBarItem/Explore/PlaceResult.dart';
import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/models/TopPlaceModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/stream/LoadStatus.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/explore/PlaceWidget.dart';
import 'package:scrap/widget/footer.dart';
import 'package:scrap/widget/streamWidget/StreamLoading.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  final pageController = PageController();
  var _searchController = TextEditingController();
  Timer timer;
  List<TopPlaceModel> places = [];
  Map<String, int> counts = {};
  bool isSearching = false, loading = true, lastQuery = false;
  int lessCount;
  int index = 0;
  var refreshController = RefreshController();
  var focus = FocusNode();
  PublishSubject<String> streamController = PublishSubject<String>();

  void onTap(int _index) {
    setState(() => index = _index);
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    initTopPlaces();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    if (timer?.isActive ?? false) timer.cancel();
    timer = Timer(const Duration(milliseconds: 540), () {
      var trim = _searchController.text.trim();
      trim.length > 0 && trim[0] == '@'
          ? streamController.add(trim.substring(1))
          : streamController.add(trim);
    });
  }

  initTopPlaces() async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var placeAll = FirebaseDatabase(app: db.placeAll);
    List<String> docId = [];
    var ref = placeAll
        .reference()
        .child('places')
        .orderByChild('count')
        .limitToFirst(8);
    DataSnapshot data = await ref.once();
    if (data.value?.length != null && data.value.length > 0) {
      data.value.forEach((key, value) {
        docId.add(value['id']);
        counts[value['id']] = value['allCount'];
        if (lessCount == null)
          lessCount = value['count'];
        else if (lessCount < value['count']) lessCount = value['count'];
      });
      docId.removeWhere((id) => id == null);
      if (docId.length > 0) {
        var docs = await fireStore
            .collection('Places')
            .where('id', whereIn: docId)
            .getDocuments();
        docs.documents
            .forEach((doc) => places.add(TopPlaceModel.fromJSON(doc.data)));
      }
    }
    setState(() => loading = false);
  }

  loadMorePlace() async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var placeAll = FirebaseDatabase(app: db.placeAll);
    List<String> docId = [];
    var ref = placeAll
        .reference()
        .child('places')
        .orderByChild('count')
        .startAt(lessCount + 1)
        .limitToFirst(8);
    DataSnapshot data = await ref.once();
    if (data.value?.length != null && data.value.length > 0) {
      data.value.forEach((key, value) {
        docId.add(value['id']);
        counts[value['id']] = value['allCount'];
        if (lessCount < value['count']) lessCount = value['count'];
      });
    }
    docId.removeWhere((id) => id == null);
    if (docId.length > 0 && !lastQuery) {
      var docs = await fireStore
          .collection('Places')
          .where('id', whereIn: docId)
          .getDocuments();
      if (docs.documents.length < 8) lastQuery = true;
      docs.documents
          .forEach((doc) => places.add(TopPlaceModel.fromJSON(doc.data)));
      setState(() => refreshController.loadComplete());
    } else {
      refreshController.loadNoData();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    focus.dispose();
    streamController.close();
    refreshController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                appBar(),
                Expanded(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
                      child: PageView(
                        controller: pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidthDp / 64),
                            child: StreamBuilder(
                                stream: streamController.stream,
                                builder: (context, string) {
                                  return string?.data != null &&
                                          string.data.length > 0
                                      ? PlaceResult(searchText: string?.data)
                                      : loading
                                          ? Center(child: LoadNoBlur())
                                          : SmartRefresher(
                                              controller: refreshController,
                                              enablePullDown: false,
                                              enablePullUp: true,
                                              footer: Footer(),
                                              onLoading: () => loadMorePlace(),
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: places
                                                      .map((place) =>
                                                          PlaceWidget(
                                                              place: place,
                                                              count: counts[place
                                                                      .id] ??
                                                                  0))
                                                      .toList()),
                                            );
                                }),
                          ),
                          StreamBuilder(
                              stream: streamController.stream,
                              builder: (context, string) {
                                return Subpeople(
                                    hasAppbar: false, searchText: string?.data);
                              })
                        ],
                      )),
                )
              ],
            ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child:
            // )
            Center(child: StreamLoading(stream: loadStatus.nearbyStatus))
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: screenWidthDp / 8 / 1.2,
                padding: EdgeInsets.all(screenWidthDp / 100),
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidthDp / 64,
                    vertical: screenHeightDp / 81),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidthDp / 32),
                    //color: Color(0xff262626),
                    color: Color(0xff2E2E2E),
                    border: Border.all(color: Color(0xff2E2E2E))),
                child: Stack(
                  children: <Widget>[
                    TextField(
                      focusNode: focus,
                      controller: _searchController,
                      style: TextStyle(color: Colors.white, fontSize: s42),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: index == 0 ? 'ค้นหาโรงเรียน' : 'ค้นหาเพื่อนๆ',
                        contentPadding: EdgeInsets.all(4.8),
                        hintStyle:
                            TextStyle(color: Colors.white60, fontSize: s42),
                      ),
                      onTap: () => setState(() => isSearching = true),
                    ),
                    isSearching
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(right: 4.2),
                                child: Icon(Icons.clear,
                                    color: Colors.grey, size: s46),
                              ),
                              onTap: () {
                                _searchController.clear();
                                focus.unfocus();
                                setState(() => isSearching = false);
                              },
                            ))
                        : SizedBox()
                  ],
                ),
              ),
            ),
            GestureDetector(
                child: Container(
                    margin: EdgeInsets.only(right: screenWidthDp / 64),
                    width: screenWidthDp / 10,
                    height: screenWidthDp / 10,
                    child: index != 0
                        ? Padding(
                            padding: EdgeInsets.all(5.4),
                            child: SvgPicture.asset('assets/location-icon.svg',
                                fit: BoxFit.contain, color: Colors.white),
                          )
                        : Icon(Icons.people, size: s54, color: Colors.white)),
                onTap: () => onTap(index == 0 ? 1 : 0))
          ],
        ),
        // Container(
        //     height: screenWidthDp / 10,
        //     width: screenWidthDp,
        //     child: ListView(
        //       physics: AlwaysScrollableScrollPhysics(),
        //       scrollDirection: Axis.horizontal,
        //       children: <Widget>[
        //         SizedBox(width: screenWidthDp / 64),
        //         Container(
        //           width: screenWidthDp / 5,
        //           child: GestureDetector(
        //             onTap: () => onTap(0),
        //             child: Container(
        //               decoration: BoxDecoration(
        //                   border: Border.all(color: Color(0xfff26A4FF)),
        //                   borderRadius: BorderRadius.circular(screenWidthDp),
        //                   color:
        //                       index == 0 ? Color(0xfff26A4FF) : Colors.black),
        //               child: Text(
        //                 'สถานที่',
        //                 style: TextStyle(
        //                   color: index == 0 ? Colors.white : Color(0xfff26A4FF),
        //                   fontSize: s52,
        //                 ),
        //                 textAlign: TextAlign.center,
        //               ),
        //             ),
        //           ),
        //         ),
        //         SizedBox(width: screenWidthDp / 50),
        //         Container(
        //             width: screenWidthDp / 5,
        //             child: GestureDetector(
        //                 onTap: () => onTap(1),
        //                 child: Container(
        //                     decoration: BoxDecoration(
        //                         border: Border.all(color: Color(0xfff26A4FF)),
        //                         borderRadius:
        //                             BorderRadius.circular(screenWidthDp),
        //                         color: index == 1
        //                             ? Color(0xfff26A4FF)
        //                             : Colors.black),
        //                     child: Text('ผู้คน',
        //                         style: TextStyle(
        //                           color: index == 1
        //                               ? Colors.white
        //                               : Color(0xfff26A4FF),
        //                           fontSize: s52,
        //                         ),
        //                         textAlign: TextAlign.center))))
        //       ],
        //     ))
      ],
    );
  }
}
