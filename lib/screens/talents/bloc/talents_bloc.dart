import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/Talents.dart';
import '../../../services/ApiService.dart';

part 'talents_event.dart';
part 'talents_state.dart';

class TalentsBloc extends Bloc<TalentsEvent, TalentsState> {
  final ApiService _apiService;

  TalentsBloc(this._apiService) : super(TalentsInitial()) {

    on<LoadTalentsEvent>((event, emit) async {
  //     List<Talents> talents = [];
  //     emit(TalentsLoadingState());
  //     final activity = await _apiService.getTalents(event.selectedCity, event.selectedCategory, event.selectedType);
  //           talents.clear();
  //   for (var i = 0; i < activity.talents.length; i++) {
  //       talents.add(activity.talents[i]);
  // }     
  //  emit(TalentsLoadedState(talents));
    });

  }
}
