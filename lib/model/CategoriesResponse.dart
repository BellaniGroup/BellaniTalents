
import 'dart:convert';

import 'Talents.dart';

CategoriesResponse getCategoriesApiFromJson(String str) => CategoriesResponse.fromJson(json.decode(str));
String getCategoriesApiToJson(CategoriesResponse data) => json.encode(data.toJson());

class CategoriesResponse {
  CategoriesResponse({
    required this.categories,
    required this.talents,
    required this.status,
  });
  late final List<Categories> categories;
  late final List<Talents> talents;
  late final String status;
  
  CategoriesResponse.fromJson(Map<String, dynamic> json){
    categories = List.from(json['categories']).map((e)=>Categories.fromJson(e)).toList();
    talents = List.from(json['talents']).map((e)=>Talents.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories.map((e)=>e.toJson()).toList();
    _data['talents'] = talents.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class Categories {
  Categories({
    required this.category,
  });
  late final String category;
  
  Categories.fromJson(Map<String, dynamic> json){
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category;
    return _data;
  }
}
