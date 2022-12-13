part of 'talents_bloc.dart';

abstract class TalentsState extends Equatable {
  const TalentsState();
  
}

class TalentsInitial extends TalentsState {
  @override
  List<Object?> get props => [];
}

class TalentsLoadingState extends TalentsState {
  @override
  List<Object?> get props => [];
}

class TalentsLoadedState extends TalentsState {
  final List<Talents> talents;

  const TalentsLoadedState(this.talents);
  @override
  List<Object?> get props => [];
}
