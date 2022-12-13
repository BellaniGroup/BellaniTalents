part of 'gmaps_bloc.dart';

abstract class GmapsState {
  const GmapsState();
}

class GmapsInitial extends GmapsState {
  @override
  List<Object?> get props => [];
}

class NoMapState extends GmapsState {
  @override
  List<Object?> get props => [];
}

class TalentsLoadedState extends GmapsState {
  final List<Talents> talents;
  final Set<Marker> markers;


  const TalentsLoadedState(this.talents, this.markers);

  @override
  List<Object?> get props => [talents, markers];
}
