import 'dart:math';

import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final ApiService _apiService;

  OtpBloc(this._apiService) : super(OtpInitial()) {
    on<RegisterUser>((event, emit) async {
      final activity = await _apiService.registerUser(
      event.username, event.name, event.mobile, event.email, event.dob, event.gender, event.locale, event.code
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', activity.token);
      emit(UserRegisteredState(activity.token));
    });

    // on<LoginUserEvent>((event, emit) async {
    //   final activity = await _apiService.loginUser(event.username);
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString('token', activity.token);
    //   emit(LoggedInState(activity.token));
    // });

     on<UpdateUserNameEvent>((event, emit) async {
      final activity = await _apiService.updateUserName(event.token!, event.name);
      emit(UserUpdatedState(activity.status));
    });

      on<UpdateUserEmailEvent>((event, emit) async {
      final activity = await _apiService.updateUserEmail(event.token!, event.email);
      emit(UserUpdatedState(activity.status));
    });

     on<UpdateUserMobileEvent>((event, emit) async {
      final activity = await _apiService.updateUserMobile(event.token!, event.code, event.mobile, event.locale);
      emit(UserUpdatedState(activity.status));
    });

      on<CompanyRegister>((event, emit) async {
      final activity = await _apiService.registerCompany(event.token,
      event.username, event.name, event.mobile, event.email, event.dob, event.gender, event.locale, event.code
      );
      emit(CompanyRegisteredState(activity.status));
    });
  }
}
