part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable{
  const HomeState();
}

class HomeLoadingState extends HomeState {
  @override
  List<Object?> get props => [];
}

class UpdateAppState extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoadedState extends HomeState {
  final List<Assets> assets;
  final List<Services> services;
  final List<Talents> talents;
  final List<Texts> texts;

  const HomeLoadedState(this.assets, this.texts, this.services, this.talents);
  
  @override
  List<Object?> get props => [];
}

class HomeTypesLoadedState extends HomeState { 
  
   final List<Types> types;
  const HomeTypesLoadedState(this.types);

  @override
  List<Object?> get props => [];
}
