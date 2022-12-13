part of 'select_plan_bloc.dart';

abstract class SelectPlanEvent extends Equatable {
  const SelectPlanEvent();
}

class RegisterTalent extends SelectPlanEvent {
  TalentRegisterModel talentRegisterdata;
  RegisterTalent(this.talentRegisterdata);

  @override
  List<Object?> get props => [];
}
