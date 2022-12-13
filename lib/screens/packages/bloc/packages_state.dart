part of 'packages_bloc.dart';

abstract class PackagesState extends Equatable {
  const PackagesState();
  
  @override
  List<Object> get props => [];
}

class PackagesInitial extends PackagesState {}
