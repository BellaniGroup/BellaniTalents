import 'dart:collection';
import 'package:bellani_talents_market/model/Talents.dart';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';
import '../model/MarqueeWidget.dart';
import '../services/FirebaseDynamicLinkService.dart';

enum SocialMedia { facebook, instagram, whatsapp, linkedin, call, portfolio }

class ProfileView extends StatefulWidget {
  Talents selectedTalent;
  ProfileView({Key? key, required Talents this.selectedTalent})
      : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState(selectedTalent);
}

class _ProfileViewState extends State<ProfileView> {
  Talents selectedTalent;
  _ProfileViewState(Talents this.selectedTalent);

  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  int selectedYear = 0, selectedMonth = 0, _selectedDate = 32;
  late DateTime firstDayOfMonth, lastDayOfMonth, firstMonth, lastMonth;
  bool _yearSelected = false, _monthSelected = false;
  bool focused = false;
  bool _show = false;
  List<DateTime> days = [];
  var instaUrl = "",
      facebookUrl = "",
      linkedinUrl = "",
      call = "",
      whatsappUrl = "",
      portfolioUrl = "";
  var photo =
      "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=";
  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> years = [2022, 2023, 2024, 2025, 2026];
  final Map<String, String> selectedValue = HashMap();
  // Account user = AccountApiFromJson(sp.getString("userdata")!);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    // _textController.text = user.phone;
  }

  void onChange() {
    String searchText = _textController.text;
    bool hasFocus = _textFocus.hasFocus;

    if (hasFocus) {
      setState(() {
        // focused = true;
        // if (_textController.text == user.phone) {
        //   _textController.text = "";
        // }
      });
    } else {
      setState(() {
        focused = false;
      });
    }
  }

  Widget? _showBottomSheet() {
    if (_show) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
              height: 180,
              color: CustomTheme.appColors.primaryColor50,
              child: ListView.builder(
                  itemCount: 6,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 30,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: CustomTheme.appColors.primaryColor,
                      ),
                      child: Row(children: [
                        Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.all(5),
                          child: SvgPicture.asset("assets/name_tag.svg"),
                        ),
                        Expanded(
                            child: Text(
                          "English",
                          textAlign: TextAlign.center,
                        )),
                        Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.all(5),
                          child: SvgPicture.asset("assets/tick_maroon.svg"),
                        ),
                      ]),
                    );
                  }));
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
        ],
        child: Scaffold(
            backgroundColor: CustomTheme.appColors.primaryColor,
            bottomSheet: _showBottomSheet(),
            body: GestureDetector(
              onTap: () {
                setState(() {
                  _show = false;
                });
              },
              child: SafeArea(
                child: Container(
                  color: CustomTheme.appColors.secondaryColor,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                color: CustomTheme.appColors.primaryColor,
                                padding: EdgeInsets.all(14),
                                child: SvgPicture.asset(
                                    "assets/left_arrow_white.svg")),
                          ),
                          Expanded(
                            child: Center(
                              child: MarqueeWidget(
                                animationDuration: Duration(milliseconds: 1000),
                                pauseDuration: Duration(milliseconds: 800),
                                backDuration: Duration(milliseconds: 1000),
                                child: Text(
                                  selectedTalent.service +
                                      " - " +
                                      selectedTalent.category,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                          )
                        ]),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CustomTheme.appColors.white,
                            image: DecorationImage(
                              image: NetworkImage(selectedTalent.photo),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: CustomTheme.appColors.primaryColor50
                                    .withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset: Offset(
                                    0, 0.1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6)),
                                child: Container(
                                  height: 86,
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Column(children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6)),
                                              child: Container(
                                                height: 30,
                                                color: CustomTheme
                                                    .appColors.primaryColor50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Container(
                                                          height: 14,
                                                          width: 14,
                                                          child: SvgPicture.asset(
                                                              "assets/star_icon.svg")),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Container(
                                                          height: 14,
                                                          width: 14,
                                                          child: SvgPicture.asset(
                                                              "assets/star_icon.svg")),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Container(
                                                          height: 14,
                                                          width: 14,
                                                          child: SvgPicture.asset(
                                                              "assets/star_icon.svg")),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Container(
                                                          height: 14,
                                                          width: 14,
                                                          child: SvgPicture.asset(
                                                              "assets/star_icon.svg")),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Container(
                                                          height: 14,
                                                          width: 14,
                                                          child: SvgPicture.asset(
                                                              "assets/star_icon.svg")),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            child: Container(
                                              height: 30,
                                              color: CustomTheme
                                                  .appColors.primaryColor50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              alignment: Alignment.center,
                                              child: MarqueeWidget(
                                                animationDuration: Duration(
                                                    milliseconds: 1000),
                                                pauseDuration:
                                                    Duration(milliseconds: 800),
                                                backDuration: Duration(
                                                    milliseconds: 1000),
                                                child: Text(
                                                  "@" + selectedTalent.username,
                                                  style: TextStyle(
                                                      color: CustomTheme
                                                          .appColors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6)),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (_show) {
                                                  _show = false;
                                                } else {
                                                  _show = true;
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              color: CustomTheme
                                                  .appColors.secondaryColor,
                                              child: Padding(
                                                padding: EdgeInsets.all(2),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: SvgPicture.asset(
                                                      "assets/languages.svg"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: SvgPicture.asset(
                                                  "assets/report.svg"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: CustomTheme
                                    //         .appColors.black
                                    //         .withOpacity(0.3),
                                    //     spreadRadius: 3,
                                    //     blurRadius: 3,
                                    //     offset: Offset(0,
                                    //         -5), // changes position of shadow
                                    //   ),
                                    // ],
                                    ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                    // bottomLeft: Radius.circular(6),
                                    // bottomRight: Radius.circular(6)
                                  ),
                                  child: Container(
                                    height: 115,
                                    // margin: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: CustomTheme
                                      //         .appColors.primaryColor50
                                      //         .withOpacity(0.3),
                                      //     spreadRadius: 3,
                                      //     blurRadius: 3,
                                      //     offset: Offset(
                                      //         0, 7), // changes position of shadow
                                      //   ),
                                      // ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    call = "tel:" +
                                                        selectedTalent
                                                            .primaryPhoneCode +
                                                        selectedTalent
                                                            .primaryPhone;
                                                    share(SocialMedia.call);
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/call.svg")),
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    whatsappUrl =
                                                        "https://api.whatsapp.com/send?phone=${selectedTalent.primaryPhoneCode + selectedTalent.primaryPhone}";
                                                    share(SocialMedia.whatsapp);
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/whatsapp.svg")),
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/bellani_messenger.svg")),
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    facebookUrl =
                                                        selectedTalent.facebook;
                                                    share(SocialMedia.facebook);
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/facebook.svg")),
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    instaUrl = selectedTalent
                                                        .instagram;
                                                    share(
                                                        SocialMedia.instagram);
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/insta.svg")),
                                                  ),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    topRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    //     call = "tel:" + selectedTalent.photo;
                                                    // share(SocialMedia.call);
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/business_card.svg")),
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    topRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    portfolioUrl =
                                                        selectedTalent
                                                            .portfolio;
                                                    share(
                                                        SocialMedia.portfolio);
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/talent_info.svg")),
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    topRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, "/products");
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/rupee_tag.svg")),
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    topRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        "/paymentDetailsScreen");
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/rupee.svg")),
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                width: 5,
                                              ),
                                              Expanded(
                                                  child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    topRight:
                                                        Radius.circular(6)),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    String link =
                                                        await FirebaseDynamicLinkService
                                                            .createDynamicLink(
                                                                true,
                                                                selectedTalent
                                                                    .id,
                                                                selectedTalent
                                                                    .photo);

                                                    Share.share(link);
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Center(
                                                        child: SvgPicture.asset(
                                                            "assets/share.svg")),
                                                  ),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Future share(SocialMedia socialPlatform) async {
    final urls = {
      SocialMedia.instagram: instaUrl,
      SocialMedia.facebook: facebookUrl,
      SocialMedia.linkedin: linkedinUrl,
      SocialMedia.call: call,
      SocialMedia.whatsapp: whatsappUrl,
      SocialMedia.portfolio: portfolioUrl
    };

    final url = urls[socialPlatform];

    // if (await canLaunch("https://www.instagram.com/")) {
    await launch(url!);
    // }else{
    // log("message");
    // }
  }
}
