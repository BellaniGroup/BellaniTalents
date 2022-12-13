import 'dart:convert';

ImageUploaded ImageUploadedApiFromJson(String str) => ImageUploaded.fromJson(json.decode(str));
String ImageUploadedApiToJson(ImageUploaded data) => json.encode(data.toJson());

class ImageUploaded {
  ImageUploaded({
    required this.url,
    required this.status,
  });
  late final String url;
  late final String status;
  
  ImageUploaded.fromJson(Map<String, dynamic> json){
    url = json['url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['url'] = url;
    _data['status'] = status;
    return _data;
  }
}