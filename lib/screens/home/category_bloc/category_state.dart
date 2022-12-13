part of 'category_bloc.dart';

abstract class CategoryState {
  const CategoryState();
  
}

class CategoryInitial extends CategoryState {

   @override
  List<Object> get props => [];
}

class CategoryLoadedState extends CategoryState {
  final List<String> categories;
  final List<Talents> talents;

  const CategoryLoadedState(this.categories, this.talents);
  
  @override
  List<Object?> get props => [categories];
}