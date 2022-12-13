import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bellaniwallet_event.dart';
part 'bellaniwallet_state.dart';

class BellaniwalletBloc extends Bloc<BellaniwalletEvent, BellaniwalletState> {
  BellaniwalletBloc(ApiService of) : super(BellaniwalletInitial()) {
    on<BellaniwalletEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
