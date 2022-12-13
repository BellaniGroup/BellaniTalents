
import 'dart:convert';

TalentRegisterResponse TalentRegisterResponseApiFromJson(String str) => TalentRegisterResponse.fromJson(json.decode(str));
String TalentRegisterResponseApiToJson(TalentRegisterResponse data) => json.encode(data.toJson());

class TalentRegisterResponse {
  TalentRegisterResponse({
    required this.status,
    required this.talent_id,
  });
  late final String status;
  late final String talent_id;
  
  TalentRegisterResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    talent_id = json['talent_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['talent_id'] = talent_id;
    return _data;
  }
}