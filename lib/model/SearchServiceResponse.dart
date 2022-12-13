
import 'dart:convert';

SearchServiceResponse searchServiceApiFromJson(String str) => SearchServiceResponse.fromJson(json.decode(str));
String searchServiceApiToJson(SearchServiceResponse data) => json.encode(data.toJson());

class SearchServiceResponse {
  SearchServiceResponse({
    required this.services,
    required this.status,
  });
  late final List<SearchedServices> services;
  late final String status;
  
  SearchServiceResponse.fromJson(Map<String, dynamic> json){
    services = List.from(json['services']).map((e)=>SearchedServices.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['services'] = services.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class SearchedServices {
  SearchedServices({
    required this.category,
    required this.service,
  });
  late final String category;
  late final String service;
  
  SearchedServices.fromJson(Map<String, dynamic> json){
    category = json['category'];
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category'] = category;
    _data['service'] = service;
    return _data;
  }
}