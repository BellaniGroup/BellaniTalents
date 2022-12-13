part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

}

class SearchTalentEvent extends SearchEvent {
  String searchText;
  SearchTalentEvent(this.searchText);

  @override
  List<Object?> get props => [];

}

class SearchServiceEvent extends SearchEvent {
  String searchText;
  SearchServiceEvent(this.searchText);

  @override
  List<Object?> get props => [];

}
