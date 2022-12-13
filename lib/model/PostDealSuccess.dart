
import 'dart:convert';

PostDealSuccess PostDealSuccessResponseApiFromJson(String str) => PostDealSuccess.fromJson(json.decode(str));
String PostDealSuccessResponseApiToJson(PostDealSuccess data) => json.encode(data.toJson());

class PostDealSuccess {
  PostDealSuccess({
    required this.status,
    required this.id,
  });
  late final String status;
  late final String id;
  
  PostDealSuccess.fromJson(Map<String, dynamic> json){
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['id'] = id;
    return _data;
  }
}