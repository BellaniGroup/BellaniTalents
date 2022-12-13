part of 'agent_bloc.dart';

abstract class AgentState extends Equatable {
  const AgentState();
  
  @override
  List<Object> get props => [];
}

class AgentInitial extends AgentState {}
