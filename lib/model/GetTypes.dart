import 'dart:convert';

GetTypes getTypeApiFromJson(String str) => GetTypes.fromJson(json.decode(str));
String getTypeApiToJson(GetTypes data) => json.encode(data.toJson());

class GetTypes {
  GetTypes({
    required this.types,
    required this.status,
  });
  late final List<Types> types;
  late final String status;
  
  GetTypes.fromJson(Map<String, dynamic> json){
    types = List.from(json['types']).map((e)=>Types.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['types'] = types.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class Types {
  Types({
    required this.type,
  });
  late final String type;
  
  Types.fromJson(Map<String, dynamic> json){
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    return _data;
  }
}