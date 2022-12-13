import 'dart:convert';

Success successApiFromJson(String str) => Success.fromJson(json.decode(str));
String successApiToJson(Success data) => json.encode(data.toJson());

class Success {
  Success({
    required this.status,
  });
  late final String status;
  
  Success.fromJson(Map<String, dynamic> json){
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    return _data;
  }
}