part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  
}

class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchedTalentState extends SearchState { 
  
   final List<Talents> searchedtalents;

  const SearchedTalentState(this.searchedtalents);

  @override
  List<Object?> get props => [this.searchedtalents];
}

class SearchedServiceState extends SearchState { 
  
   final List<SearchedServices> searchedService;

  const SearchedServiceState(this.searchedService);

  @override
  List<Object?> get props => [this.searchedService];
}
