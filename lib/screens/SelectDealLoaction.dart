import 'package:bellani_talents_market/screens/login/bloc/login_bloc.dart';
import 'package:bellani_talents_market/screens/otp/OtpScreen.dart';
import 'package:bellani_talents_market/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../theme/custom_theme.dart';
import '../model/Success.dart';

class SelectDealLocation extends StatefulWidget {
  const SelectDealLocation({Key? key}) : super(key: key);

  @override
  State<SelectDealLocation> createState() => _SelectDealLocation();
}

class _SelectDealLocation extends State<SelectDealLocation> {
  List<String> services = ["s1", "s2", "s3"];
  List<String> categories = ["c1", "c2", "c3"];
  var selectedCategory, selectedServices;
  var selectedCategory2, selectedServices2;
  var focusNode0 = FocusNode();
  var focusNode1 = FocusNode();
  var focusNode2 = FocusNode();
  var focusNode3 = FocusNode();
  late LatLng selectedLocation;
  var deal_id;
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool focused = false;
  bool posted = false;
  Set<Marker> markers = Set();
  final LatLng _center = const LatLng(9.561191, 96.767230);

  @override
  void initState() {
    super.initState();
    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    Marker resultMarker = Marker(
        onTap: () {
          Navigator.pushNamed(context, "/SelectDealLocationDetails");
        },
        markerId: MarkerId("id"),
        position: LatLng(13.063208, 80.264596),
        icon: BitmapDescriptor.defaultMarker);
    markers.add(resultMarker);
  }

  void onChange() {
    String searchText = _textController.text;
    bool hasFocus = _textFocus.hasFocus;

    if (hasFocus) {
      setState(() {
        focused = true;
      });
    } else {
      setState(() {
        focused = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    deal_id = arguments["deal_id"];

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
              backgroundColor: CustomTheme.appColors.primaryColor,
              body: SafeArea(
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
                                  "Post a deal",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                          )
                        ]),
                      ),
                      if (!posted)
                        Expanded(
                          child: Column(children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Column(children: [
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      color: CustomTheme.appColors.primaryColor,
                                    ),
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor,
                                      ),
                                      child: Row(children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          margin: EdgeInsets.all(10),
                                          // child: SvgPicture.asset(
                                          //     "assets/add.svg"),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Tap to select a location!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(3),
                                          // child:
                                          //     SvgPicture.asset("assets/add.svg"),
                                        ),
                                      ]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                        child: Stack(children: [
                                          GoogleMap(
                                            onTap: (argument) {
                                              // setState(
                                              //   () {
                                              //     talentInfo = false;
                                              //   },
                                              // );
                                            },
                                            onMapCreated: (GoogleMapController
                                                controller) {
                                              // mapController = controller;
                                            },
                                            zoomControlsEnabled: false,
                                            mapToolbarEnabled: false,
                                            myLocationEnabled: true,
                                            myLocationButtonEnabled: false,
                                            onCameraMove: (position) {
                                              selectedLocation =
                                                  position.target;
                                            },
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: _center,
                                              zoom: 3.0,
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              child: SvgPicture.asset(
                                                  "assets/select_location.svg"),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Success suc = await ApiService().addLatLngDeal(
                                    deal_id,
                                    selectedLocation.latitude.toString(),
                                    selectedLocation.longitude.toString());
                                if (suc.status == "success") {
                                  setState(() {
                                    posted = true;
                                  });
                                }
                                // Navigator.pushNamed(
                                //     context, "/selectDealLocation");
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      child: SvgPicture.asset(
                                          "assets/right_arrow.svg"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      if (posted)
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 20),
                            child: Column(children: [
                              Text(
                                "Deal posted successfully!",
                                style: TextStyle(fontSize: 24),
                              ),
                              Text("Your new deal is now posted!",
                                  style: TextStyle(fontSize: 18)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/', (Route<dynamic> route) => false);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: CustomTheme.appColors.primaryColor50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text("Go to home ->"),
                                ),
                              )
                            ]),
                          ),
                        ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
