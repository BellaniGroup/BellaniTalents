import 'dart:developer';

import 'package:bellani_talents_market/model/AssetsResponse.dart';
import 'package:bellani_talents_market/model/CategoriesResponse.dart';
import 'package:bellani_talents_market/model/ServicesResponse.dart';
import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../model/GetTypes.dart';
import '../../../model/Talents.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiService _apiService;

  HomeBloc(this._apiService) : super(HomeInitial()) {
    on<GetAssetsEvent>((event, emit) async {
      final PackageInfo info = await PackageInfo.fromPlatform();
      var currentVersion = info.version;

      emit(HomeLoadingState());
      final updated = await _apiService.getVersion();
      if (updated.status == "success") {
        if (updated.version == currentVersion) {
          final activity = await _apiService.getAssets(event.selectedLang);
          final service = await _apiService.getServices();
          emit(HomeLoadedState(activity.assets, activity.texts,
              service.services, service.talents));
        } else {
          emit(UpdateAppState());
        }
      }
    });

    on<LoadTypesEvent>((event, emit) async {
      emit(HomeLoadingState());
      final activity = await _apiService.getTypes(
          event.selectedCity, event.selectedCategory);
      emit(HomeTypesLoadedState(activity.types));
    });
  }
}
