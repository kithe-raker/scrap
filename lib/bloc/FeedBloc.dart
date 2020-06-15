// import 'package:bloc/bloc.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:scrap/function/authentication/AuthenService.dart';
// import 'package:scrap/models/ScrapModel.dart';
// import 'package:scrap/services/LoadStatus.dart';
// import 'package:scrap/stream/FeedStream.dart';

// enum FeedEvent { init, loadMore }

// class FeedBloc extends Bloc<FeedEvent, double> {
//   @override
//   double get initialState => 0.0;

//   @override
//   Stream<double> mapEventToState(FeedEvent event) async* {
//     switch (event) {
//       case FeedEvent.init:
//         if (feed.scraps.length < 1) {
//           loadStatus.feedStatus.add(true);
//           var transacs = {};
//           List<String> docId = [];
//           var ref = FirebaseDatabase.instance
//               .reference()
//               .child('scraps')
//               .orderByChild('point')
//               .limitToFirst(9);
//           DataSnapshot data = await ref.once();
//           if (data.value?.length != null && data.value.length > 0) {
//             data.value.forEach((key, value) {
//               docId.add(value['id']);
//               transacs[value['id']] = ScrapTransaction.fromJSON(value);
//             //  (state < value['point'] )
//             });
//           }
//           docId.removeWhere((id) => id == null);
//           if (docId.length > 0) {
//             var docs = await fireStore
//                 .collectionGroup('ScrapDailys-th')
//                 .where('id', whereIn: docId)
//                 .getDocuments();
//             docs.documents.forEach((scrap) {
//               feed.addScrap(ScrapModel.fromJSON(scrap.data,
//                   transaction: transacs[scrap.documentID]));
//             });
//           }
//           loadStatus.feedStatus.add(false);
//           feed.scraps.forEach((element) => print(element.transaction.point));
//           print('------');
//         }
//         break;
//       case FeedEvent.loadMore:
//         var lessPoint = state.last.transaction.point + 0.1;
//         var transacs = {};
//         List<String> docId = [];
//         loadStatus.feedStatus.add(true);
//         var ref = FirebaseDatabase.instance
//             .reference()
//             .child('scraps')
//             .orderByChild('point')
//             .startAt(lessPoint)
//             .limitToFirst(1);
//         DataSnapshot data = await ref.once();
//         if (data.value?.length != null && data.value.length > 0) {
//           data.value.forEach((key, value) {
//             docId.add(value['id']);
//             transacs[value['id']] = ScrapTransaction.fromJSON(value);
//           });
//         }
//         docId.removeWhere((id) => id == null);
//         if (docId.length > 0) {
//           var docs = await fireStore
//               .collectionGroup('ScrapDailys-th')
//               .where('id', whereIn: docId)
//               .getDocuments();
//           docs.documents.forEach((scrap) {
//             feed.addScrap(ScrapModel.fromJSON(scrap.data,
//                 transaction: transacs[scrap.documentID]));
//           });
//           feed.scraps.forEach((element) => print(element.text));
//           print('------');
//           loadStatus.feedStatus.add(false);
//         } else {
//           print('empty');
//         }
//         yield state;
//         break;
//     }
//   }
// }
