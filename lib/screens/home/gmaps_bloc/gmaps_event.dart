part of 'gmaps_bloc.dart';

abstract class GmapsEvent {
  const GmapsEvent();

}

class LoadMarkersEventInitial extends GmapsEvent {

  @override
  List<Object?> get props => [];

}

class LoadMarkersEventService extends GmapsEvent {
    String selectedService;
  LoadMarkersEventService(this.selectedService);

  @override
  List<Object?> get props => [selectedService];

}

class LoadMarkersEvent extends GmapsEvent {
    String selectedService, selectedCategory;
  LoadMarkersEvent(this.selectedService, this.selectedCategory);

  @override
  List<Object?> get props => [selectedService, selectedCategory];

}
