import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:badges/badges.dart';
import 'package:bellani_talents_market/model/Account.dart';
import 'package:bellani_talents_market/model/AssetsResponse.dart';
import 'package:bellani_talents_market/model/CategoriesResponse.dart';
import 'package:bellani_talents_market/model/Dashboard.dart';
import 'package:bellani_talents_market/model/GetTalentsResponse.dart';
import 'package:bellani_talents_market/model/GetTypes.dart';
import 'package:bellani_talents_market/model/InnerShadow.dart';
import 'package:bellani_talents_market/model/MarqueeWidget.dart';
import 'package:bellani_talents_market/model/ServicesResponse.dart';
import 'package:bellani_talents_market/screens/home/category_bloc/category_bloc.dart';
import 'package:bellani_talents_market/screens/home/dropDown_bloc/drop_down_bloc.dart';
import 'package:bellani_talents_market/screens/home/gmaps_bloc/gmaps_bloc.dart';
import 'package:bellani_talents_market/screens/home/home_bloc/home_bloc.dart';
import 'package:bellani_talents_market/screens/searchScreen/SearchScreen.dart';
import 'package:bellani_talents_market/services/FirebaseDynamicLinkService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:bellani_talents_market/colors/app_colors.dart';
import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:bellani_talents_market/strings/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../model/CommonStyle.dart';
import '../../model/GetTalentDetailsResoponse.dart';
import '../../model/Talents.dart';
import '../ProfileView.dart';

