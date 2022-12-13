import 'package:bellani_talents_market/model/Account.dart';
import 'package:bellani_talents_market/model/Dashboard.dart';
import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../main.dart';

part 'drop_down_event.dart';
part 'drop_down_state.dart';

class DropDownBloc extends Bloc<DropDownEvent, DropDownState> {
  final ApiService _apiService;

  DropDownBloc(this._apiService) : super(DropDownInitial()) {
    on<getProfileEvent>((event, emit) async {
      final profile = await _apiService.getProfile(event.token);
      insertInSp(profile.data);
      if (profile.data.talentId != "") {
        final dashboard = await _apiService.getDashboardNumbers(event.token);
        emit(GotAccountState(profile.data, dashboard.dashboard));
      } else {
        emit(GotAccountState(profile.data, null));
      }
    });
  }

  void insertInSp(Account account) {
    // encode / convert object into json string
    String user = AccountApiToJson(account);
    //save the data into sharedPreferences using key-value pairs
    sp.setString('userdata', user);
  }
}
