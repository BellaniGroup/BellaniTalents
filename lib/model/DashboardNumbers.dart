import 'dart:convert';
import 'Dashboard.dart';

DashboardNumbers getDashboardNumbersApiFromJson(String str) => DashboardNumbers.fromJson(json.decode(str));
String getDashboardNumbersApiToJson(DashboardNumbers data) => json.encode(data.toJson());

class DashboardNumbers {
  DashboardNumbers({
    required this.dashboard,
    required this.status,
  });
  late final Dashboard dashboard;
  late final String status;
  
  DashboardNumbers.fromJson(Map<String, dynamic> json){
    dashboard = Dashboard.fromJson(json['dashboard']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dashboard'] = dashboard.toJson();
    _data['status'] = status;
    return _data;
  }
}