enum SocialMedia { facebook, instagram, whatsapp, linkedin, call, portfolio }

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<String> services = [];
  List<Talents> talents = [];
  List<DateTime> days = [];
  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> years = [2022, 2023, 2024, 2025, 2026];
  int selectedYear = 0, selectedMonth = 0, _selectedDate = 32;
  bool _yearSelected = false, _monthSelected = false;
  var tappedIndex = null;
  bool _showLocations = false;
  bool _logout = false;
  Set<Marker> markers = Set();
  bool talentInfo = false,
      _photoView = false,
      _reportView = false,
      _display = false,
      _comissionInfoOpen = false,
      _companySelected = false;
  bool _reported = true,
      _notReported = true,
      _blocked = true,
      _notBlocked = true;
  bool _forceLogin = false;
  var token;
  final _key = GlobalKey();
  final safeAreaKey = GlobalKey();
  late Size size;
  late Size safeAreasize;
  var whiteAreaHeight, dropDownHeight, dropUpHeight;
  late LatLng currentPostion;
  late Talents selectedTalent = Talents(
      id: "0",
      photo:
          "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=",
      lat: "lat",
      lng: "lng",
      lat2: "lat2",
      lng2: "lng2",
      category: '',
      facebook: '',
      instagram: '',
      live: '',
      portfolio: '',
      service: '',
      username: '',
      accountId: '',
      bcardClicks: '',
      bmClicks: '',
      category2: '',
      fbClicks: '',
      instaClicks: '',
      languages: '',
      payNowClicks: '',
      phoneClicks: '',
      portfolioClicks: '',
      priceTagClicks: '',
      primaryEmail: '',
      primaryPhone: '',
      primaryPhoneCode: '',
      primaryPhoneLocale: '',
      primaryWhatsapp: '',
      primaryWhatsappCode: '',
      primaryWhatsappLocale: '',
      service2: '',
      shareClicks: '',
      stageName: '',
      whatsappClicks: '');
  var clickedId;
  Set<Marker> _markers = Set();
  var selectedService, selectedCategory, selectedType, types;
  var _headerClicked = false;
  var _footerClicked = false;
  var _homeFooterClicked = false;
  var searchResult;
  var instaUrl = "",
      facebookUrl = "",
      linkedinUrl = "",
      call = "",
      whatsappUrl = "",
      portfolioUrl = "";
  bool _expanded = false;
  bool _expandedBottom = false;
  bool _homeExpandedBottom = false;
  var availableHeight;
  bool setZoom = false;
  bool focused = false;
  bool isFliped = false;
  bool _profileView = false;
  bool _packagesClicked = true,
      _agentClicked = false,
      _transactionClicked = false,
      _walletClicked = false;
  late AnimationController _controller,
      _footerController,
      _reportController,
      _packageInfoAnimationController,
      _agentInfoAnimationController,
      _transactionAnimationController,
      _walletAnimationController,
      _comissionInfoAnimationController;
  late Animation<double> _animation,
      _footerAnimation,
      _packageInfoAnimation,
      _agentInfoAnimation,
      _comissionInfoAnimation,
      _transactionAnimation,
      _walletAnimation,
      _reportAnimation;
  late GoogleMapController mapController;
  late FlipCardController _flipController;
  LatLng _center = const LatLng(9.561191, 96.767230);
  var fadingText = "#MakeIndiaWin";
  DateTime now = DateTime.now();
  var statusBarHeight, bottomHeight;
  late DateTime firstDayOfMonth, lastDayOfMonth, firstMonth, lastMonth;

  @override
  initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _footerController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _reportController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _packageInfoAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _agentInfoAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _transactionAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _walletAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _comissionInfoAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _footerAnimation =
        CurvedAnimation(parent: _footerController, curve: Curves.decelerate);
    _reportAnimation =
        CurvedAnimation(parent: _reportController, curve: Curves.decelerate);
    _packageInfoAnimation = CurvedAnimation(
        parent: _packageInfoAnimationController, curve: Curves.easeInOut);
    _agentInfoAnimation = CurvedAnimation(
        parent: _agentInfoAnimationController, curve: Curves.easeInOut);
    _transactionAnimation = CurvedAnimation(
        parent: _transactionAnimationController, curve: Curves.easeInOut);
    _walletAnimation = CurvedAnimation(
        parent: _walletAnimationController, curve: Curves.easeInOut);
    _comissionInfoAnimation = CurvedAnimation(
        parent: _comissionInfoAnimationController, curve: Curves.easeInOut);
    _flipController = FlipCardController();
    _determinePosition().then((value) {
      _getUserLocation();
    });

    now = DateTime.now();
    _packageInfoAnimationController.forward();

    // scrollController
    //   ..addListener(() {
    //     if (scrollController.position.atEdge) {
    //       bool isleftEdge = scrollController.position.pixels == 0;
    //       if (isleftEdge) {
    //         firstDayOfMonth = new DateTime(firstDayOfMonth.year,
    //             firstDayOfMonth.month, firstDayOfMonth.day - 10);
    //         getDatesInMonth(firstDayOfMonth, lastDayOfMonth);
    //         // setState(() {
    //         //   days = days;
    //         // });
    //       } else {
    //         print('At the bottom');
    //       }
    //     }
    //   });

    // int i = 0;
    // Timer.periodic(Duration(milliseconds: 1400), (timer) {
    //   i++;
    //   setState(() {
    //     _display = !_display;
    //     if (i.isOdd) {
    //       if (!_headerClicked && token == null) {
    //         if (fadingText == "#MakeIndiaWin") {
    //           fadingText = "OneBellani";
    //           return;
    //         }
    //         if (fadingText == "OneBellani") {
    //           fadingText = "Click here to register/login";
    //           return;
    //         }
    //         if (fadingText == "Click here to register/login") {
    //           fadingText = "#MakeIndiaWin";
    //           return;
    //         }
    //       }
    //       if (_headerClicked || token != null) {
    //         if (fadingText == "#MakeIndiaWin") {
    //           fadingText = "OneBellani";
    //           return;
    //         }
    //         if (fadingText == "OneBellani") {
    //           fadingText = "#MakeIndiaWin";
    //           return;
    //         }
    //         if (fadingText == "Click here to register/login") {
    //           fadingText = "#MakeIndiaWin";
    //           return;
    //         }
    //       }
    //     }
    //   });
    // });
  }

  Widget? _showBottomSheet(now) {
    if (_showLocations) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            color: CustomTheme.appColors.primaryColor,
            padding: EdgeInsets.only(bottom: 25),
            child: Container(
              height: 180,
              color: CustomTheme.appColors.primaryColor50,
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: CustomTheme.appColors.primaryColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: CustomTheme.appColors.secondaryColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: Text(
                              "Chennai",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: CustomTheme.appColors.primaryColor50,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: SvgPicture.asset(
                                  "assets/location_withoutbg.svg"),
                            ),
                          ),
                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: Text(
                              "Chennai",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/selectLocation");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.secondaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                "Location 2",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                color: CustomTheme.appColors.primaryColor50,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: SvgPicture.asset("assets/add.svg"),
                              ),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                "Add",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: CustomTheme.appColors.secondaryColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: Text(
                              "Live",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: CustomTheme.appColors.primaryColor50,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: SvgPicture.asset(
                                  "assets/location_withoutbg.svg"),
                            ),
                          ),
                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: Text(
                              "Live",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (_logout) {
      return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              color: CustomTheme.appColors.primaryColor,
              padding: EdgeInsets.only(bottom: 25),
              child: Container(
                height: 180,
                color: CustomTheme.appColors.primaryColor50,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _logout = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CustomTheme.appColors.primaryColor),
                        child: Text(
                          "Stay logged in",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _logout = false;
                          sp.remove("token");
                        });
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CustomTheme.appColors.primaryColor),
                        child: Text(
                          "Log out of app",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else if (_forceLogin) {
      return BottomSheet(
          onClosing: () {},
          enableDrag: false,
          builder: (context) {
            return Container(
                height: double.infinity,
                color: CustomTheme.appColors.primaryColor50,
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                child: Column(
                  children: [
                    Container(
                      height: 160,
                      margin: EdgeInsets.only(top: statusBarHeight),
                      child: Column(
                        children: [
                          Column(children: [
                            Container(
                              height: 30,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color: CustomTheme.appColors.secondaryColor,
                              ),
                              child: Row(children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  child: SvgPicture.asset(
                                      "assets/termsAndConditions.svg"),
                                ),
                                Expanded(
                                  child: Text(
                                    "IMPORTANT INFORMATION",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  // child:
                                  //     SvgPicture.asset("assets/termsAndConditions.svg"),
                                ),
                              ]),
                            ),
                            Container(
                              height: 130,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CustomTheme.appColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6)),
                              ),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "We are only marketing to onboard talented professionals at this stage, and will start marketing to the general public by January 2023. We recommend that you sign up as a talent now, as our service will be free until June 30th 2023 for those who sign up with us at this stage.",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: CustomTheme.appColors.white),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                      height: 115,
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Column(children: [
                            Container(
                              height: 30,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color: CustomTheme.appColors.secondaryColor,
                              ),
                              child: Row(children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  child: SvgPicture.asset(
                                      "assets/termsAndConditions.svg"),
                                ),
                                Expanded(
                                  child: Text(
                                    "CONNECT WITH US",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  // child:
                                  //     SvgPicture.asset("assets/termsAndConditions.svg"),
                                ),
                              ]),
                            ),
                            Container(
                              height: 85,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CustomTheme.appColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6)),
                              ),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "We want to work closely with all talented professionals, and we recommend that you share queries, doubts and feedback with us via email at SOFTWARE@BELLANIGROUP.COM",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: CustomTheme.appColors.white),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(children: [
                          Container(
                            height: 30,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6)),
                              color: CustomTheme.appColors.secondaryColor,
                            ),
                            child: Row(children: [
                              Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                                child: SvgPicture.asset(
                                    "assets/termsAndConditions.svg"),
                              ),
                              Expanded(
                                child: Text(
                                  "TALENT CATEGORIES",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                                // child:
                                //     SvgPicture.asset("assets/termsAndConditions.svg"),
                              ),
                            ]),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CustomTheme.appColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6)),
                              ),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Models, Actors, Hosts/MCs, Dancers, Fashion Designers, Voiceover Artists, Music Producers, Singers, DJs, Sound Engineers, Songwriters, YouTubers, Digital Marketers, Influencers, Advertising Agencies, Choreographers, Fitness Trainers, Dieticians, Cameramen, Scripwriters, Directors, Producers, Photographers, Media, Equipment Rentals, Cinematographers, Makeup Artists, Tailors, Costume Designers, Hairstylists, 3D Animators, 2D Animators, Graphic Designers, Website Designers, Film Prop Makers, Music Recording Studios, Film Set Designers, Film Set Makers, Film Recording Studios, Travel Organisers, Production Planners, Production Managers, Event Organisers",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: CustomTheme.appColors.white),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/loginScreen");
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 35,
                              padding: EdgeInsets.all(10),
                              // child: SvgPicture.asset(
                              //     "assets/right_arrow.svg"),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "login as a talent",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 35,
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset("assets/right_arrow.svg"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/registerScreen");
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 35,
                              padding: EdgeInsets.all(10),
                              // child: SvgPicture.asset(
                              //     "assets/right_arrow.svg"),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Register as a talent",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 35,
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset("assets/right_arrow.svg"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseDynamicLinkService.initDynamicLink(context);
    getToken();
    statusBarHeight = MediaQuery.of(context).viewPadding.top;
    bottomHeight = MediaQuery.of(context).viewPadding.bottom;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeBloc(
                RepositoryProvider.of<ApiService>(context),
              )..add(GetAssetsEvent("English"
                  // sp.getString("selectedLang")
                  )),
            ),
            BlocProvider(
              create: (context) => CategoryBloc(
                RepositoryProvider.of<ApiService>(context),
              ),
            ),
            BlocProvider(
              create: (context) => GmapsBloc(
                RepositoryProvider.of<ApiService>(context),
              )..add(LoadMarkersEventInitial()),
            ),
            if (token != null)
              BlocProvider(
                create: (context) => DropDownBloc(
                  RepositoryProvider.of<ApiService>(context),
                )..add(getProfileEvent(token)),
              ),
          ],
          child: WillPopScope(
            onWillPop: () async {
              // if (_profileView) {
              //   setState(() {
              //     _flipController.flipcard();
              //     setState(() {
              //       isFliped = false;
              //       _profileView = false;
              //     });
              //   });
              //   return false;
              // }
              // if (_expanded) {
              //   if (_expandedBottom) {
              //     makeDropUp();
              //     return false;
              //   }
              //   _controller.reverse().whenComplete(() {
              //     setState(() {
              //       _expanded = false;
              //       _headerClicked = false;
              //     });
              //   });
              //   return false;
              // }
              return false;
            },
            // child: Theme(
            //   data: ThemeData(
            //     scaffoldBackgroundColor: Colors.black,
            //     colorScheme: ColorScheme.dark(),
            //     fontFamily: sp.getString("selectedFont").toString(),
            //     textTheme: const TextTheme(
            //       bodyText1: TextStyle(
            //         fontSize: 36,
            //       ),
            //       bodyText2: TextStyle(
            //         fontSize: 14,
            //       ),
            //     ),
            //   ),
            child: Scaffold(
              backgroundColor: CustomTheme.appColors.primaryColor,
              resizeToAvoidBottomInset: false,
              bottomSheet: _showBottomSheet(now),
              body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                if (state is HomeLoadedState) {
                  if (token != null) {
                    return loggedInHomeLoadedState(context, state);
                  } else {
                    return homeLoadedState(context, state);
                  }
                } else if (state is UpdateAppState) {
                  return Container(
                      color: CustomTheme.appColors.secondaryColor,
                      child: UpdateApp());
                } else if (state is HomeLoadingState) {
                  return Container(
                    color: CustomTheme.appColors.secondaryColor,
                    child: Center(
                        child: SizedBox(
                      height: 70,
                      width: 70,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )),
                  );
                } else {
                  return Center(child: Text("No Internet"));
                }
              }),
            ),
          ),
        ),
      ),
      // ),
    );
  }

  Widget homeLoadedState(BuildContext context, HomeLoadedState state) {
    services.clear();
    setServices(state.services);
    setMarkers(state.talents);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (!_forceLogin) {
            _forceLogin = true;
          } else {
            _forceLogin = false;
          }
        });
      },
      child: SafeArea(
        key: safeAreaKey,
        bottom: false,
        child: Container(
          color: CustomTheme.appColors.secondaryColor,
          child: Column(
            children: [
              if (_footerClicked) Spacer(),
              if (!_footerClicked)
                GestureDetector(
                  onTap: () {
                    safeAreasize = safeAreaKey.currentContext!.size!;
                    dropDownHeight = safeAreasize.height -
                        statusBarHeight -
                        50; // 50 for header
                    dropUpHeight = safeAreasize.height -
                        50 -
                        25; // 50 is footer height and 25 is dummy padding at bottom of screen
                    makeDropDown();
                    setState(() {
                      if (_logout) {
                        _logout = false;
                      }
                    });
                  },
                  child: setHeader(state.assets, state.texts),
                ),
              if (_headerClicked)
                SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    axisAlignment: 0,
                    child: Container(
                      height: dropDownHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: CustomTheme.appColors.secondaryColor,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: CustomTheme.appColors.black
                        //         .withOpacity(0.3),
                        //     blurRadius: 5,
                        //     spreadRadius: 5,
                        //     offset: const Offset(0, 5),
                        //   ),
                        // ],
                      ),
                      child: loginOrRegister(context),
                    )),
              if (_headerClicked) Spacer(),
              if (!_headerClicked && !_footerClicked)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!_profileView)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: CustomTheme.appColors.primaryColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Column(children: [
                                    Padding(
                                        padding: EdgeInsets.all(6),
                                        //welcome
                                        child: MarqueeWidget(
                                          animationDuration:
                                              Duration(milliseconds: 1000),
                                          pauseDuration:
                                              Duration(milliseconds: 800),
                                          backDuration:
                                              Duration(milliseconds: 1000),
                                          child: Text(state.texts[1].text,
                                              style: TextStyle(
                                                  fontSize: double.parse(
                                                      state.texts[1].size),
                                                  color: CustomTheme
                                                      .appColors.white)),
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          // child: GestureDetector(
                                          //   onTap: (() {
                                          //     navigateToSearchScreen(
                                          //         context, "username");
                                          //   }),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Container(
                                                height: 36,
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                                alignment: Alignment.center,
                                                child: MarqueeWidget(
                                                  animationDuration: Duration(
                                                      milliseconds: 1000),
                                                  pauseDuration: Duration(
                                                      milliseconds: 800),
                                                  backDuration: Duration(
                                                      milliseconds: 1000),
                                                  child: Text(
                                                    state.texts[2].text,
                                                    style: TextStyle(
                                                        fontSize: double.parse(
                                                            state.texts[2]
                                                                .size)),
                                                  ),
                                                ),
                                              )),
                                          // ),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        Expanded(
                                          // child: GestureDetector(
                                          //   onTap: (() {
                                          //     navigateToSearchScreen(
                                          //         context, "service");
                                          //   }),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Container(
                                                height: 36,
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                                alignment: Alignment.center,
                                                child: MarqueeWidget(
                                                  animationDuration: Duration(
                                                      milliseconds: 1000),
                                                  pauseDuration: Duration(
                                                      milliseconds: 800),
                                                  backDuration: Duration(
                                                      milliseconds: 1000),
                                                  child: Text(
                                                    state.texts[9].text,
                                                    style: TextStyle(
                                                        fontSize: double.parse(
                                                            state.texts[9]
                                                                .size)),
                                                  ),
                                                ),
                                              )),
                                          // ),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        if (!_profileView)
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.primaryColor,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color:
                              //         CustomTheme.appColors.black.withOpacity(0.3),
                              //     blurRadius: 8,
                              //     spreadRadius: 6,
                              //     offset: const Offset(0, 4),
                              //   ),
                              // ],
                            ),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
                                      child: MarqueeWidget(
                                        animationDuration:
                                            Duration(milliseconds: 1000),
                                        pauseDuration:
                                            Duration(milliseconds: 800),
                                        backDuration:
                                            Duration(milliseconds: 1000),
                                        child: Text(
                                          state.texts[3].text,
                                          style: TextStyle(
                                              //what are you looking
                                              fontSize: double.parse(
                                                  state.texts[3].size),
                                              color:
                                                  CustomTheme.appColors.white),
                                        ),
                                      )),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (!_expanded) if (!_forceLogin) {
                                          _forceLogin = true;
                                        } else {
                                          _forceLogin = false;
                                        }
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Container(
                                                  height: 36,
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  alignment: Alignment.center,
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        canvasColor: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                      ),
                                                      child: DropdownButton<
                                                          String>(
                                                        isExpanded: true,
                                                        alignment:
                                                            Alignment.center,
                                                        icon: Visibility(
                                                            visible: false,
                                                            child: Icon(Icons
                                                                .arrow_downward)),
                                                        //select a service
                                                        hint: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Center(
                                                            child:
                                                                MarqueeWidget(
                                                              animationDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          1000),
                                                              pauseDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          800),
                                                              backDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          1000),
                                                              child: Text(
                                                                  state.texts[4]
                                                                      .text,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize: double.parse(state
                                                                          .texts[
                                                                              4]
                                                                          .size),
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        ),
                                                        items: services.map(
                                                            (String
                                                                dropDownString) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value:
                                                                dropDownString,
                                                            child: MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      textScaleFactor:
                                                                          1.0),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                  child:
                                                                      MarqueeWidget(
                                                                    animationDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                    pauseDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                800),
                                                                    backDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                    child: Text(
                                                                      dropDownString,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            selectedService =
                                                                newValue;
                                                            selectedCategory =
                                                                null;
                                                            talentInfo = false;
                                                            markers.clear();
                                                            if (isFliped ==
                                                                true) {
                                                              _flipController
                                                                  .flipcard();
                                                              isFliped = false;
                                                              _reportView =
                                                                  false;
                                                            }
                                                          });
                                                          BlocProvider.of<
                                                                      CategoryBloc>(
                                                                  context)
                                                              .add(LoadCategoriesEvent(
                                                                  selectedService));
                                                          setState(
                                                            () {
                                                              talentInfo =
                                                                  false;
                                                            },
                                                          );
                                                          BlocProvider.of<
                                                                      GmapsBloc>(
                                                                  context)
                                                              .add(LoadMarkersEventService(
                                                                  selectedService));
                                                        },
                                                        value: selectedService,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                        BlocBuilder<CategoryBloc,
                                            CategoryState>(
                                          builder: (context, categoryState) {
                                            if (categoryState
                                                is CategoryLoadedState) {
                                              setMarkers(categoryState.talents);

                                              return Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, right: 10),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    child: Container(
                                                      height: 36,
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: Theme(
                                                          data:
                                                              Theme.of(context)
                                                                  .copyWith(
                                                            canvasColor: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                          ),
                                                          child: DropdownButton<
                                                              String>(
                                                            isExpanded: true,
                                                            alignment: Alignment
                                                                .center,
                                                            icon: Visibility(
                                                                visible: false,
                                                                child: Icon(Icons
                                                                    .arrow_downward)),
                                                            hint: Center(
                                                              child:
                                                                  MarqueeWidget(
                                                                animationDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                pauseDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            800),
                                                                backDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                child: Text(
                                                                    //select a category
                                                                    state
                                                                        .texts[
                                                                            5]
                                                                        .text,
                                                                    style: TextStyle(
                                                                        fontSize: double.parse(state
                                                                            .texts[
                                                                                5]
                                                                            .size),
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .white)),
                                                              ),
                                                            ),
                                                            items: categoryState
                                                                .categories
                                                                .map((String
                                                                    dropDownString) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    dropDownString,
                                                                child:
                                                                    MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          textScaleFactor:
                                                                              1.0),
                                                                  child: Center(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child:
                                                                          MarqueeWidget(
                                                                        animationDuration:
                                                                            Duration(milliseconds: 1000),
                                                                        pauseDuration:
                                                                            Duration(milliseconds: 800),
                                                                        backDuration:
                                                                            Duration(milliseconds: 1000),
                                                                        child:
                                                                            Text(
                                                                          dropDownString,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(color: CustomTheme.appColors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                selectedCategory =
                                                                    newValue;
                                                                talentInfo =
                                                                    false;
                                                                markers.clear();
                                                                if (isFliped ==
                                                                    true) {
                                                                  _flipController
                                                                      .flipcard();
                                                                  isFliped =
                                                                      false;
                                                                }
                                                              });
                                                              BlocProvider.of<
                                                                          GmapsBloc>(
                                                                      context)
                                                                  .add(LoadMarkersEvent(
                                                                      selectedService,
                                                                      selectedCategory));
                                                              setState(
                                                                () {
                                                                  talentInfo =
                                                                      false;
                                                                },
                                                              );
                                                            },
                                                            value:
                                                                selectedCategory,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                      height: 36,
                                                      width: double.infinity,
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                      child: Center(
                                                        child: MarqueeWidget(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          pauseDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      800),
                                                          backDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          child: Text(
                                                              state.texts[5]
                                                                  .text,
                                                              style: TextStyle(
                                                                  fontSize: double
                                                                      .parse(state
                                                                          .texts[
                                                                              5]
                                                                          .size),
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .white)),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        Expanded(
                          child: FlipCard(
                            controller: _flipController,
                            rotateSide:
                                isFliped ? RotateSide.bottom : RotateSide.top,
                            axis: FlipAxis.horizontal,
                            onTapFlipping: false,
                            animationDuration: const Duration(milliseconds: 0),
                            frontWidget: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CustomTheme.appColors.primaryColor,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: CustomTheme.appColors.black
                                  //         .withOpacity(0.3),
                                  //     blurRadius: 4,
                                  //     spreadRadius: 3,
                                  //     offset: const Offset(0, -3),
                                  //   ),
                                  // ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Column(children: [
                                    GestureDetector(
                                      onTap: () {
                                        int sensitivity = 30;

                                        //SWIPE FROM RIGHT DETECTION
                                        var s = sensitivity;
                                        var t = s;
                                      },
                                      onHorizontalDragUpdate: (details) {
                                        //set the sensitivity for your ios gesture anywhere between 10-50 is good

                                        int sensitivity = 10;

                                        if (details.delta.dx > sensitivity) {
                                          //SWIPE FROM RIGHT DETECTION
                                          var s = sensitivity;
                                          var t = s++;
                                          var u = t;
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          //tap on a profile
                                          // child: MarqueeWidget(
                                          //   animationDuration:
                                          //       Duration(milliseconds: 1000),
                                          //   pauseDuration:
                                          //       Duration(milliseconds: 800),
                                          //   backDuration:
                                          //       Duration(milliseconds: 1000),
                                          child: Text(state.texts[6].text,
                                              style: TextStyle(
                                                  fontSize: double.parse(
                                                      state.texts[6].size),
                                                  color: CustomTheme
                                                      .appColors.white)),
                                          // ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: BlocBuilder<GmapsBloc, GmapsState>(
                                        builder: (context, gmapState) {
                                          if (gmapState is TalentsLoadedState) {
                                            Completer<GoogleMapController>
                                                _mapController = Completer();

                                            setMarkers(gmapState.talents);

                                            return Container(
                                              width: double.infinity,
                                              // color: CustomTheme.appColors.bjpOrange,
                                              child: Stack(children: [
                                                GoogleMap(
                                                  onTap: (argument) {
                                                    setState(
                                                      () {
                                                        talentInfo = false;
                                                      },
                                                    );
                                                  },
                                                  onMapCreated:
                                                      (GoogleMapController
                                                          controller) {
                                                    mapController = controller;
                                                  },
                                                  zoomControlsEnabled: false,
                                                  markers: markers,
                                                  mapToolbarEnabled: false,
                                                  myLocationEnabled: true,
                                                  myLocationButtonEnabled:
                                                      false,
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: _center,
                                                    zoom: 3.0,
                                                  ),
                                                ),
                                                if (talentInfo)
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 10, 0),
                                                      // child: GestureDetector(
                                                      //   onTap: () {
                                                      //     if (token == null) {
                                                      //       makeDropDown();
                                                      //     } else {
                                                      //       Navigator.push(
                                                      //         context,
                                                      //         MaterialPageRoute(
                                                      //             builder: (context) =>
                                                      //                 ProfileView(
                                                      //                     selectedTalent:
                                                      //                         selectedTalent)),
                                                      //       );
                                                      //     }
                                                      // _flipController
                                                      //     .flipcard();
                                                      // setState(() {
                                                      //   isFliped = true;
                                                      //   _profileView = true;
                                                      // });
                                                      // },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6)),
                                                        child: Container(
                                                          height: 50,
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      child: Image.network(
                                                                          selectedTalent
                                                                              .photo),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            4),
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      MarqueeWidget(
                                                                        animationDuration:
                                                                            Duration(milliseconds: 1000),
                                                                        pauseDuration:
                                                                            Duration(milliseconds: 800),
                                                                        backDuration:
                                                                            Duration(milliseconds: 1000),
                                                                        child: Text("@" +
                                                                            selectedTalent.username),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 20),
                                                                        child:
                                                                            MarqueeWidget(
                                                                          animationDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          pauseDuration:
                                                                              Duration(milliseconds: 800),
                                                                          backDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          child: Text(selectedTalent.service +
                                                                              " - " +
                                                                              selectedTalent.category),
                                                                        ),
                                                                      )
                                                                    ]),
                                                              )),
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    call = "tel:" +
                                                                        selectedTalent
                                                                            .primaryPhoneCode +
                                                                        selectedTalent
                                                                            .primaryPhone;
                                                                    share(SocialMedia
                                                                        .call);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              6),
                                                                          topRight:
                                                                              Radius.circular(6)),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            35,
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .secondaryColor,
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.only(
                                                                              bottom: 15,
                                                                              top: 15,
                                                                              left: 10,
                                                                              right: 10),
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            child:
                                                                                SvgPicture.asset("assets/call_without_circle.svg"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              5),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                6),
                                                                        topRight:
                                                                            Radius.circular(6)),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          45,
                                                                      width: 35,
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .secondaryColor,
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                15,
                                                                            top:
                                                                                15,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10),
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          child:
                                                                              SvgPicture.asset("assets/up_arrow.svg"),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      // ),
                                                    ),
                                                  ),
                                                Row(children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      mapController
                                                          .animateCamera(
                                                        CameraUpdate
                                                            .newCameraPosition(
                                                          CameraPosition(
                                                            target:
                                                                currentPostion,
                                                            zoom: 15,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      margin: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          "assets/my_location.svg"),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        mapController
                                                            .animateCamera(
                                                                CameraUpdate
                                                                    .zoomIn());
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      margin: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          "assets/zoom_in.svg"),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        mapController
                                                            .animateCamera(
                                                                CameraUpdate
                                                                    .zoomOut());
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 5, 5, 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          "assets/zoom_out.svg"),
                                                    ),
                                                  ),
                                                ]),
                                              ]),
                                            );
                                          }
                                          return Container(
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: Center(child: Text("gmaps")),
                                          );
                                        },
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            backWidget: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              // child: GestureDetector(
                              //   onDoubleTap: () {
                              //     setState(() {
                              //       if (_photoView == false) {
                              //         _photoView = true;
                              //       } else {
                              //         _photoView = false;
                              //       }
                              //     });
                              //   },
                              child: Container(
                                width: double.infinity,
                                key: _key,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CustomTheme.appColors.white,
                                  image: DecorationImage(
                                    image: NetworkImage(selectedTalent.photo),
                                    fit: BoxFit.cover,
                                  ),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: CustomTheme.appColors.black
                                  //         .withOpacity(0.5),
                                  //     blurRadius: 8,
                                  //     spreadRadius: 5,
                                  //     offset: const Offset(0, 0),
                                  //   ),
                                  // ],
                                ),
                                child: Visibility(
                                  visible: !_photoView,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Column(
                                      children: [
                                        if (!_reportView)
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            child: Container(
                                              height: 86,
                                              width: double.infinity,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8),
                                                      child: Column(children: [
                                                        Container(
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            child: Container(
                                                              height: 36,
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .primaryColor,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    child: Container(
                                                                        height:
                                                                            14,
                                                                        width:
                                                                            14,
                                                                        child: SvgPicture.asset(
                                                                            "assets/star_icon.svg")),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    child: Container(
                                                                        height:
                                                                            14,
                                                                        width:
                                                                            14,
                                                                        child: SvgPicture.asset(
                                                                            "assets/star_icon.svg")),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    child: Container(
                                                                        height:
                                                                            14,
                                                                        width:
                                                                            14,
                                                                        child: SvgPicture.asset(
                                                                            "assets/star_icon.svg")),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    child: Container(
                                                                        height:
                                                                            14,
                                                                        width:
                                                                            14,
                                                                        child: SvgPicture.asset(
                                                                            "assets/star_icon.svg")),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    child: Container(
                                                                        height:
                                                                            14,
                                                                        width:
                                                                            14,
                                                                        child: SvgPicture.asset(
                                                                            "assets/star_icon.svg")),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                          child: Container(
                                                            height: 36,
                                                            width:
                                                                double.infinity,
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                MarqueeWidget(
                                                                  animationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                  pauseDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              800),
                                                                  backDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                  child: Text(
                                                                    "@" +
                                                                        selectedTalent
                                                                            .username,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                                MarqueeWidget(
                                                                    animationDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                    pauseDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                800),
                                                                    backDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                    child: Text(
                                                                      selectedTalent
                                                                              .service +
                                                                          " - " +
                                                                          selectedTalent
                                                                              .category,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                        child: Container(
                                                          height: 36,
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "EN",
                                                                style: TextStyle(
                                                                    color: CustomTheme
                                                                        .appColors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        size = _key
                                                            .currentContext!
                                                            .size!;
                                                        setState(() {
                                                          _reportController
                                                              .forward();
                                                          _reportView = true;
                                                        });
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                        child: Container(
                                                          height: 36,
                                                          width: 30,
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 9,
                                                                    top: 9,
                                                                    left: 6,
                                                                    right: 6),
                                                            child: FittedBox(
                                                              fit: BoxFit.fill,
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/report.svg"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _flipController
                                                            .flipcard();
                                                        setState(() {
                                                          isFliped = false;
                                                          _profileView = false;
                                                        });
                                                      });
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(6),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6)),
                                                      child: Container(
                                                        height: 36,
                                                        width: 30,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10,
                                                                  top: 10,
                                                                  left: 8,
                                                                  right: 8),
                                                          child: FittedBox(
                                                            fit: BoxFit.fill,
                                                            child: SvgPicture.asset(
                                                                "assets/down_arrow.svg"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (!_reportView) Spacer(),
                                        if (!_reportView)
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
                                                  topRight: Radius.circular(6)),
                                              child: Container(
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  color: CustomTheme
                                                      .appColors.primaryColor,
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: CustomTheme
                                                  //         .appColors.black
                                                  //         .withOpacity(0.3),
                                                  //     spreadRadius: 5,
                                                  //     blurRadius: 7,
                                                  //     offset: Offset(3,
                                                  //         -3), // changes position of shadow
                                                  //   ),
                                                  // ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                call = "tel:" +
                                                                    selectedTalent
                                                                        .primaryPhoneCode +
                                                                    selectedTalent
                                                                        .primaryPhone;
                                                                share(
                                                                    SocialMedia
                                                                        .call);
                                                              },
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/call.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                whatsappUrl =
                                                                    "https://api.whatsapp.com/send?phone=${selectedTalent.primaryPhoneCode + selectedTalent.primaryPhone}";
                                                                share(SocialMedia
                                                                    .whatsapp);
                                                              },
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/whatsapp.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/bellani_messenger.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                facebookUrl =
                                                                    selectedTalent
                                                                        .facebook;
                                                                share(SocialMedia
                                                                    .facebook);
                                                              },
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/facebook.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                instaUrl =
                                                                    selectedTalent
                                                                        .instagram;
                                                                share(SocialMedia
                                                                    .instagram);
                                                              },
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/insta.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                //     call = "tel:" + selectedTalent.phone;
                                                                // share(SocialMedia.call);
                                                              },
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/business_card.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                portfolioUrl =
                                                                    selectedTalent
                                                                        .portfolio;
                                                                share(SocialMedia
                                                                    .portfolio);
                                                              },
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/talent_info.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/rupee_tag.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/rupee.svg")),
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                String link = await FirebaseDynamicLinkService.createDynamicLink(
                                                                    true,
                                                                    selectedTalent
                                                                        .id,
                                                                    selectedTalent
                                                                        .photo);

                                                                Share.share(
                                                                    link);
                                                              },
                                                              child: Container(
                                                                height: 55,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
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
                                        if (_reportView)
                                          SizeTransition(
                                            sizeFactor: _reportAnimation,
                                            axis: Axis.vertical,
                                            axisAlignment: 0,
                                            child: Container(
                                              height: size.height,
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          height: 35,
                                                          width: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: CustomTheme
                                                                .appColors
                                                                .bjpOrange,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            child: Image.network(
                                                                selectedTalent
                                                                    .photo),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        top:
                                                                            10),
                                                                    child: MarqueeWidget(
                                                                        animationDuration: Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                        pauseDuration: Duration(
                                                                            milliseconds:
                                                                                800),
                                                                        backDuration: Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                        child: Text("@" +
                                                                            selectedTalent.username))),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child:
                                                                      MarqueeWidget(
                                                                    animationDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                    pauseDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                800),
                                                                    backDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                    child: Text(selectedTalent
                                                                            .service +
                                                                        " - " +
                                                                        selectedTalent
                                                                            .category),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            _reportController
                                                                .reverse()
                                                                .whenComplete(
                                                                    () {
                                                              setState(() {
                                                                _reportView =
                                                                    false;
                                                              });
                                                            });
                                                          },
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                            child: Container(
                                                              height: 36,
                                                              width: 30,
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            13,
                                                                        top: 13,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/white_x.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          // ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 35,
                                                    margin: EdgeInsets.only(
                                                        top: 5,
                                                        left: 10,
                                                        right: 10),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: Text(
                                                              "Would you like to report this profile?",
                                                              style: TextStyle(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            color: CustomTheme
                                                                .appColors
                                                                .unSelectedGrey,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10,
                                                                      top: 10,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: FittedBox(
                                                                fit:
                                                                    BoxFit.fill,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/white_x.svg"),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 4),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            child: Container(
                                                              height: 35,
                                                              width: 35,
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .unSelectedGrey,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10,
                                                                        top: 10,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/white_tick.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 35,
                                                    margin: EdgeInsets.only(
                                                        top: 5,
                                                        left: 10,
                                                        right: 10),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: Text(
                                                              "Would you like to block this profile?",
                                                              style: TextStyle(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            color: CustomTheme
                                                                .appColors
                                                                .unSelectedGrey,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10,
                                                                      top: 10,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: FittedBox(
                                                                fit:
                                                                    BoxFit.fill,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/white_x.svg"),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 4),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            child: Container(
                                                              height: 35,
                                                              width: 35,
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .unSelectedGrey,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10,
                                                                        top: 10,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/white_tick.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6)),
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                      ),
                                                      child: TextFormField(
                                                          cursorColor: CustomTheme
                                                              .appColors.white,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .go,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: null,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .white,
                                                              fontSize: 12),
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 0),
                                                            filled: true,
                                                            fillColor: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  width: 0.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  width: 0.0),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(8),
                                                    margin: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(6),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6)),
                                                      color: CustomTheme
                                                          .appColors
                                                          .unSelectedGrey,
                                                    ),
                                                    // please type in your feedback
                                                    child: Text(
                                                      state.texts[8].text,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              double.parse(state
                                                                  .texts[8]
                                                                  .size)),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 35,
                                                    margin: EdgeInsets.only(
                                                        top: 5,
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 10),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: Text(
                                                              "Get one time password",
                                                              style: TextStyle(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: Container(
                                                            height: 35,
                                                            width: 110,
                                                            color: CustomTheme
                                                                .appColors
                                                                .unSelectedGrey,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  decoration: BoxDecoration(
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .secondaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                ),
                                                                Container(
                                                                  width: 4,
                                                                ),
                                                                Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  decoration: BoxDecoration(
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .secondaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                ),
                                                                Container(
                                                                  width: 4,
                                                                ),
                                                                Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  decoration: BoxDecoration(
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .secondaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                ),
                                                                Container(
                                                                  width: 4,
                                                                ),
                                                                Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  decoration: BoxDecoration(
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .secondaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 4),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            child: Container(
                                                              height: 35,
                                                              width: 35,
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .unSelectedGrey,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10,
                                                                        top: 10,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/white_tick.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!_headerClicked)
                SizeTransition(
                  sizeFactor: _animation,
                  axis: Axis.vertical,
                  axisAlignment: 0,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      color: CustomTheme.appColors.primaryColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0, left: 12, right: 12, bottom: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 280,
                                width: double.infinity,
                                color: CustomTheme.appColors.white,
                                child: loginOrRegister(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!_headerClicked) setFooter(state.assets, state.texts),
              if (!_headerClicked)
                Container(
                  height: 25,
                  color: CustomTheme.appColors.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loggedInHomeLoadedState(BuildContext context, HomeLoadedState state) {
    services.clear();
    setServices(state.services);
    setMarkers(state.talents);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_showLocations) {
            _showLocations = false;
          }
          if (_logout) {
            _logout = false;
          }
        });
      },
      child: SafeArea(
        bottom: false,
        child: Container(
          color: CustomTheme.appColors.secondaryColor,
          key: safeAreaKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_footerClicked) Spacer(),
              if (!_footerClicked && !_headerClicked && !_homeFooterClicked)
                GestureDetector(
                    onTap: () {
                      safeAreasize = safeAreaKey.currentContext!.size!;
                      sp.setDouble("safeAreaHeight", safeAreasize.height);
                      whiteAreaHeight = safeAreasize.height - 375;
                      safeAreasize = safeAreaKey.currentContext!.size!;
                      dropDownHeight = safeAreasize.height -
                          statusBarHeight -
                          50; // 50 for header
                      dropUpHeight = safeAreasize.height -
                          50 -
                          25; // 50 is footer height and 25 is dummy padding at bottom of screen
                      makeDropDown();
                    },
                    child: setHeader(state.assets, state.texts)),
              if (_headerClicked && !_footerClicked && !_homeFooterClicked)
                SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    axisAlignment: 0,
                    child: BlocBuilder<DropDownBloc, DropDownState>(
                      builder: (context, state) {
                        if (state is GotAccountState) {
                          insertInSp(state);
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_showLocations) {
                                      _showLocations = false;
                                    } else {
                                      makeDropDown();
                                    }
                                    if (_logout) {
                                      _logout = false;
                                    } else {
                                      makeDropDown();
                                    }
                                  });
                                },
                                child: profileDropDown(context, state),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _packagesClicked = true;
                                    _agentClicked = false;
                                    _transactionClicked = false;
                                    _walletClicked = false;
                                    _packageInfoAnimationController.forward();
                                    _agentInfoAnimationController.reverse();
                                    _transactionAnimationController.reverse();
                                    _walletAnimationController.reverse();
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: _packagesClicked
                                        ? CustomTheme.appColors.primaryColor50
                                        : null,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: CustomTheme.appColors.primaryColor,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: SvgPicture.asset(
                                                  "assets/package.svg"),
                                            )),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Packages dashboard",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "/packagesScreen");
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 35,
                                            padding: EdgeInsets.all(10),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                            child: SvgPicture.asset(
                                                "assets/right_arrow.svg"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizeTransition(
                                sizeFactor: _packageInfoAnimation,
                                axis: Axis.vertical,
                                axisAlignment: 0,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: whiteAreaHeight,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6)),
                                      color:
                                          CustomTheme.appColors.primaryColor50),
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(children: [
                                        if (state.dashboard != null)
                                          talentNotifications(state.dashboard),
                                        // if (state.account.talentId == "")
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  "/talentsPackageScreen");
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.asset(
                                                          "assets/app_icon.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("Talents package"),
                                                        MarqueeWidget(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          pauseDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      800),
                                                          backDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          child: Text(
                                                              "Learn more about this package"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    padding: EdgeInsets.all(8),
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/right_arrow.svg"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (state.account.talentId == "")
                                          GestureDetector(
                                            onTap: () {
                                              // Navigator.pushNamed(context,
                                              //     "/talentsPackageScreen");
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              margin: EdgeInsets.only(top: 10),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.asset(
                                                          "assets/builders_package.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "Builders package"),
                                                        MarqueeWidget(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          pauseDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      800),
                                                          backDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          child: Text(
                                                              "Learn more about this package"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    padding: EdgeInsets.all(8),
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/right_arrow.svg"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (state.account.talentId == "")
                                          GestureDetector(
                                            onTap: () {
                                              // Navigator.pushNamed(context,
                                              //     "/talentsPackageScreen");
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              margin: EdgeInsets.only(top: 10),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.asset(
                                                          "assets/explore_package.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("Explore package"),
                                                        MarqueeWidget(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          pauseDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      800),
                                                          backDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          child: Text(
                                                              "Learn more about this package"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    padding: EdgeInsets.all(8),
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/right_arrow.svg"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (state.account.talentId == "")
                                          GestureDetector(
                                            onTap: () {
                                              // Navigator.pushNamed(context,
                                              //     "/talentsPackageScreen");
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              margin: EdgeInsets.only(top: 10),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.asset(
                                                          "assets/work_package.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("Work package"),
                                                        MarqueeWidget(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          pauseDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      800),
                                                          backDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          child: Text(
                                                              "Learn more about this package"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    padding: EdgeInsets.all(8),
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/right_arrow.svg"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      // padding: EdgeInsets.only(top: 30),
                                      backgroundColor:
                                          CustomTheme.appColors.white,
                                      content: Container(
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "This feature will be available soon",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  sp.getString("selectedFont"),
                                              color: CustomTheme
                                                  .appColors.secondaryColor),
                                        ),
                                      ),
                                    ));
                                  // setState(() {
                                  //   _packagesClicked = false;
                                  //   _agentClicked = true;
                                  //   _transactionClicked = false;
                                  //   _walletClicked = false;
                                  //   _packageInfoAnimationController.reverse();
                                  //   _agentInfoAnimationController.forward();
                                  //   _transactionAnimationController.reverse();
                                  //   _walletAnimationController.reverse();
                                  // });
                                },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: _agentClicked
                                        ? CustomTheme.appColors.primaryColor50
                                        : null,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: CustomTheme.appColors.primaryColor,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: SvgPicture.asset(
                                                  "assets/agent.svg"),
                                            )),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Agent dashboard",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "/agentScreen");
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 35,
                                            padding: EdgeInsets.all(10),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                            child: SvgPicture.asset(
                                                "assets/right_arrow.svg"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizeTransition(
                                sizeFactor: _agentInfoAnimation,
                                axis: Axis.vertical,
                                axisAlignment: 0,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: whiteAreaHeight,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6)),
                                    color: CustomTheme.appColors.primaryColor50,
                                  ),
                                  child: Column(children: [
                                    if (!_yearSelected && !_monthSelected)
                                      yearCalender(),
                                    if (_yearSelected && !_monthSelected)
                                      monthCalender(),
                                    if (_yearSelected && _monthSelected)
                                      dayCalender(),
                                    if (_selectedDate == 29 &&
                                        _yearSelected &&
                                        _monthSelected)
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        padding: EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6)),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                        ),
                                        child: ListView.builder(
                                          itemCount: 6,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (_comissionInfoOpen) {
                                                    if (tappedIndex == index) {
                                                      _comissionInfoAnimationController
                                                          .reverse()
                                                          .then((value) =>
                                                              _comissionInfoOpen =
                                                                  false);
                                                    } else {
                                                      _comissionInfoAnimationController
                                                          .reverse()
                                                          .then((value) async {
                                                        setState(() {
                                                          tappedIndex = index;
                                                        });
                                                        if (tappedIndex ==
                                                            index) {
                                                          _comissionInfoAnimationController
                                                              .forward()
                                                              .then((value) {
                                                            _comissionInfoOpen =
                                                                true;
                                                          });
                                                        }
                                                      });
                                                    }
                                                  } else {
                                                    tappedIndex = index;
                                                    _comissionInfoAnimationController
                                                        .forward()
                                                        .then((value) =>
                                                            _comissionInfoOpen =
                                                                true);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: CustomTheme.appColors
                                                        .primaryColor50,
                                                  ),
                                                  child: Column(children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              child: Container(
                                                                height: 40,
                                                                width: 40,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Image.asset(
                                                                    "assets/app_icon.png"),
                                                              )),
                                                          Container(
                                                            width: 10,
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Talents package",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                                Text(
                                                                  "@krishnabellani",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                            child: Center(
                                                                child: Text(
                                                                    "₹100",
                                                                    style: TextStyle(
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .white))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (tappedIndex == index &&
                                                        tappedIndex != null)
                                                      SizeTransition(
                                                        sizeFactor:
                                                            _comissionInfoAnimation,
                                                        axis: Axis.vertical,
                                                        axisAlignment: 0,
                                                        child: Container(
                                                          height: 50,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                            // color: CustomTheme.appColors
                                                            //     .secondaryColor,
                                                          ),
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(6),
                                                                              topRight: Radius.circular(6)),
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .secondaryColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              SvgPicture.asset("assets/call.svg"),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(6),
                                                                              topRight: Radius.circular(6)),
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .secondaryColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              SvgPicture.asset("assets/whatsapp.svg"),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(6),
                                                                              topRight: Radius.circular(6)),
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .secondaryColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              SvgPicture.asset("assets/bellani_messenger.svg"),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(6),
                                                                              topRight: Radius.circular(6)),
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .secondaryColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              SvgPicture.asset("assets/facebook.svg"),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(6),
                                                                              topRight: Radius.circular(6)),
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .secondaryColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              SvgPicture.asset("assets/insta.svg"),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          6,
                                                                          6,
                                                                          6),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    // color: CustomTheme.appColors
                                                                    //     .primaryColor,
                                                                  ),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/tick_selected.svg"),
                                                                ),
                                                              ]),
                                                        ),
                                                      )
                                                  ]),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                                    if (_selectedDate != 29 &&
                                        _yearSelected &&
                                        _monthSelected &&
                                        _selectedDate != 32)
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6)),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: Column(children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Image.asset(
                                                            "assets/sad_kid.png"),
                                                      )),
                                                  Container(
                                                    width: 10,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "No transactions available",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        ),
                                                        Text(
                                                          "Learn more from the agent univeristy",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      )),
                                    if (!_yearSelected ||
                                        !_monthSelected ||
                                        _selectedDate == 32)
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6)),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: Column(children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Image.asset(
                                                            "assets/sad_kid.png"),
                                                      )),
                                                  Container(
                                                    width: 10,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "View upcoming transactions",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        ),
                                                        Text(
                                                          "Select a year, month and date to view",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      )),
                                    Container(
                                      height: 50,
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(6)),
                                        color: _transactionClicked
                                            ? CustomTheme
                                                .appColors.primaryColor50
                                            : null,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                        ),
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          right: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  color: CustomTheme
                                                      .appColors.primaryColor,
                                                  child: SvgPicture.asset(
                                                      "assets/invoice_ledger.svg"),
                                                )),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Invoice ledger",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // Navigator.pushNamed(
                                                //     context, "/transactionScreen");
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 35,
                                                padding: EdgeInsets.all(10),
                                                color: CustomTheme
                                                    .appColors.primaryColor,
                                                child: SvgPicture.asset(
                                                    "assets/right_arrow.svg"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: double.infinity,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(6)),
                                        color: _transactionClicked
                                            ? CustomTheme
                                                .appColors.primaryColor50
                                            : null,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                        ),
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          right: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  color: CustomTheme
                                                      .appColors.primaryColor,
                                                  child: SvgPicture.asset(
                                                      "assets/agent_uni.svg"),
                                                )),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Agent university",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // Navigator.pushNamed(
                                                //     context, "/transactionScreen");
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 35,
                                                padding: EdgeInsets.all(10),
                                                color: CustomTheme
                                                    .appColors.primaryColor,
                                                child: SvgPicture.asset(
                                                    "assets/right_arrow.svg"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _packagesClicked = false;
                                    _agentClicked = false;
                                    _transactionClicked = true;
                                    _walletClicked = false;
                                    _packageInfoAnimationController.reverse();
                                    _agentInfoAnimationController.reverse();
                                    _transactionAnimationController.forward();
                                    _walletAnimationController.reverse();
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: _transactionClicked
                                        ? CustomTheme.appColors.primaryColor50
                                        : null,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: CustomTheme.appColors.primaryColor,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: SvgPicture.asset(
                                                  "assets/transaction.svg"),
                                            )),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Transaction statement",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "/transactionScreen");
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 35,
                                            padding: EdgeInsets.all(10),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                            child: SvgPicture.asset(
                                                "assets/right_arrow.svg"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizeTransition(
                                sizeFactor: _transactionAnimation,
                                axis: Axis.vertical,
                                axisAlignment: 0,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: whiteAreaHeight,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6)),
                                    color: CustomTheme.appColors.primaryColor50,
                                  ),
                                  child: Column(children: [
                                    if (!_yearSelected && !_monthSelected)
                                      yearCalender(),
                                    if (_yearSelected && !_monthSelected)
                                      monthCalender(),
                                    if (_yearSelected && _monthSelected)
                                      dayCalender(),
                                    if (_selectedDate == 29 &&
                                        _yearSelected &&
                                        _monthSelected)
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        padding: EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6)),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                        ),
                                        child: ListView.builder(
                                          itemCount: 1,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (_comissionInfoOpen) {
                                                    if (tappedIndex == index) {
                                                      _comissionInfoAnimationController
                                                          .reverse()
                                                          .then((value) =>
                                                              _comissionInfoOpen =
                                                                  false);
                                                    } else {
                                                      _comissionInfoAnimationController
                                                          .reverse()
                                                          .then((value) async {
                                                        setState(() {
                                                          tappedIndex = index;
                                                        });
                                                        if (tappedIndex ==
                                                            index) {
                                                          _comissionInfoAnimationController
                                                              .forward()
                                                              .then((value) {
                                                            _comissionInfoOpen =
                                                                true;
                                                          });
                                                        }
                                                      });
                                                    }
                                                  } else {
                                                    tappedIndex = index;
                                                    _comissionInfoAnimationController
                                                        .forward()
                                                        .then((value) =>
                                                            _comissionInfoOpen =
                                                                true);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: CustomTheme.appColors
                                                        .primaryColor50,
                                                  ),
                                                  child: Column(children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              child: Container(
                                                                height: 40,
                                                                width: 40,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child: Image.asset(
                                                                    "assets/app_icon.png"),
                                                              )),
                                                          Container(
                                                            width: 10,
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Talents package",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                                Text(
                                                                  "@krishnabellani",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                            child: Center(
                                                                child: Text(
                                                                    "₹100",
                                                                    style: TextStyle(
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .white))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (tappedIndex == index &&
                                                        tappedIndex != null)
                                                      SizeTransition(
                                                        sizeFactor:
                                                            _comissionInfoAnimation,
                                                        axis: Axis.vertical,
                                                        axisAlignment: 0,
                                                        child: Container(
                                                          height: 50,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                            // color: CustomTheme.appColors
                                                            //     .secondaryColor,
                                                          ),
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              3,
                                                                          bottom:
                                                                              6,
                                                                          left:
                                                                              3,
                                                                          right:
                                                                              4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    color: CustomTheme
                                                                        .appColors
                                                                        .primaryColor,
                                                                  ),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/txn_pending.svg"),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "HDFC Bank 10293815546",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                        Text(
                                                                          "#1273738291",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              5),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    color: CustomTheme
                                                                        .appColors
                                                                        .primaryColor,
                                                                  ),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/report.svg"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ]),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                                    if (_selectedDate != 29 &&
                                        _yearSelected &&
                                        _monthSelected &&
                                        _selectedDate != 32)
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6)),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: Column(children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Image.asset(
                                                            "assets/sad_kid.png"),
                                                      )),
                                                  Container(
                                                    width: 10,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "No transactions available",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        ),
                                                        Text(
                                                          "Learn more from the agent univeristy",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      )),
                                    if (!_yearSelected ||
                                        !_monthSelected ||
                                        _selectedDate == 32)
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6)),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: Column(children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Image.asset(
                                                            "assets/sad_kid.png"),
                                                      )),
                                                  Container(
                                                    width: 10,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "View upcoming transactions",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        ),
                                                        Text(
                                                          "Select a year, month and date to view",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      )),
                                  ]),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      // padding: EdgeInsets.only(top: 30),
                                      backgroundColor:
                                          CustomTheme.appColors.white,
                                      content: Container(
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "This feature will be available soon",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  sp.getString("selectedFont"),
                                              color: CustomTheme
                                                  .appColors.secondaryColor),
                                        ),
                                      ),
                                    ));
                                  // setState(() {
                                  //   _packagesClicked = false;
                                  //   _agentClicked = false;
                                  //   _transactionClicked = false;
                                  //   _walletClicked = true;
                                  //   _packageInfoAnimationController.reverse();
                                  //   _agentInfoAnimationController.reverse();
                                  //   _transactionAnimationController.reverse();
                                  //   _walletAnimationController.forward();
                                  // });
                                },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: _walletClicked
                                        ? CustomTheme.appColors.primaryColor50
                                        : null,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: CustomTheme.appColors.primaryColor,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: SvgPicture.asset(
                                                  "assets/wallet.svg"),
                                            )),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Bellani wallet",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                "/bellaniWalletScreen");
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 35,
                                            padding: EdgeInsets.all(10),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                            child: SvgPicture.asset(
                                                "assets/right_arrow.svg"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizeTransition(
                                sizeFactor: _walletAnimation,
                                axis: Axis.vertical,
                                axisAlignment: 0,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: whiteAreaHeight,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6)),
                                    color: CustomTheme.appColors.primaryColor50,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  makeDropUp();
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: CustomTheme.appColors.primaryColor,
                                  ),
                                  child: Center(
                                      child: MarqueeWidget(
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    pauseDuration: Duration(milliseconds: 800),
                                    backDuration: Duration(milliseconds: 1000),
                                    child: Text(
                                      "Click here for corporate",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  )),
                                ),
                              ),
                              Container(
                                height: 25,
                                color: CustomTheme.appColors.primaryColor,
                              )
                            ],
                          );
                        }
                        return Container(
                          color: CustomTheme.appColors.secondaryColor,
                          child: Center(
                              child: SizedBox(
                            height: 70,
                            width: 70,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )),
                        );
                      },
                    )),
              if (_headerClicked && !_footerClicked && !_homeFooterClicked)
                Spacer(),
              if (_footerClicked && !_homeFooterClicked)
                SizeTransition(
                  sizeFactor: _footerAnimation,
                  axis: Axis.vertical,
                  axisAlignment: 0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: dropUpHeight,
                          color: CustomTheme.appColors.secondaryColor,
                          child: Column(
                            children: [
                              //before selection of company
                              if (!_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _companySelected = true;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    decoration: BoxDecoration(
                                      color: CustomTheme.appColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Bellani Group LLP",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              if (!_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/addCompanyScreen");
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    decoration: BoxDecoration(
                                      color: CustomTheme.appColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Add a new company",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              if (!_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/manageRoles");
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    decoration: BoxDecoration(
                                      color: CustomTheme.appColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Manage roles",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              if (!_companySelected)
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: CustomTheme.appColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: ListView.builder(
                                        itemCount: 3,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            height: 200,
                                            width: double.infinity,
                                            margin: EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                                color: CustomTheme
                                                    .appColors.primaryColor50,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Column(children: [
                                              Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6))),
                                                child: Text(
                                                    "Map listing for better"),
                                              ),
                                              Container(
                                                height: 100,
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                              ),
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                    "khadgfv ajlhfbv jahbf vjahbfvfjkahbf ajlhfbv ajhdbfaldjf lkajdnfblahdf ajbhfljad fladjhbjkad "),
                                              ),
                                            ]),
                                          );
                                        }),
                                  ),
                                ),
                              //after selection of company
                              if (_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _packagesClicked = true;
                                      _agentClicked = false;
                                      _transactionClicked = false;
                                      _walletClicked = false;
                                      _packageInfoAnimationController.forward();
                                      _agentInfoAnimationController.reverse();
                                      _transactionAnimationController.reverse();
                                      _walletAnimationController.reverse();
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      color: _packagesClicked
                                          ? CustomTheme.appColors.primaryColor50
                                          : null,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                color: CustomTheme
                                                    .appColors.primaryColor,
                                                child: SvgPicture.asset(
                                                    "assets/package.svg"),
                                              )),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Packages dashboard",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, "/packagesScreen");
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 35,
                                              padding: EdgeInsets.all(10),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: SvgPicture.asset(
                                                  "assets/right_arrow.svg"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (_companySelected)
                                SizeTransition(
                                  sizeFactor: _packageInfoAnimation,
                                  axis: Axis.vertical,
                                  axisAlignment: 0,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: whiteAreaHeight + 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                        color: CustomTheme
                                            .appColors.primaryColor50),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6)),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.asset(
                                                          "assets/app_icon.png"),
                                                    ),
                                                  ),
                                                  // Expanded(
                                                  //   child:
                                                  //       scrollableIcons(null),
                                                  // ),
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    padding: EdgeInsets.all(8),
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/right_arrow.svg"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6)),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 50,
                                                    color: CustomTheme
                                                        .appColors.primaryColor,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .bjpOrange,
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/btph.svg")),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .bjpOrange,
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/btph.svg")),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .bjpOrange,
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/btph.svg")),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .bjpOrange,
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/btph.svg")),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .bjpOrange,
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/btph.svg")),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .bjpOrange,
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/btph.svg")),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .bjpOrange,
                                                              ),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/btph.svg")),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  "/talentsPackageScreen");
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.asset(
                                                          "assets/app_icon.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        "Talents package\nLearn more about this package"),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    padding: EdgeInsets.all(8),
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/right_arrow.svg"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              if (_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _packagesClicked = false;
                                      _agentClicked = true;
                                      _transactionClicked = false;
                                      _walletClicked = false;
                                      _packageInfoAnimationController.reverse();
                                      _agentInfoAnimationController.forward();
                                      _transactionAnimationController.reverse();
                                      _walletAnimationController.reverse();
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      color: _agentClicked
                                          ? CustomTheme.appColors.primaryColor50
                                          : null,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                color: CustomTheme
                                                    .appColors.primaryColor,
                                                child: SvgPicture.asset(
                                                    "assets/agent.svg"),
                                              )),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Agent dashboard",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, "/agentScreen");
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 35,
                                              padding: EdgeInsets.all(10),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: SvgPicture.asset(
                                                  "assets/right_arrow.svg"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (_companySelected)
                                SizeTransition(
                                  sizeFactor: _agentInfoAnimation,
                                  axis: Axis.vertical,
                                  axisAlignment: 0,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: whiteAreaHeight + 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6)),
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                    ),
                                    child: Column(children: [
                                      if (!_yearSelected && !_monthSelected)
                                        yearCalender(),
                                      if (_yearSelected && !_monthSelected)
                                        monthCalender(),
                                      if (_yearSelected && _monthSelected)
                                        dayCalender(),
                                      if (_selectedDate == 29 &&
                                          _yearSelected &&
                                          _monthSelected)
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          padding: EdgeInsets.only(bottom: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: ListView.builder(
                                            itemCount: 6,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (_comissionInfoOpen) {
                                                      if (tappedIndex ==
                                                          index) {
                                                        _comissionInfoAnimationController
                                                            .reverse()
                                                            .then((value) =>
                                                                _comissionInfoOpen =
                                                                    false);
                                                      } else {
                                                        _comissionInfoAnimationController
                                                            .reverse()
                                                            .then(
                                                                (value) async {
                                                          setState(() {
                                                            tappedIndex = index;
                                                          });
                                                          if (tappedIndex ==
                                                              index) {
                                                            _comissionInfoAnimationController
                                                                .forward()
                                                                .then((value) {
                                                              _comissionInfoOpen =
                                                                  true;
                                                            });
                                                          }
                                                        });
                                                      }
                                                    } else {
                                                      tappedIndex = index;
                                                      _comissionInfoAnimationController
                                                          .forward()
                                                          .then((value) =>
                                                              _comissionInfoOpen =
                                                                  true);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5,
                                                      left: 5,
                                                      right: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: CustomTheme
                                                          .appColors
                                                          .primaryColor50,
                                                    ),
                                                    child: Column(children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/app_icon.png"),
                                                                )),
                                                            Container(
                                                              width: 10,
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Talents package",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                  Text(
                                                                    "@krishnabellani",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                              child: Center(
                                                                  child: Text(
                                                                      "₹100",
                                                                      style: TextStyle(
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .white))),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (tappedIndex ==
                                                              index &&
                                                          tappedIndex != null)
                                                        SizeTransition(
                                                          sizeFactor:
                                                              _comissionInfoAnimation,
                                                          axis: Axis.vertical,
                                                          axisAlignment: 0,
                                                          child: Container(
                                                            height: 50,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20)),
                                                              // color: CustomTheme.appColors
                                                              //     .secondaryColor,
                                                            ),
                                                            child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              45,
                                                                          width:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                                                            color:
                                                                                CustomTheme.appColors.secondaryColor,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset("assets/call.svg"),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              45,
                                                                          width:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                                                            color:
                                                                                CustomTheme.appColors.secondaryColor,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset("assets/whatsapp.svg"),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              45,
                                                                          width:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                                                            color:
                                                                                CustomTheme.appColors.secondaryColor,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset("assets/bellani_messenger.svg"),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              45,
                                                                          width:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                                                            color:
                                                                                CustomTheme.appColors.secondaryColor,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset("assets/facebook.svg"),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              45,
                                                                          width:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                                                            color:
                                                                                CustomTheme.appColors.secondaryColor,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset("assets/insta.svg"),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            6,
                                                                            6,
                                                                            6),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      // color: CustomTheme.appColors
                                                                      //     .primaryColor,
                                                                    ),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/tick_selected.svg"),
                                                                  ),
                                                                ]),
                                                          ),
                                                        )
                                                    ]),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )),
                                      if (_selectedDate != 29 &&
                                          _yearSelected &&
                                          _monthSelected &&
                                          _selectedDate != 32)
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 5, left: 5, right: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6)),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                            ),
                                            child: Column(children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          child: Image.asset(
                                                              "assets/sad_kid.png"),
                                                        )),
                                                    Container(
                                                      width: 10,
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "No transactions available",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                          Text(
                                                            "Learn more from the agent univeristy",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                          ),
                                        )),
                                      if (!_yearSelected ||
                                          !_monthSelected ||
                                          _selectedDate == 32)
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 5, left: 5, right: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6)),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                            ),
                                            child: Column(children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          child: Image.asset(
                                                              "assets/sad_kid.png"),
                                                        )),
                                                    Container(
                                                      width: 10,
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "View upcoming transactions",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                          Text(
                                                            "Select a year, month and date to view",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                          ),
                                        )),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6)),
                                          color: _transactionClicked
                                              ? CustomTheme
                                                  .appColors.primaryColor50
                                              : null,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    color: CustomTheme
                                                        .appColors.primaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/invoice_ledger.svg"),
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Invoice ledger",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.pushNamed(
                                                  //     context, "/transactionScreen");
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 35,
                                                  padding: EdgeInsets.all(10),
                                                  color: CustomTheme
                                                      .appColors.primaryColor,
                                                  child: SvgPicture.asset(
                                                      "assets/right_arrow.svg"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6)),
                                          color: _transactionClicked
                                              ? CustomTheme
                                                  .appColors.primaryColor50
                                              : null,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    color: CustomTheme
                                                        .appColors.primaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/agent_uni.svg"),
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Agent university",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.pushNamed(
                                                  //     context, "/transactionScreen");
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 35,
                                                  padding: EdgeInsets.all(10),
                                                  color: CustomTheme
                                                      .appColors.primaryColor,
                                                  child: SvgPicture.asset(
                                                      "assets/right_arrow.svg"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              if (_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _packagesClicked = false;
                                      _agentClicked = false;
                                      _transactionClicked = true;
                                      _walletClicked = false;
                                      _packageInfoAnimationController.reverse();
                                      _agentInfoAnimationController.reverse();
                                      _transactionAnimationController.forward();
                                      _walletAnimationController.reverse();
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      color: _transactionClicked
                                          ? CustomTheme.appColors.primaryColor50
                                          : null,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                color: CustomTheme
                                                    .appColors.primaryColor,
                                                child: SvgPicture.asset(
                                                    "assets/transaction.svg"),
                                              )),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Transaction statement",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  "/transactionScreen");
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 35,
                                              padding: EdgeInsets.all(10),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: SvgPicture.asset(
                                                  "assets/right_arrow.svg"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (_companySelected)
                                SizeTransition(
                                  sizeFactor: _transactionAnimation,
                                  axis: Axis.vertical,
                                  axisAlignment: 0,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: whiteAreaHeight + 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6)),
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                    ),
                                    child: Column(children: [
                                      if (!_yearSelected && !_monthSelected)
                                        yearCalender(),
                                      if (_yearSelected && !_monthSelected)
                                        monthCalender(),
                                      if (_yearSelected && _monthSelected)
                                        dayCalender(),
                                      if (_selectedDate == 29 &&
                                          _yearSelected &&
                                          _monthSelected)
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          padding: EdgeInsets.only(bottom: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: ListView.builder(
                                            itemCount: 1,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (_comissionInfoOpen) {
                                                      if (tappedIndex ==
                                                          index) {
                                                        _comissionInfoAnimationController
                                                            .reverse()
                                                            .then((value) =>
                                                                _comissionInfoOpen =
                                                                    false);
                                                      } else {
                                                        _comissionInfoAnimationController
                                                            .reverse()
                                                            .then(
                                                                (value) async {
                                                          setState(() {
                                                            tappedIndex = index;
                                                          });
                                                          if (tappedIndex ==
                                                              index) {
                                                            _comissionInfoAnimationController
                                                                .forward()
                                                                .then((value) {
                                                              _comissionInfoOpen =
                                                                  true;
                                                            });
                                                          }
                                                        });
                                                      }
                                                    } else {
                                                      tappedIndex = index;
                                                      _comissionInfoAnimationController
                                                          .forward()
                                                          .then((value) =>
                                                              _comissionInfoOpen =
                                                                  true);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5,
                                                      left: 5,
                                                      right: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: CustomTheme
                                                          .appColors
                                                          .primaryColor50,
                                                    ),
                                                    child: Column(children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/app_icon.png"),
                                                                )),
                                                            Container(
                                                              width: 10,
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Talents package",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                  Text(
                                                                    "@krishnabellani",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                              child: Center(
                                                                  child: Text(
                                                                      "₹100",
                                                                      style: TextStyle(
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .white))),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (tappedIndex ==
                                                              index &&
                                                          tappedIndex != null)
                                                        SizeTransition(
                                                          sizeFactor:
                                                              _comissionInfoAnimation,
                                                          axis: Axis.vertical,
                                                          axisAlignment: 0,
                                                          child: Container(
                                                            height: 50,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20)),
                                                              // color: CustomTheme.appColors
                                                              //     .secondaryColor,
                                                            ),
                                                            child: Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    padding: EdgeInsets.only(
                                                                        top: 3,
                                                                        bottom:
                                                                            6,
                                                                        left: 3,
                                                                        right:
                                                                            4),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .primaryColor,
                                                                    ),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/txn_pending.svg"),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "HDFC Bank 10293815546",
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                          ),
                                                                          Text(
                                                                            "#1273738291",
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .primaryColor,
                                                                    ),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/report.svg"),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ]),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )),
                                      if (_selectedDate != 29 &&
                                          _yearSelected &&
                                          _monthSelected &&
                                          _selectedDate != 32)
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 5, left: 5, right: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6)),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                            ),
                                            child: Column(children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          child: Image.asset(
                                                              "assets/sad_kid.png"),
                                                        )),
                                                    Container(
                                                      width: 10,
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "No transactions available",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                          Text(
                                                            "Learn more from the agent univeristy",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                          ),
                                        )),
                                      if (!_yearSelected ||
                                          !_monthSelected ||
                                          _selectedDate == 32)
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 5, left: 5, right: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6)),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                            ),
                                            child: Column(children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          child: Image.asset(
                                                              "assets/sad_kid.png"),
                                                        )),
                                                    Container(
                                                      width: 10,
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "View upcoming transactions",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                          Text(
                                                            "Select a year, month and date to view",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                          ),
                                        )),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6)),
                                          color: _transactionClicked
                                              ? CustomTheme
                                                  .appColors.primaryColor50
                                              : null,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    color: CustomTheme
                                                        .appColors.primaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/invoice_ledger.svg"),
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Invoice ledger",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.pushNamed(
                                                  //     context, "/transactionScreen");
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 35,
                                                  padding: EdgeInsets.all(10),
                                                  color: CustomTheme
                                                      .appColors.primaryColor,
                                                  child: SvgPicture.asset(
                                                      "assets/right_arrow.svg"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6)),
                                          color: _transactionClicked
                                              ? CustomTheme
                                                  .appColors.primaryColor50
                                              : null,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: CustomTheme
                                                .appColors.primaryColor,
                                          ),
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    color: CustomTheme
                                                        .appColors.primaryColor,
                                                    child: SvgPicture.asset(
                                                        "assets/agent_uni.svg"),
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Agent university",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.pushNamed(
                                                  //     context, "/transactionScreen");
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 35,
                                                  padding: EdgeInsets.all(10),
                                                  color: CustomTheme
                                                      .appColors.primaryColor,
                                                  child: SvgPicture.asset(
                                                      "assets/right_arrow.svg"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              if (_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _packagesClicked = false;
                                      _agentClicked = false;
                                      _transactionClicked = false;
                                      _walletClicked = true;
                                      _packageInfoAnimationController.reverse();
                                      _agentInfoAnimationController.reverse();
                                      _transactionAnimationController.reverse();
                                      _walletAnimationController.forward();
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      color: _walletClicked
                                          ? CustomTheme.appColors.primaryColor50
                                          : null,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                color: CustomTheme
                                                    .appColors.primaryColor,
                                                child: SvgPicture.asset(
                                                    "assets/wallet.svg"),
                                              )),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Bellani wallet",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  "/bellaniWalletScreen");
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 35,
                                              padding: EdgeInsets.all(10),
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              child: SvgPicture.asset(
                                                  "assets/right_arrow.svg"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (_companySelected)
                                SizeTransition(
                                  sizeFactor: _walletAnimation,
                                  axis: Axis.vertical,
                                  axisAlignment: 0,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: whiteAreaHeight + 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6)),
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            makeDropUp();
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            color: CustomTheme.appColors.primaryColor,
                            child: Row(children: [
                              if (_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _companySelected = false;
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: CustomTheme
                                            .appColors.secondaryColor,
                                        borderRadius: BorderRadius.circular(6)),
                                    child:
                                        SvgPicture.asset("assets/logout.svg"),
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  _companySelected
                                      ? "@bellanigroup"
                                      : "Click here for individual",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              if (_companySelected)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/editCompanyScreen");
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: CustomTheme
                                            .appColors.secondaryColor,
                                        borderRadius: BorderRadius.circular(6)),
                                    margin: EdgeInsets.only(right: 10),
                                    child: SvgPicture.asset("assets/edit.svg"),
                                  ),
                                ),
                            ]),
                          ),
                        ),
                        Container(
                          height: 25,
                          color: CustomTheme.appColors.primaryColor,
                        )
                      ]),
                ),
              if (_homeFooterClicked) Spacer(),
              if (_homeFooterClicked)
                SizeTransition(
                  sizeFactor: _footerAnimation,
                  axis: Axis.vertical,
                  axisAlignment: 0,
                  child: Container(
                    height: dropUpHeight,
                    width: double.infinity,
                    color: CustomTheme.appColors.secondaryColor,
                    child: postOrManageRequirement(context),
                  ),
                ),
              // if (_headerClicked && !_homeFooterClicked)
              //   Container(
              //     height: 10,
              //     color: CustomTheme.appColors.primaryColor,
              //   ),
              if (!_headerClicked && !_footerClicked && !_homeFooterClicked)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!_profileView)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: CustomTheme.appColors.primaryColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Column(children: [
                                    Padding(
                                        padding: EdgeInsets.all(6),
                                        //welcome
                                        child: MarqueeWidget(
                                          animationDuration:
                                              Duration(milliseconds: 1000),
                                          pauseDuration:
                                              Duration(milliseconds: 800),
                                          backDuration:
                                              Duration(milliseconds: 1000),
                                          child: Text(state.texts[1].text,
                                              style: TextStyle(
                                                  fontSize: double.parse(
                                                      state.texts[1].size),
                                                  color: CustomTheme
                                                      .appColors.white)),
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: (() {
                                              navigateToSearchScreen(
                                                  context, "username");
                                            }),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Container(
                                                  height: 36,
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  alignment: Alignment.center,
                                                  child: MarqueeWidget(
                                                    animationDuration: Duration(
                                                        milliseconds: 1000),
                                                    pauseDuration: Duration(
                                                        milliseconds: 800),
                                                    backDuration: Duration(
                                                        milliseconds: 1000),
                                                    child: Text(
                                                      state.texts[2].text,
                                                      style: TextStyle(
                                                          fontSize:
                                                              double.parse(state
                                                                  .texts[2]
                                                                  .size)),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: (() {
                                              navigateToSearchScreen(
                                                  context, "service");
                                            }),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Container(
                                                  height: 36,
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  alignment: Alignment.center,
                                                  child: MarqueeWidget(
                                                    animationDuration: Duration(
                                                        milliseconds: 1000),
                                                    pauseDuration: Duration(
                                                        milliseconds: 800),
                                                    backDuration: Duration(
                                                        milliseconds: 1000),
                                                    child: Text(
                                                      state.texts[9].text,
                                                      style: TextStyle(
                                                          fontSize:
                                                              double.parse(state
                                                                  .texts[9]
                                                                  .size)),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        if (!_profileView)
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.primaryColor,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color:
                              //         CustomTheme.appColors.black.withOpacity(0.3),
                              //     blurRadius: 8,
                              //     spreadRadius: 6,
                              //     offset: const Offset(0, 4),
                              //   ),
                              // ],
                            ),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
                                      child: MarqueeWidget(
                                        animationDuration:
                                            Duration(milliseconds: 1000),
                                        pauseDuration:
                                            Duration(milliseconds: 800),
                                        backDuration:
                                            Duration(milliseconds: 1000),
                                        child: Text(
                                          state.texts[3].text,
                                          style: TextStyle(
                                              //what are you looking
                                              fontSize: double.parse(
                                                  state.texts[3].size),
                                              color:
                                                  CustomTheme.appColors.white),
                                        ),
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Container(
                                                height: 36,
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                                child: Row(children: [
                                                  Expanded(
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          canvasColor: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                        ),
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          alignment:
                                                              Alignment.center,
                                                          icon: Visibility(
                                                              visible: false,
                                                              child: Icon(Icons
                                                                  .arrow_downward)),
                                                          //select a service
                                                          hint: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Center(
                                                              child:
                                                                  MarqueeWidget(
                                                                animationDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                pauseDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            800),
                                                                backDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                child: Text(
                                                                    state
                                                                        .texts[
                                                                            4]
                                                                        .text,
                                                                    style: TextStyle(
                                                                        fontSize: double.parse(state
                                                                            .texts[
                                                                                4]
                                                                            .size),
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .white)),
                                                              ),
                                                            ),
                                                          ),
                                                          items: services.map(
                                                              (String
                                                                  dropDownString) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value:
                                                                  dropDownString,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                        textScaleFactor:
                                                                            1.0),
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        MarqueeWidget(
                                                                      animationDuration:
                                                                          Duration(
                                                                              milliseconds: 1000),
                                                                      pauseDuration:
                                                                          Duration(
                                                                              milliseconds: 800),
                                                                      backDuration:
                                                                          Duration(
                                                                              milliseconds: 1000),
                                                                      child:
                                                                          Text(
                                                                        dropDownString,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color:
                                                                                CustomTheme.appColors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedService =
                                                                  newValue;
                                                              selectedCategory =
                                                                  null;
                                                              talentInfo =
                                                                  false;
                                                              markers.clear();
                                                              if (isFliped ==
                                                                  true) {
                                                                _flipController
                                                                    .flipcard();
                                                                isFliped =
                                                                    false;
                                                                _reportView =
                                                                    false;
                                                              }
                                                            });
                                                            BlocProvider.of<
                                                                        CategoryBloc>(
                                                                    context)
                                                                .add(LoadCategoriesEvent(
                                                                    selectedService));
                                                            setState(
                                                              () {
                                                                talentInfo =
                                                                    false;
                                                              },
                                                            );
                                                            BlocProvider.of<
                                                                        GmapsBloc>(
                                                                    context)
                                                                .add(LoadMarkersEventService(
                                                                    selectedService));
                                                          },
                                                          value:
                                                              selectedService,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              )),
                                        ),
                                      ),
                                      BlocBuilder<CategoryBloc, CategoryState>(
                                        builder: (context, categoryState) {
                                          if (categoryState
                                              is CategoryLoadedState) {
                                            setMarkers(categoryState.talents);

                                            return Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 36,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Row(children: [
                                                      Expanded(
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              canvasColor:
                                                                  CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                            ),
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              icon: Visibility(
                                                                  visible:
                                                                      false,
                                                                  child: Icon(Icons
                                                                      .arrow_downward)),
                                                              hint: Center(
                                                                child:
                                                                    MarqueeWidget(
                                                                  animationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                  pauseDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              800),
                                                                  backDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                  child: Text(
                                                                      //select a category
                                                                      state
                                                                          .texts[
                                                                              5]
                                                                          .text,
                                                                      style: TextStyle(
                                                                          fontSize: double.parse(state
                                                                              .texts[
                                                                                  5]
                                                                              .size),
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .white)),
                                                                ),
                                                              ),
                                                              items: categoryState
                                                                  .categories
                                                                  .map((String
                                                                      dropDownString) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      dropDownString,
                                                                  child:
                                                                      MediaQuery(
                                                                    data: MediaQuery.of(
                                                                            context)
                                                                        .copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            MarqueeWidget(
                                                                          animationDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          pauseDuration:
                                                                              Duration(milliseconds: 800),
                                                                          backDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          child:
                                                                              Text(
                                                                            dropDownString,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(color: CustomTheme.appColors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged: (String?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedCategory =
                                                                      newValue;
                                                                  talentInfo =
                                                                      false;
                                                                  markers
                                                                      .clear();
                                                                  if (isFliped ==
                                                                      true) {
                                                                    _flipController
                                                                        .flipcard();
                                                                    isFliped =
                                                                        false;
                                                                  }
                                                                });
                                                                BlocProvider.of<
                                                                            GmapsBloc>(
                                                                        context)
                                                                    .add(LoadMarkersEvent(
                                                                        selectedService,
                                                                        selectedCategory));
                                                                setState(
                                                                  () {
                                                                    talentInfo =
                                                                        false;
                                                                  },
                                                                );
                                                              },
                                                              value:
                                                                  selectedCategory,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          return Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 10),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Container(
                                                    height: 36,
                                                    width: double.infinity,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    child: Row(
                                                        //select a category
                                                        children: [
                                                          Expanded(
                                                            child: Center(
                                                              child:
                                                                  MarqueeWidget(
                                                                animationDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                pauseDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            800),
                                                                backDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                child: Text(
                                                                    state
                                                                        .texts[
                                                                            5]
                                                                        .text,
                                                                    style: TextStyle(
                                                                        fontSize: double.parse(state
                                                                            .texts[
                                                                                5]
                                                                            .size),
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .white)),
                                                              ),
                                                            ),
                                                          ),
                                                        ])),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        Expanded(
                          child: FlipCard(
                            controller: _flipController,
                            rotateSide:
                                isFliped ? RotateSide.bottom : RotateSide.top,
                            axis: FlipAxis.horizontal,
                            onTapFlipping: false,
                            animationDuration: const Duration(milliseconds: 0),
                            frontWidget: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CustomTheme.appColors.primaryColor,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: CustomTheme.appColors.black
                                  //         .withOpacity(0.3),
                                  //     blurRadius: 4,
                                  //     spreadRadius: 3,
                                  //     offset: const Offset(0, -3),
                                  //   ),
                                  // ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Column(children: [
                                    Container(
                                      height: 50,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        //tap on a profile
                                        child: MarqueeWidget(
                                          animationDuration:
                                              Duration(milliseconds: 1000),
                                          pauseDuration:
                                              Duration(milliseconds: 800),
                                          backDuration:
                                              Duration(milliseconds: 1000),
                                          child: Text(state.texts[6].text,
                                              style: TextStyle(
                                                  fontSize: double.parse(
                                                      state.texts[6].size),
                                                  color: CustomTheme
                                                      .appColors.white)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: BlocBuilder<GmapsBloc, GmapsState>(
                                        builder: (context, gmapState) {
                                          if (gmapState is TalentsLoadedState) {
                                            Completer<GoogleMapController>
                                                _mapController = Completer();

                                            setMarkers(gmapState.talents);

                                            return Container(
                                              width: double.infinity,
                                              // color: CustomTheme.appColors.bjpOrange,
                                              child: Stack(children: [
                                                GoogleMap(
                                                  onTap: (argument) {
                                                    setState(
                                                      () {
                                                        talentInfo = false;
                                                      },
                                                    );
                                                  },
                                                  onMapCreated:
                                                      (GoogleMapController
                                                          controller) {
                                                    mapController = controller;
                                                  },
                                                  zoomControlsEnabled: false,
                                                  markers: markers,
                                                  mapToolbarEnabled: false,
                                                  myLocationEnabled: true,
                                                  myLocationButtonEnabled:
                                                      false,
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: _center,
                                                    zoom: 3.0,
                                                  ),
                                                ),
                                                if (talentInfo)
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 10, 0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ProfileView(
                                                                        selectedTalent:
                                                                            selectedTalent)),
                                                          );
                                                          // _flipController
                                                          //     .flipcard();
                                                          // setState(() {
                                                          //   isFliped = true;
                                                          //   _profileView = true;
                                                          // });
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6)),
                                                          child: Container(
                                                            height: 50,
                                                            color: CustomTheme
                                                                .appColors
                                                                .primaryColor,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40,
                                                                      width: 40,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        child: Image.network(
                                                                            selectedTalent.photo),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              4),
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        MarqueeWidget(
                                                                          animationDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          pauseDuration:
                                                                              Duration(milliseconds: 800),
                                                                          backDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          child:
                                                                              Text("@" + selectedTalent.username),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(right: 20),
                                                                          child:
                                                                              MarqueeWidget(
                                                                            animationDuration:
                                                                                Duration(milliseconds: 1000),
                                                                            pauseDuration:
                                                                                Duration(milliseconds: 800),
                                                                            backDuration:
                                                                                Duration(milliseconds: 1000),
                                                                            child: Text(selectedTalent.service +
                                                                                " - " +
                                                                                selectedTalent.category),
                                                                          ),
                                                                        )
                                                                      ]),
                                                                )),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      call = "tel:" +
                                                                          selectedTalent
                                                                              .primaryPhoneCode +
                                                                          selectedTalent
                                                                              .primaryPhone;
                                                                      share(SocialMedia
                                                                          .call);
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(6),
                                                                            topRight: Radius.circular(6)),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              45,
                                                                          width:
                                                                              35,
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .secondaryColor,
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsets.only(
                                                                                bottom: 15,
                                                                                top: 15,
                                                                                left: 10,
                                                                                right: 10),
                                                                            child:
                                                                                FittedBox(
                                                                              fit: BoxFit.fill,
                                                                              child: SvgPicture.asset("assets/call_without_circle.svg"),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              6),
                                                                          topRight:
                                                                              Radius.circular(6)),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            35,
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .secondaryColor,
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.only(
                                                                              bottom: 15,
                                                                              top: 15,
                                                                              left: 10,
                                                                              right: 10),
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            child:
                                                                                SvgPicture.asset("assets/up_arrow.svg"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                Row(children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      mapController
                                                          .animateCamera(
                                                        CameraUpdate
                                                            .newCameraPosition(
                                                          CameraPosition(
                                                            target:
                                                                currentPostion,
                                                            zoom: 15,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      margin: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          "assets/my_location.svg"),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        mapController
                                                            .animateCamera(
                                                                CameraUpdate
                                                                    .zoomIn());
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      margin: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          "assets/zoom_in.svg"),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        mapController
                                                            .animateCamera(
                                                                CameraUpdate
                                                                    .zoomOut());
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 5, 5, 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          "assets/zoom_out.svg"),
                                                    ),
                                                  ),
                                                ]),
                                              ]),
                                            );
                                          }
                                          return Container(
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: Center(child: Text("gmaps")),
                                          );
                                        },
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            backWidget: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: GestureDetector(
                                onDoubleTap: () {
                                  setState(() {
                                    if (_photoView == false) {
                                      _photoView = true;
                                    } else {
                                      _photoView = false;
                                    }
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  key: _key,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: CustomTheme.appColors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(selectedTalent.photo),
                                      fit: BoxFit.cover,
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: CustomTheme.appColors.black
                                    //         .withOpacity(0.5),
                                    //     blurRadius: 8,
                                    //     spreadRadius: 5,
                                    //     offset: const Offset(0, 0),
                                    //   ),
                                    // ],
                                  ),
                                  child: Visibility(
                                    visible: !_photoView,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Column(
                                        children: [
                                          if (!_reportView)
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6)),
                                              child: Container(
                                                height: 86,
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8),
                                                        child: Column(
                                                            children: [
                                                              Container(
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius: BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              6),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              6)),
                                                                  child:
                                                                      Container(
                                                                    height: 36,
                                                                    color: CustomTheme
                                                                        .appColors
                                                                        .primaryColor,
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                8),
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
                                                                              child: SvgPicture.asset("assets/star_icon.svg")),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(2),
                                                                          child: Container(
                                                                              height: 14,
                                                                              width: 14,
                                                                              child: SvgPicture.asset("assets/star_icon.svg")),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(2),
                                                                          child: Container(
                                                                              height: 14,
                                                                              width: 14,
                                                                              child: SvgPicture.asset("assets/star_icon.svg")),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(2),
                                                                          child: Container(
                                                                              height: 14,
                                                                              width: 14,
                                                                              child: SvgPicture.asset("assets/star_icon.svg")),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(2),
                                                                          child: Container(
                                                                              height: 14,
                                                                              width: 14,
                                                                              child: SvgPicture.asset("assets/star_icon.svg")),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            6),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            6)),
                                                                child:
                                                                    Container(
                                                                  height: 36,
                                                                  width: double
                                                                      .infinity,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      MarqueeWidget(
                                                                        animationDuration:
                                                                            Duration(milliseconds: 1000),
                                                                        pauseDuration:
                                                                            Duration(milliseconds: 800),
                                                                        backDuration:
                                                                            Duration(milliseconds: 1000),
                                                                        child:
                                                                            Text(
                                                                          "@" +
                                                                              selectedTalent.username,
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                      MarqueeWidget(
                                                                          animationDuration: Duration(
                                                                              milliseconds:
                                                                                  1000),
                                                                          pauseDuration: Duration(
                                                                              milliseconds:
                                                                                  800),
                                                                          backDuration: Duration(
                                                                              milliseconds:
                                                                                  1000),
                                                                          child:
                                                                              Text(
                                                                            selectedTalent.service +
                                                                                " - " +
                                                                                selectedTalent.category,
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                          child: Container(
                                                            height: 36,
                                                            color: CustomTheme
                                                                .appColors
                                                                .primaryColor,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "EN",
                                                                  style: TextStyle(
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          size = _key
                                                              .currentContext!
                                                              .size!;
                                                          setState(() {
                                                            _reportController
                                                                .forward();
                                                            _reportView = true;
                                                          });
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                          child: Container(
                                                            height: 36,
                                                            width: 30,
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom: 9,
                                                                      top: 9,
                                                                      left: 6,
                                                                      right: 6),
                                                              child: FittedBox(
                                                                fit:
                                                                    BoxFit.fill,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/report.svg"),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _flipController
                                                              .flipcard();
                                                          setState(() {
                                                            isFliped = false;
                                                            _profileView =
                                                                false;
                                                          });
                                                        });
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            6)),
                                                        child: Container(
                                                          height: 36,
                                                          width: 30,
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10,
                                                                    top: 10,
                                                                    left: 8,
                                                                    right: 8),
                                                            child: FittedBox(
                                                              fit: BoxFit.fill,
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/down_arrow.svg"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (!_reportView) Spacer(),
                                          if (!_reportView)
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
                                                    topRight:
                                                        Radius.circular(6)),
                                                child: Container(
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    color: CustomTheme
                                                        .appColors.primaryColor,
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color: CustomTheme
                                                    //         .appColors.black
                                                    //         .withOpacity(0.3),
                                                    //     spreadRadius: 5,
                                                    //     blurRadius: 7,
                                                    //     offset: Offset(3,
                                                    //         -3), // changes position of shadow
                                                    //   ),
                                                    // ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  call = "tel:" +
                                                                      selectedTalent
                                                                          .primaryPhoneCode +
                                                                      selectedTalent
                                                                          .primaryPhone;
                                                                  share(
                                                                      SocialMedia
                                                                          .call);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/call.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  whatsappUrl =
                                                                      "https://api.whatsapp.com/send?phone=${selectedTalent.primaryPhoneCode + selectedTalent.primaryPhone}";
                                                                  share(SocialMedia
                                                                      .whatsapp);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/whatsapp.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/bellani_messenger.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  facebookUrl =
                                                                      selectedTalent
                                                                          .facebook;
                                                                  share(SocialMedia
                                                                      .facebook);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/facebook.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  instaUrl =
                                                                      selectedTalent
                                                                          .instagram;
                                                                  share(SocialMedia
                                                                      .instagram);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/insta.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  //     call = "tel:" + selectedTalent.phone;
                                                                  // share(SocialMedia.call);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/business_card.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  portfolioUrl =
                                                                      selectedTalent
                                                                          .portfolio;
                                                                  share(SocialMedia
                                                                      .portfolio);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/talent_info.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/rupee_tag.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/rupee.svg")),
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  String link = await FirebaseDynamicLinkService.createDynamicLink(
                                                                      true,
                                                                      selectedTalent
                                                                          .id,
                                                                      selectedTalent
                                                                          .photo);

                                                                  Share.share(
                                                                      link);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
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
                                          if (_reportView)
                                            SizeTransition(
                                              sizeFactor: _reportAnimation,
                                              axis: Axis.vertical,
                                              axisAlignment: 0,
                                              child: Container(
                                                height: size.height,
                                                color: CustomTheme
                                                    .appColors.primaryColor,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            height: 35,
                                                            width: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .bjpOrange,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              child: Image.network(
                                                                  selectedTalent
                                                                      .photo),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                      child: MarqueeWidget(
                                                                          animationDuration: Duration(
                                                                              milliseconds:
                                                                                  1000),
                                                                          pauseDuration: Duration(
                                                                              milliseconds:
                                                                                  800),
                                                                          backDuration: Duration(
                                                                              milliseconds:
                                                                                  1000),
                                                                          child:
                                                                              Text("@" + selectedTalent.username))),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child:
                                                                        MarqueeWidget(
                                                                      animationDuration:
                                                                          Duration(
                                                                              milliseconds: 1000),
                                                                      pauseDuration:
                                                                          Duration(
                                                                              milliseconds: 800),
                                                                      backDuration:
                                                                          Duration(
                                                                              milliseconds: 1000),
                                                                      child: Text(selectedTalent
                                                                              .service +
                                                                          " - " +
                                                                          selectedTalent
                                                                              .category),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              _reportController
                                                                  .reverse()
                                                                  .whenComplete(
                                                                      () {
                                                                setState(() {
                                                                  _reportView =
                                                                      false;
                                                                });
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 36,
                                                              width: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            6),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            6)),
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .secondaryColor,
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            13,
                                                                        top: 13,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/white_x.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                            // ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      margin: EdgeInsets.only(
                                                          top: 5,
                                                          left: 10,
                                                          right: 10),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              child: Text(
                                                                "Would you like to report this profile?",
                                                                style: TextStyle(
                                                                    color: CustomTheme
                                                                        .appColors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _reported =
                                                                    false;
                                                                _notReported =
                                                                    true;
                                                              });
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              child: Container(
                                                                height: 30,
                                                                width: 30,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .white,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  child: SvgPicture
                                                                      .asset(_reported
                                                                          ? "assets/x_unselected.svg"
                                                                          : "assets/x_selected.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _reported =
                                                                    true;
                                                                _notReported =
                                                                    false;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 4),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .white,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    child: SvgPicture.asset(_notReported
                                                                        ? "assets/tick_unselected.svg"
                                                                        : "assets/tick_selected.svg"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      margin: EdgeInsets.only(
                                                          top: 5,
                                                          left: 10,
                                                          right: 10),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              child: Text(
                                                                "Would you like to block this profile?",
                                                                style: TextStyle(
                                                                    color: CustomTheme
                                                                        .appColors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _blocked =
                                                                    false;
                                                                _notBlocked =
                                                                    true;
                                                              });
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              child: Container(
                                                                height: 30,
                                                                width: 30,
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .white,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  child: SvgPicture
                                                                      .asset(_blocked
                                                                          ? "assets/x_unselected.svg"
                                                                          : "assets/x_selected.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _blocked = true;
                                                                _notBlocked =
                                                                    false;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 4),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .white,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    child: SvgPicture.asset(_notBlocked
                                                                        ? "assets/tick_unselected.svg"
                                                                        : "assets/tick_selected.svg"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 5),
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6)),
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                        ),
                                                        child: TextFormField(
                                                            cursorColor:
                                                                CustomTheme
                                                                    .appColors
                                                                    .white,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .go,
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            maxLines: null,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: CustomTheme
                                                                    .appColors
                                                                    .white,
                                                                fontSize: 12),
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      bottom:
                                                                          0),
                                                              filled: true,
                                                              fillColor: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                              disabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: CustomTheme
                                                                        .appColors
                                                                        .secondaryColor,
                                                                    width: 0.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: CustomTheme
                                                                        .appColors
                                                                        .secondaryColor,
                                                                    width: 0.0),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Container(
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          6)),
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                        ),
                                                        // please type in your feedback
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          child: Text(
                                                            state.texts[8].text,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: double
                                                                    .parse(state
                                                                        .texts[
                                                                            8]
                                                                        .size)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 10,
                                                          left: 10,
                                                          right: 10),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: Container(
                                                            height: 30,
                                                            color: CustomTheme
                                                                .appColors
                                                                .secondaryColor,
                                                            child: Row(
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: CustomTheme
                                                                          .appColors
                                                                          .primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(3),
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                4),
                                                                    child:
                                                                        MarqueeWidget(
                                                                      animationDuration:
                                                                          Duration(
                                                                              milliseconds: 1000),
                                                                      pauseDuration:
                                                                          Duration(
                                                                              milliseconds: 800),
                                                                      backDuration:
                                                                          Duration(
                                                                              milliseconds: 1000),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 8),
                                                                        child:
                                                                            Text(
                                                                          "Get one time password",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              color: CustomTheme.appColors.white,
                                                                              fontSize: 12),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                      child:
                                                                          Form(
                                                                        // key: _otpKey,
                                                                        child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Container(
                                                                                width: 4,
                                                                                height: 1,
                                                                              ),
                                                                              Container(
                                                                                height: 20,
                                                                                width: 18,
                                                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                                                padding: EdgeInsets.only(left: 3),
                                                                                decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      color: CustomTheme.appColors.secondaryColor,
                                                                                    ),
                                                                                    color: CustomTheme.appColors.secondaryColor,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                                                child: TextFormField(
                                                                                  // focusNode:
                                                                                  //     focusNode0,
                                                                                  // controller:
                                                                                  //     _otpController,
                                                                                  onChanged: (value) {
                                                                                    // if (value.length == 1) {
                                                                                    //   FocusScope.of(context).requestFocus(focusNode1);
                                                                                    // }
                                                                                  },
                                                                                  style: const TextStyle(
                                                                                    height: 1.2,
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                  inputFormatters: <TextInputFormatter>[
                                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                                  ],
                                                                                  maxLength: 1,
                                                                                  textAlign: TextAlign.center,
                                                                                  keyboardType: TextInputType.number,
                                                                                  decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
                                                                                  validator: (value) {
                                                                                    if (value!.isEmpty) {
                                                                                      return "";
                                                                                    } else {
                                                                                      return null;
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 4,
                                                                                height: 1,
                                                                              ),
                                                                              Container(
                                                                                height: 20,
                                                                                width: 18,
                                                                                padding: EdgeInsets.only(left: 3),
                                                                                decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      color: CustomTheme.appColors.secondaryColor,
                                                                                    ),
                                                                                    color: CustomTheme.appColors.secondaryColor,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                                                child: TextFormField(
                                                                                  // controller:
                                                                                  //     _otpController2,
                                                                                  // focusNode:
                                                                                  //     focusNode1,
                                                                                  onChanged: (value) {
                                                                                    // if (value.length == 1) {
                                                                                    //   FocusScope.of(context).requestFocus(focusNode2);
                                                                                    // }
                                                                                    // if (value.isEmpty) {
                                                                                    //   FocusScope.of(context).requestFocus(focusNode0);
                                                                                    // }
                                                                                  },
                                                                                  style: const TextStyle(
                                                                                    fontSize: 12,
                                                                                    height: 1.2,
                                                                                  ),
                                                                                  inputFormatters: <TextInputFormatter>[
                                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                                  ],
                                                                                  maxLength: 1,
                                                                                  textAlign: TextAlign.center,
                                                                                  keyboardType: TextInputType.number,
                                                                                  decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
                                                                                  validator: (value) {
                                                                                    if (value!.isEmpty) {
                                                                                      return "";
                                                                                    } else {
                                                                                      return null;
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 4,
                                                                                height: 1,
                                                                              ),
                                                                              Container(
                                                                                height: 20,
                                                                                width: 18,
                                                                                padding: EdgeInsets.only(left: 3),
                                                                                decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      color: CustomTheme.appColors.secondaryColor,
                                                                                    ),
                                                                                    color: CustomTheme.appColors.secondaryColor,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                                                child: TextFormField(
                                                                                  // focusNode:
                                                                                  //     focusNode2,
                                                                                  // controller:
                                                                                  //     _otpController3,
                                                                                  onChanged: (value) {
                                                                                    // if (value.length == 1) {
                                                                                    //   FocusScope.of(context).requestFocus(focusNode3);
                                                                                    // }
                                                                                    // if (value.isEmpty) {
                                                                                    //   FocusScope.of(context).requestFocus(focusNode1);
                                                                                    // }
                                                                                  },
                                                                                  style: const TextStyle(
                                                                                    fontSize: 12,
                                                                                    height: 1.2,
                                                                                  ),
                                                                                  maxLength: 1,
                                                                                  textAlign: TextAlign.center,
                                                                                  keyboardType: TextInputType.number,
                                                                                  inputFormatters: <TextInputFormatter>[
                                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                                  ],
                                                                                  decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
                                                                                  validator: (value) {
                                                                                    if (value!.isEmpty) {
                                                                                      return "";
                                                                                    } else {
                                                                                      return null;
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 4,
                                                                                height: 1,
                                                                              ),
                                                                              Container(
                                                                                height: 20,
                                                                                width: 18,
                                                                                padding: EdgeInsets.only(left: 3),
                                                                                decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      color: CustomTheme.appColors.secondaryColor,
                                                                                    ),
                                                                                    color: CustomTheme.appColors.secondaryColor,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                                                child: TextFormField(
                                                                                  // controller:
                                                                                  //     _otpController4,
                                                                                  // focusNode:
                                                                                  //     focusNode3,
                                                                                  onChanged: (value) {
                                                                                    // if (value.isEmpty) {
                                                                                    //   FocusScope.of(context).requestFocus(focusNode2);
                                                                                    // }
                                                                                  },
                                                                                  style: const TextStyle(
                                                                                    fontSize: 12,
                                                                                    height: 1.2,
                                                                                  ),
                                                                                  maxLength: 1,
                                                                                  inputFormatters: <TextInputFormatter>[
                                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                                  ],
                                                                                  textAlign: TextAlign.center,
                                                                                  keyboardType: TextInputType.number,
                                                                                  decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
                                                                                  validator: (value) {
                                                                                    if (value!.isEmpty) {
                                                                                      return "";
                                                                                    } else {
                                                                                      return null;
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 4,
                                                                                height: 1,
                                                                              ),
                                                                            ]),
                                                                      )),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                        child: Container(
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              30,
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .primaryColor,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset("assets/tick_unselected.svg"),
                                                                          ),
                                                                        )),
                                                                  ),
                                                                ]),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!_headerClicked && !_homeFooterClicked)
                SizeTransition(
                  sizeFactor: _animation,
                  axis: Axis.vertical,
                  axisAlignment: 0,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      color: CustomTheme.appColors.primaryColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0, left: 12, right: 12, bottom: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 280,
                                width: double.infinity,
                                color: CustomTheme.appColors.white,
                                child: loginOrRegister(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!_headerClicked) setFooter(state.assets, state.texts),
              if (!_headerClicked)
                Container(
                  height: 25,
                  color: CustomTheme.appColors.primaryColor,
                )
            ],
          ),
        ),
      ),
    );
  }

  void _getUserLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void makeDropDown() {
    setState(() {
      if (isFliped) {
        _flipController.flipcard();
        isFliped = false;
        _profileView = false;
      }
      if (_headerClicked == false) {
        _headerClicked = true;
      }
      if (_expanded == false) {
        _controller.forward().whenComplete(() {
          setState(() {
            _expanded = true;
          });
        });
      } else {
        _controller.reverse().whenComplete(() {
          setState(() {
            _expanded = false;
            _headerClicked = false;
          });
        });
      }
    });
  }

  void makeDropUp() {
    setState(() {
      if (_footerClicked == false) {
        _footerClicked = true;
      }
      if (_expandedBottom == false) {
        _footerController.forward().whenComplete(() {
          setState(() {
            _expandedBottom = true;
          });
        });
      } else {
        _footerController.reverse().whenComplete(() {
          setState(() {
            _expandedBottom = false;
            _footerClicked = false;
          });
        });
      }
    });
  }

  void makeHomeDropUp() {
    setState(() {
      if (_homeFooterClicked == false) {
        _homeFooterClicked = true;
      }
      if (_homeExpandedBottom == false) {
        _footerController.forward().whenComplete(() {
          setState(() {
            _homeExpandedBottom = true;
          });
        });
      } else {
        _footerController.reverse().whenComplete(() {
          setState(() {
            _homeExpandedBottom = false;
            _homeFooterClicked = false;
          });
        });
      }
    });
  }

  Widget setHeader(List<Assets> assets, List<Texts> texts) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
        color: CustomTheme.appColors.primaryColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: CustomTheme.appColors.black.withOpacity(0.3),
        //     blurRadius: 5,
        //     spreadRadius: 5,
        //     offset: const Offset(0, 5),
        //   ),
        // ],
      ),
      child: Center(
        //   child: OpacityAnimatedWidget.tween(
        // opacityEnabled: 1, //define start value
        // opacityDisabled: 0, //and end value
        // enabled: _display,
        child: Text(
          token == null
              ? "Click here to login as a talent"
              : "Click here to view your profile",
          style: TextStyle(fontSize: 24),
        ),
      ),
      // ),
    );
    // return Container(
    //   height: 70,
    //   width: double.infinity,
    // decoration: BoxDecoration(
    //   color: CustomTheme.appColors.white,
    //   boxShadow: [
    //     BoxShadow(
    //       color: CustomTheme.appColors.black.withOpacity(0.3),
    //       spreadRadius: 5,
    //       blurRadius: 7,
    //       offset: Offset(0, 3), // changes position of shadow
    //     ),
    //   ],
    // ),
    //   child: Padding(
    //     padding: EdgeInsets.symmetric(horizontal: 10),
    //     child: Container(
    //       width: double.infinity,
    //       height: 50,
    //       child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(6),
    //           child: GestureDetector(
    //             onTap: () {
    //               Navigator.pushNamed(context, '/loginOrSignup');
    //             },
    //             child: Container(
    //               height: 50,
    //               width: 50,
    //               color: CustomTheme.appColors.primaryColor,
    //               child: Image.network(assets[0].url),
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: EdgeInsets.all(17),
    //             child: Center(
    //               child: Text(texts[0].text,
    //                   style: TextStyle(
    //                       fontSize: double.parse(texts[0].size),
    //                       color: CustomTheme.appColors.primaryColor)),
    //             ),
    //           ),
    //         ),
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(6),
    //           child: Container(
    //             height: 50,
    //             width: 50,
    //             color: CustomTheme.appColors.primaryColor,
    //             child: Image.network(assets[1].url),
    //           ),
    //         ),
    //       ]),
    //     ),
    //   ),
    // );
  }

  Widget setFooter(List<Assets> assets, List<Texts> texts) {
    return GestureDetector(
      onTap: () {
        safeAreasize = safeAreaKey.currentContext!.size!;
        sp.setDouble("safeAreaHeight", safeAreasize.height);
        dropDownHeight =
            safeAreasize.height - statusBarHeight - 50; // 50 for header
        dropUpHeight = safeAreasize.height -
            50 -
            25; // 50 is footer height and 25 is dummy padding at bottom of screen
        makeHomeDropUp();
        if (token == null) {
          makeDropDown();
        }
      },
      child: Container(
        height: 50,
        width: double.infinity,
        color: CustomTheme.appColors.primaryColor,
        alignment: Alignment.center,
        child: MarqueeWidget(
          animationDuration: Duration(milliseconds: 1000),
          pauseDuration: Duration(milliseconds: 800),
          backDuration: Duration(milliseconds: 1000),
          child: Text(
            _homeExpandedBottom && token != null
                ? "Click here to go back"
                : "Click here to post a requirement",
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
    // return Container(
    //   height: 50,
    //   color: CustomTheme.appColors.primaryColor,
    //   child: Container(
    //     margin: EdgeInsets.all(10),
    //     padding: EdgeInsets.only(right: 6),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(6),
    //       color: CustomTheme.appColors.secondaryColor,
    //     ),
    //     child: Row(children: [
    //       Container(
    //           padding: EdgeInsets.symmetric(horizontal: 8),
    //           margin: EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(6),
    //             color: CustomTheme.appColors.primaryColor,
    //           ),
    //           child: Center(
    //               child: Text(
    //             sp.getString("selectedLang").toString(),
    //             style: TextStyle(fontFamily: sp.getString("selectedFont")),
    //           ))
    //           // Text(
    //           //   "data of lang",
    //           //   style: TextStyle(color: CustomTheme.appColors.bjpOrange),
    //           // ),
    //           ),
    //       Expanded(
    //         child: ListView.builder(
    //             scrollDirection: Axis.horizontal,
    //             physics: BouncingScrollPhysics(),
    //             itemCount: languages.length,
    //             itemBuilder: (context, index) {
    //               var txt = languages.keys.elementAt(index);
    //               var font = languages[languages.keys.elementAt(index)];
    //               return GestureDetector(
    //                 onTap: () {
    //                   setState(() {
    //                     String sltlang = languages.keys.elementAt(index);
    //                     if (sltlang != "English") {
    //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                         backgroundColor: CustomTheme.appColors.primaryColor,
    //                         content: Container(
    //                           height: 50,
    //                           child: Text(
    //                             "Support for this language will be added soon",
    //                             style: TextStyle(
    //                                 color: CustomTheme.appColors.white),
    //                           ),
    //                         ),
    //                       ));
    //                       return;
    //                     }
    //                     sp.setString("selectedLang", sltlang);
    //                     sp.setString(
    //                         "selectedFont", languages[sltlang].toString());
    //                   });
    //                 },
    //                 child: Container(
    //                     margin: EdgeInsets.all(3),
    //                     padding: EdgeInsets.symmetric(horizontal: 8),
    //                     decoration: BoxDecoration(
    //                         color: sp.getString("selectedLang") ==
    //                                 languages.keys.elementAt(index)
    //                             ? CustomTheme.appColors.primaryColor
    //                             : CustomTheme.appColors.white,
    //                         borderRadius: BorderRadius.circular(6)),
    //                     child: Center(
    //                         child: Text(
    //                       txt,
    //                       style: TextStyle(
    //                         color: sp.getString("selectedLang") ==
    //                                 languages.keys.elementAt(index)
    //                             ? CustomTheme.appColors.white
    //                             : CustomTheme.appColors.primaryColor,
    //                         fontFamily: font,
    //                       ),
    //                     ))),
    //               );
    //             }),
    //       ),
    //     ]),
    //   ),
    // );
    // return Container(
    //   height: 70,
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     color: CustomTheme.appColors.white,
    //     // boxShadow: [
    //     //   BoxShadow(
    //     //     color: CustomTheme.appColors.black.withOpacity(0.3),
    //     //     spreadRadius: 5,
    //     //     blurRadius: 7,
    //     //     offset: Offset(0, 0), // changes position of shadow
    //     //   ),
    //     // ],
    //   ),
    //   child: Padding(
    //     padding: EdgeInsets.symmetric(horizontal: 10),
    //     child: Container(
    //       height: 50,
    //       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(6),
    //           child: Container(
    //             height: 50,
    //             width: 50,
    //             color: CustomTheme.appColors.primaryColor,
    //             child: Image.network(assets[3].url),
    //           ),
    //         ),
    //         Expanded(
    //             child: Center(
    //           child: Text(texts[7].text,
    //               style: TextStyle(
    //                   fontSize: double.parse(texts[7].size),
    //                   color: CustomTheme.appColors.primaryColor)),
    //         )),
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(6),
    //           child: Container(
    //             height: 50,
    //             width: 50,
    //             color: CustomTheme.appColors.primaryColor,
    //             child: Image.network(assets[2].url),
    //           ),
    //         ),
    //       ]),
    //     ),
    //   ),
    // );
  }

  void setServices(List<Services> getservices) {
    for (var i = 0; i < getservices.length; i++) {
      services.add(getservices[i].service);
    }
  }

  Widget UpdateApp() {
    if (Platform.isIOS) {
      return new CupertinoAlertDialog(
        title: Text(updateAvailable),
        content: Text(updateMessage),
        actions: <Widget>[
          TextButton(
            child: Text(updateNow),
            onPressed: () => launch(APP_STORE_URL),
          )
        ],
      );
    } else {
      return new AlertDialog(
        title: Text(updateAvailable),
        content: Text(updateMessage),
        actions: <Widget>[
          TextButton(
              child: Text(updateNow), onPressed: () => launch(PLAY_STORE_URL))
        ],
      );
    }
  }

  void setMarkers(List<Talents> talents) {
    markers.clear();
    for (var i = 0; i < talents.length; i++) {
      Marker resultMarker = Marker(
          onTap: () {
            setState(() {
              talentInfo = true;
              selectedTalent = talents[i];
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(double.parse(talents[i].lat),
                          double.parse(talents[i].lng)),
                      zoom: 10)));
            });
          },
          markerId: MarkerId(talents[i].id),
          position: LatLng(
              double.parse(talents[i].lat), double.parse(talents[i].lng)),
          icon: BitmapDescriptor.defaultMarker);

      markers.add(resultMarker);
    }
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

  Future<void> navigateToSearchScreen(BuildContext context, String type) async {
    searchResult = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen(searchType: type)),
    );

    if (searchResult != null) {
      if (searchResult['id'] != null) {
        // ScaffoldMessenger.of(context)
        //   ..removeCurrentSnackBar()
        //   ..showSnackBar(SnackBar(content: Text(searchResult['id'])));

        final response = await post(
            Uri.parse(BASE_URL + "user/get_talent_details"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body:
                jsonEncode(<String, String>{"talent_id": searchResult['id']}));
        final activity = getTalentDetailsResponseApiFromJson(response.body);

        // _flipController.flipcard();
        setState(() {
          selectedTalent = activity.talentDetails[0];
          // isFliped = true;
          // _profileView = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfileView(selectedTalent: selectedTalent)),
        );
      }

      if (searchResult['service'] != null) {
        // ScaffoldMessenger.of(context)
        //   ..removeCurrentSnackBar()
        //   ..showSnackBar(SnackBar(content: Text(searchResult['service'])));

        BlocProvider.of<GmapsBloc>(context)
            .add(LoadMarkersEventService(searchResult['service']));
        setState(
          () {
            talentInfo = false;
          },
        );
      }
    }
  }

  loginOrRegister(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/loginScreen");
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.primaryColor,
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 35,
                  padding: EdgeInsets.all(10),
                  // child: SvgPicture.asset(
                  //     "assets/right_arrow.svg"),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login to OneBellani",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 35,
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset("assets/right_arrow.svg"),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.primaryColor,
            ),
            child: ListView.builder(
                itemCount: 3,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: CustomTheme.appColors.primaryColor50,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(children: [
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.secondaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6))),
                        child: Text("Map listing for better"),
                      ),
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.secondaryColor,
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            "khadgfv ajlhfbv jahbf vjahbfvfjkahbf ajlhfbv ajhdbfaldjf lkajdnfblahdf ajbhfljad fladjhbjkad "),
                      ),
                    ]),
                  );
                }),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/registerScreen");
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.primaryColor,
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 35,
                  padding: EdgeInsets.all(10),
                  // child: SvgPicture.asset(
                  //     "assets/right_arrow.svg"),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Register for OneBellani",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 35,
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset("assets/right_arrow.svg"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  postOrManageRequirement(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/postDeal");
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.primaryColor,
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 35,
                  padding: EdgeInsets.all(10),
                  // child: SvgPicture.asset(
                  //     "assets/right_arrow.svg"),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Post a deal",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 35,
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset("assets/right_arrow.svg"),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.primaryColor,
            ),
            child: ListView.builder(
                itemCount: 3,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: CustomTheme.appColors.primaryColor50,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(children: [
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.secondaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6))),
                        child: Text("Map listing for better"),
                      ),
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.secondaryColor,
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            "khadgfv ajlhfbv jahbf vjahbfvfjkahbf ajlhfbv ajhdbfaldjf lkajdnfblahdf ajbhfljad fladjhbjkad "),
                      ),
                    ]),
                  );
                }),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/manageDeals");
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.primaryColor,
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 35,
                  padding: EdgeInsets.all(10),
                  // child: SvgPicture.asset(
                  //     "assets/right_arrow.svg"),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Manage deals",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 35,
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset("assets/right_arrow.svg"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void getToken() async {
    if (!sp.containsKey("selectedLang")) {
      setState(() {
        sp.setString("selectedLang", "English");
        sp.setString("selectedFont", "AvenirNext");
      });
    }
    token = sp.getString("token");
  }

  profileDropDown(BuildContext context, GotAccountState state) {
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: CustomTheme.appColors.primaryColor,
        // borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _logout = true;
                  });
                },
                child: Container(
                  height: 30,
                  width: 30,
                  color: CustomTheme.appColors.secondaryColor,
                  child: SvgPicture.asset("assets/logout.svg"),
                ),
              )),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _controller.reverse().whenComplete(() {
                  setState(() {
                    _expanded = false;
                    _headerClicked = false;
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 0, right: 1),
                      child: SvgPicture.asset("assets/username@.svg")),
                  Text(
                    state.account.username,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: GestureDetector(
                onTap: () async {
                  Navigator.pushNamed(context, "/editProfileScreen");
                  // sp.remove("token");
                },
                child: Container(
                  height: 30,
                  width: 30,
                  color: CustomTheme.appColors.secondaryColor,
                  child: SvgPicture.asset("assets/edit.svg"),
                ),
              )),
        ],
      ),
    );
  }

  List<DateTime> getDatesInMonth(DateTime startDate, DateTime endDate) {
    days.clear();
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(DateTime(
          startDate.year,
          startDate.month,
          // In Dart you can set more than. 30 days, DateTime will do the trick
          startDate.day + i));
    }
    return days;
  }

  scrollableIcons(Dashboard? dashboard) {
    return Container(
      height: 50,
      color: CustomTheme.appColors.secondaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard!.phoneClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/viewCallers");
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btph.svg")),
                ),
              ),
            ),
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard.whatsappClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/viewWhatsappClick");
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btwa.svg")),
                ),
              ),
            ),
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard.bmClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      // padding: EdgeInsets.only(top: 30),
                      backgroundColor: CustomTheme.appColors.white,
                      content: Container(
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          'Bellani Messenger will launch soon!',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: sp.getString("selectedFont"),
                              color: CustomTheme.appColors.secondaryColor),
                        ),
                      ),
                    ));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btbm.svg")),
                ),
              ),
            ),
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard.fbClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/facebookClicks");
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btfb.svg")),
                ),
              ),
            ),
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard.instaClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/instaClicks");
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btig.svg")),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  dayCalender() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        color: CustomTheme.appColors.primaryColor,
      ),
      child: Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: CustomTheme.appColors.secondaryColor,
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _yearSelected = true;
                _monthSelected = false;
                _selectedDate = 32;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomTheme.appColors.primaryColor,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedMonth < 10
                          ? "0" + selectedMonth.toString()
                          : selectedMonth.toString(),
                      style: TextStyle(
                        color: CustomTheme.appColors.white,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      selectedYear.toString(),
                      style: TextStyle(
                        color: CustomTheme.appColors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                color: CustomTheme.appColors.secondaryColor,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DateFormat formatter = DateFormat("dd");
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = index;
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: _selectedDate == index
                                ? CustomTheme.appColors.primaryColor
                                : null,
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatter.format(days[index]),
                                style: TextStyle(
                                  color: CustomTheme.appColors.white,
                                  fontSize: 26,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                  height: 15,
                                  width: 15,
                                  child: index == 29
                                      ? SvgPicture.asset("assets/noti_dot.svg")
                                      : null),
                            ]),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
  }

  monthCalender() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        color: CustomTheme.appColors.primaryColor,
      ),
      child: Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: CustomTheme.appColors.secondaryColor,
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _yearSelected = false;
                _monthSelected = false;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomTheme.appColors.primaryColor,
              ),
              child: Center(
                child: Text(
                  selectedYear.toString(),
                  style: TextStyle(
                    color: CustomTheme.appColors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                color: CustomTheme.appColors.secondaryColor,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: months.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _yearSelected = true;
                          _monthSelected = true;
                          selectedMonth = months[index];
                          firstDayOfMonth =
                              new DateTime(selectedYear, selectedMonth, 1);
                          lastDayOfMonth =
                              new DateTime(selectedYear, selectedMonth + 1, 0);
                          days =
                              getDatesInMonth(firstDayOfMonth, lastDayOfMonth);
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                months[index] < 10
                                    ? "0" + months[index].toString()
                                    : months[index].toString(),
                                style: TextStyle(
                                  color: CustomTheme.appColors.white,
                                  fontSize: 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                selectedYear.toString(),
                                style: TextStyle(
                                  color: CustomTheme.appColors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
  }

  yearCalender() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        color: CustomTheme.appColors.primaryColor,
      ),
      child: Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: CustomTheme.appColors.secondaryColor,
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _yearSelected = false;
                _monthSelected = false;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomTheme.appColors.primaryColor,
              ),
              child: Center(
                child: SvgPicture.asset("assets/calendar.svg"),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                color: CustomTheme.appColors.secondaryColor,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: years.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedYear = years[index];
                          _yearSelected = true;
                          _monthSelected = false;
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            years[index].toString(),
                            style: TextStyle(
                              color: CustomTheme.appColors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
  }

  void insertInSp(GotAccountState state) {
    Account user = state.account;
    // encode / convert object into json string
    String account = AccountApiToJson(user);
    //save the data into sharedPreferences using key-value pairs
    sp.setString('userdata', account);
  }

  talentNotifications(Dashboard? dashboard) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            color: CustomTheme.appColors.primaryColor,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.secondaryColor,
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset("assets/app_icon.png"),
                  ),
                ),
                Expanded(
                  child: scrollableIcons(dashboard),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/talentDashboard",
                        arguments: {"dashboard": dashboard});
                  },
                  child: Container(
                    height: 50,
                    width: 35,
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.all(8),
                    color: CustomTheme.appColors.secondaryColor,
                    child: SvgPicture.asset("assets/right_arrow.svg"),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 60,
          width: double.infinity,
          // padding: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6)),
            color: CustomTheme.appColors.primaryColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_showLocations) {
                                _showLocations = false;
                              } else {
                                _showLocations = true;
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 10, right: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              // color: CustomTheme.appColors.bjpOrange,
                            ),
                            child: SvgPicture.asset("assets/location.svg"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/dealCenter");
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 10, right: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              // color: CustomTheme.appColors.bjpOrange,
                            ),
                            child: SvgPicture.asset("assets/deal_center.svg"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/collabCenter");
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 10, right: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.secondaryColor,
                            ),
                            child: SvgPicture.asset("assets/collab_center.svg"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/manageProducts");
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 10, right: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.secondaryColor,
                            ),
                            padding: EdgeInsets.all(7),
                            child: SvgPicture.asset("assets/rupee_tag.svg"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, "/managePaymentMethods");
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 10, right: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.secondaryColor,
                            ),
                            // padding: EdgeInsets.all(5),
                            child: SvgPicture.asset("assets/rupee.svg"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/editTalentProfile");
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 10, right: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.secondaryColor,
                            ),
                            padding: EdgeInsets.all(3),
                            child: SvgPicture.asset("assets/edit.svg"),
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
