import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'agent_event.dart';
part 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  AgentBloc(ApiService of) : super(AgentInitial()) {
    on<AgentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
