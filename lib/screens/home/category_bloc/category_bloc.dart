import 'package:bellani_talents_market/model/CategoriesResponse.dart';
import 'package:bellani_talents_market/model/Talents.dart';
import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
final ApiService _apiService;
  List<String> categories = [];

  CategoryBloc(this._apiService) : super(CategoryInitial()) {

        on<LoadCategoriesEvent>((event, emit) async {
          // emit (CategoryInitial());
      final activity = await _apiService.getCategories(event.selectedService);
      setCategory(activity.categories);
      emit(CategoryLoadedState(categories, activity.talents));
    });
    
  }

    void setCategory(List<Categories> getCategories) {
      categories.clear();
    for (var i = 0; i < getCategories.length; i++) {
      categories.add(getCategories[i].category);
    }
  }
}
