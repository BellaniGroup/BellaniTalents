import 'package:bellani_talents_market/model/GetTalentsResponse.dart';
import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../model/Talents.dart';

part 'gmaps_event.dart';
part 'gmaps_state.dart';

class GmapsBloc extends Bloc<GmapsEvent, GmapsState> {
  final ApiService _apiService;
  List<Talents> talents = [];
  Set<Marker> markers = Set();

  GmapsBloc(this._apiService) : super(GmapsInitial()) {
    on<LoadMarkersEvent>((event, emit) async {
      emit(NoMapState());
      final activity = await _apiService.getTalents(
          event.selectedService, event.selectedCategory).then((value) {
             setTalents(value.talents);
      setMarkers(talents);
          },);
     
      emit(TalentsLoadedState(talents, markers));
    });
    on<LoadMarkersEventService>((event, emit) async {
      emit(NoMapState());
      final activity = await _apiService.getCategories(
          event.selectedService).then((value) {
             setTalents(value.talents);
      setMarkers(talents);
          },);
     
      emit(TalentsLoadedState(talents, markers));
    });
    on<LoadMarkersEventInitial>((event, emit) async {
      emit(NoMapState());
      final activity = await _apiService.getServices().then((value) {
             setTalents(value.talents);
      setMarkers(talents);
          },);
     
      emit(TalentsLoadedState(talents, markers));
    });
  }

  void setTalents(List<Talents> getTalents) {
    talents.clear();
    for (var i = 0; i < getTalents.length; i++) {
      talents.add(getTalents[i]);
    }
  }

    void setMarkers(List<Talents> talents) {
      markers.clear();
    for (var i = 0; i < talents.length; i++) {
      Marker resultMarker = Marker(
          onTap: () {
            // clickedId = talents[i].photo;
            // var s = clickedId;
          },
          markerId: MarkerId(talents[i].id),
          infoWindow:
              InfoWindow(title: talents[i].stageName, snippet: talents[i].photo),
          position: LatLng(
              double.parse(talents[i].lat), double.parse(talents[i].lng)),
          icon: BitmapDescriptor.defaultMarker);

      markers.add(resultMarker);
    }
  }
}
