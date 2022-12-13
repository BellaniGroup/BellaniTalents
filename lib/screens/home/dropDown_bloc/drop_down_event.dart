part of 'drop_down_bloc.dart';

abstract class DropDownEvent extends Equatable {
  const DropDownEvent();

}


class DropDownEventInitial extends DropDownEvent {

  @override
  List<Object?> get props => [];

}

class getProfileEvent extends DropDownEvent {
    String token;
  getProfileEvent(this.token);

  @override
  List<Object?> get props => [token];

}
