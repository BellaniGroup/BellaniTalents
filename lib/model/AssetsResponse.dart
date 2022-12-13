import 'dart:convert';

AssetsResponse getAssetsApiFromJson(String str) => AssetsResponse.fromJson(json.decode(str));
String getAssetsApiToJson(AssetsResponse data) => json.encode(data.toJson());

class AssetsResponse {
  AssetsResponse({
    required this.assets,
    required this.texts,
    required this.status,
  });
  late final List<Assets> assets;
  late final List<Texts> texts;
  late final String status;
  
  AssetsResponse.fromJson(Map<String, dynamic> json){
    assets = List.from(json['assets']).map((e)=>Assets.fromJson(e)).toList();
    texts = List.from(json['texts']).map((e)=>Texts.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['assets'] = assets.map((e)=>e.toJson()).toList();
    _data['texts'] = texts.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class Assets {
  Assets({
    required this.id,
    required this.title,
    required this.url,
  });
  late final String id;
  late final String title;
  late final String url;
  
  Assets.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['url'] = url;
    return _data;
  }
}

class Texts {
  Texts({
    required this.id,
    required this.title,
    required this.text,
    required this.size,
  });
  late final String id;
  late final String title;
  late final String text;
  late final String size;
  
  Texts.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    text = json['text'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['text'] = text;
    _data['size'] = size;
    return _data;
  }
}