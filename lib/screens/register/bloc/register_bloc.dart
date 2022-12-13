import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/ApiService.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ApiService _apiService;

  RegisterBloc(this._apiService) : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async {
      
    }
    );
  }
}
