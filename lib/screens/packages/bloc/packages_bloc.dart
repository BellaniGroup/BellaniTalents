import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'packages_event.dart';
part 'packages_state.dart';

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  PackagesBloc(ApiService of) : super(PackagesInitial()) {
    on<PackagesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
