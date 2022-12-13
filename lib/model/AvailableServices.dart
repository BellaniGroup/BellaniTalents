
import 'dart:convert';

AvailableServices getAvailableServicesApiFromJson(String str) => AvailableServices.fromJson(json.decode(str));
String getAvailableServicesApiToJson(AvailableServices data) => json.encode(data.toJson());

class AvailableServices {
  AvailableServices({
    required this.services,
    required this.status,
  });
  late final List<String> services;
  late final String status;
  
  AvailableServices.fromJson(Map<String, dynamic> json){
    services = List.castFrom<dynamic, String>(json['services']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['services'] = services;
    _data['status'] = status;
    return _data;
  }
}