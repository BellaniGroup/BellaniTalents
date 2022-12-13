part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable{
    const HomeEvent();

}

class GetAssetsEvent extends HomeEvent {
  String? selectedLang;
  GetAssetsEvent(this.selectedLang);

  @override
  List<Object?> get props => [];

}

class LoadTypesEvent extends HomeEvent {
    String selectedCity, selectedCategory;
  LoadTypesEvent(this.selectedCity, this.selectedCategory);

  @override
  List<Object?> get props => [];

}
