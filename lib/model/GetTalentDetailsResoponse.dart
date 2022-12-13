import 'dart:convert';
import 'Talents.dart';

GetTalentDetailsResponse getTalentDetailsResponseApiFromJson(String str) => GetTalentDetailsResponse.fromJson(json.decode(str));
String getTalentDetailsResponseApiToJson(GetTalentDetailsResponse data) => json.encode(data.toJson());

class GetTalentDetailsResponse {
  GetTalentDetailsResponse({
    required this.talentDetails,
    required this.status,
  });
  late final List<Talents> talentDetails;
  late final String status;
  
  GetTalentDetailsResponse.fromJson(Map<String, dynamic> json){
    talentDetails = List.from(json['talent_details']).map((e)=>Talents.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['talent_details'] = talentDetails.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}
