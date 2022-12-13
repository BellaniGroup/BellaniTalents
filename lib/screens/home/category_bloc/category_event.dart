part of 'category_bloc.dart';

abstract class CategoryEvent {
  const CategoryEvent();
 
}

class LoadCategoriesEvent extends CategoryEvent {
  String selectedService;
  LoadCategoriesEvent(this.selectedService);

  @override
  List<Object?> get props => [selectedService];

}
