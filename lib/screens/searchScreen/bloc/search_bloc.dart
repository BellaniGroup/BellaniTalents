import 'package:bellani_talents_market/model/SearchTalent.dart';
import 'package:bellani_talents_market/model/Talents.dart';
import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/SearchServiceResponse.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService _apiService;
  
  SearchBloc(this._apiService) : super(SearchInitial()) {
    on<SearchTalentEvent>((event, emit) async {

      final activity = await _apiService.searchTalents(event.searchText);
      emit(SearchedTalentState(activity.talents));

    });

    on<SearchServiceEvent>((event, emit) async {

      final activity = await _apiService.searchServices(event.searchText);
      emit(SearchedServiceState(activity.services));

    });
  }
}
