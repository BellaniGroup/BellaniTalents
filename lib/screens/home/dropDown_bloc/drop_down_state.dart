part of 'drop_down_bloc.dart';

abstract class DropDownState extends Equatable {
  const DropDownState();
  
}

class DropDownInitial extends DropDownState {
  @override
  List<Object?> get props => [];
}

class GotAccountState extends DropDownState {
  final Account account;
  final Dashboard? dashboard;

  const GotAccountState(this.account, this.dashboard);

  @override
  List<Object?> get props => [account, dashboard];
}
