import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_company_event.dart';
part 'add_company_state.dart';

class AddCompanyBloc extends Bloc<AddCompanyEvent, AddCompanyState> {
  AddCompanyBloc(ApiService of) : super(AddCompanyInitial()) {
    on<AddCompanyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
