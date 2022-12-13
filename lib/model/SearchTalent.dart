
import 'dart:convert';
import 'package:bellani_talents_market/model/Talents.dart';

SearchTalentResponse searchTalentsApiFromJson(String str) => SearchTalentResponse.fromJson(json.decode(str));
String searchTalentsApiToJson(SearchTalentResponse data) => json.encode(data.toJson());


class SearchTalentResponse {
  SearchTalentResponse({
    required this.talents,
    required this.status,
  });
  late final List<Talents> talents;
  late final String status;
  
  SearchTalentResponse.fromJson(Map<String, dynamic> json){
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
