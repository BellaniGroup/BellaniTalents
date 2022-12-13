part of 'select_plan_bloc.dart';

abstract class SelectPlanState extends Equatable {
  const SelectPlanState();
}

class SelectPlanInitial extends SelectPlanState {
  @override
  List<Object> get props => [];
}

class TalentRegisteredState extends SelectPlanState {
  String status;
  TalentRegisteredState(this.status);

  @override
  List<Object> get props => [status];
}
