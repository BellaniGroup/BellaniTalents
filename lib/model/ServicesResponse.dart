import 'dart:convert';

import 'Talents.dart';

ServicesResponse getServicesApiFromJson(String str) => ServicesResponse.fromJson(json.decode(str));
String getServicesApiToJson(ServicesResponse data) => json.encode(data.toJson());

class ServicesResponse {
  ServicesResponse({
    required this.services,
    required this.talents,
    required this.status,
  });
  late final List<Services> services;
  late final List<Talents> talents;
  late final String status;
  
  ServicesResponse.fromJson(Map<String, dynamic> json){
    services = List.from(json['services']).map((e)=>Services.fromJson(e)).toList();
    talents = List.from(json['talents']).map((e)=>Talents.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['services'] = services.map((e)=>e.toJson()).toList();
    _data['talents'] = talents.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class Services {
  Services({
    required this.service,
  });
  late final String service;
  
  Services.fromJson(Map<String, dynamic> json){
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['service'] = service;
    return _data;
  }
}
