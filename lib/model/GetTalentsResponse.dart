import 'dart:convert';

import 'Talents.dart';

GetTalentsResponse getTalentsResponseApiFromJson(String str) => GetTalentsResponse.fromJson(json.decode(str));
String getTalentsResponseApiToJson(GetTalentsResponse data) => json.encode(data.toJson());

class GetTalentsResponse {
  GetTalentsResponse({
    required this.talents,
    required this.status,
  });
  late final List<Talents> talents;
  late final String status;
  
  GetTalentsResponse.fromJson(Map<String, dynamic> json){
    talents = List.from(json['talents']).map((e)=>Talents.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['talents'] = talents.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}
