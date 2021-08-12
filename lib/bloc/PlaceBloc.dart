import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:scrap/models/PlaceModel.dart';

@immutable
abstract class PlaceEvent {
  final PlaceModel place;
  PlaceEvent(this.place);
}

class PlaceBloc extends Bloc<PlaceEvent, PlaceModel> {
  @override
  PlaceModel get initialState => PlaceModel();

  @override
  Stream<PlaceModel> mapEventToState(PlaceEvent event) async* {
    switch (event.runtimeType) {
      case SearchPlace:
        yield event.place;
        break;
    }
  }
}

class SearchPlace extends PlaceEvent {
  SearchPlace(PlaceModel place) : super(place);
}
