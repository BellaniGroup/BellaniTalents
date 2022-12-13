import 'dart:convert';

AvailableCategories getAvailableCategoriesApiFromJson(String str) => AvailableCategories.fromJson(json.decode(str));
String getAvailableCategoriesApiToJson(AvailableCategories data) => json.encode(data.toJson());

class AvailableCategories {
  AvailableCategories({
    required this.categories,
    required this.status,
  });
  late final List<String> categories;
  late final String status;
  
  AvailableCategories.fromJson(Map<String, dynamic> json){
    categories = List.castFrom<dynamic, String>(json['categories']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories;
    _data['status'] = status;
    return _data;
  }
}