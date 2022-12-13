part of 'talents_bloc.dart';

abstract class TalentsEvent extends Equatable {
  const TalentsEvent();
  
}

class LoadTalentsEvent extends TalentsEvent {
  String selectedCity, selectedCategory, selectedType;
  LoadTalentsEvent(this.selectedCity, this.selectedCategory, this.selectedType);
  @override
  List<Object?> get props => [];

}
