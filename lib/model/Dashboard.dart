class Dashboard {
  Dashboard({
    required this.phoneClicks,
    required this.whatsappClicks,
    required this.bmClicks,
    required this.fbClicks,
    required this.instaClicks,
    required this.bcardClicks,
    required this.portfolioClicks,
    required this.priceTagClicks,
    required this.payNowClicks,
    required this.shareClicks,
  });
  late final String phoneClicks;
  late final String whatsappClicks;
  late final String bmClicks;
  late final String fbClicks;
  late final String instaClicks;
  late final String bcardClicks;
  late final String portfolioClicks;
  late final String priceTagClicks;
  late final String payNowClicks;
  late final String shareClicks;
  
  Dashboard.fromJson(Map<String, dynamic> json){
    phoneClicks = json['phone_clicks'];
    whatsappClicks = json['whatsapp_clicks'];
    bmClicks = json['bm_clicks'];
    fbClicks = json['fb_clicks'];
    instaClicks = json['insta_clicks'];
    bcardClicks = json['bcard_clicks'];
    portfolioClicks = json['portfolio_clicks'];
    priceTagClicks = json['price_tag_clicks'];
    payNowClicks = json['pay_now_clicks'];
    shareClicks = json['share_clicks'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['phone_clicks'] = phoneClicks;
    _data['whatsapp_clicks'] = whatsappClicks;
    _data['bm_clicks'] = bmClicks;
    _data['fb_clicks'] = fbClicks;
    _data['insta_clicks'] = instaClicks;
    _data['bcard_clicks'] = bcardClicks;
    _data['portfolio_clicks'] = portfolioClicks;
    _data['price_tag_clicks'] = priceTagClicks;
    _data['pay_now_clicks'] = payNowClicks;
    _data['share_clicks'] = shareClicks;
    return _data;
  }
}