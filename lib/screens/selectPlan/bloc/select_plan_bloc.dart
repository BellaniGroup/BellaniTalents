import 'package:bellani_talents_market/model/TalentRegisterModel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../services/ApiService.dart';
part 'select_plan_event.dart';
part 'select_plan_state.dart';

class SelectPlanBloc extends Bloc<SelectPlanEvent, SelectPlanState> {
  final ApiService _apiService;

  SelectPlanBloc(this._apiService) : super(SelectPlanInitial()) {
    on<RegisterTalent>((event, emit) async {
      final activity =
          await _apiService.registerTalent(event.talentRegisterdata);
      emit(TalentRegisteredState(activity.status));
    });
  }
}
