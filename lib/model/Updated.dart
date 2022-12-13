
import 'dart:convert';

Updated updatedApiFromJson(String str) => Updated.fromJson(json.decode(str));
String updatedApiToJson(Updated data) => json.encode(data.toJson());

class Updated {
  Updated({
    required this.status,
    required this.version,
  });
  late final String status;
  late final String version;
  
  Updated.fromJson(Map<String, dynamic> json){
    status = json['status'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['version'] = version;
    return _data;
  }
}