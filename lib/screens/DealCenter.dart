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

class DealCenter extends StatefulWidget {
  const DealCenter({Key? key}) : super(key: key);

  @override
  State<DealCenter> createState() => _DealCenter();
}

class _DealCenter extends State<DealCenter> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool focused = false;
  Set<Marker> markers = Set();
  final LatLng _center = const LatLng(9.561191, 96.767230);

  @override
  void initState() {
    super.initState();
    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    Marker resultMarker = Marker(
        onTap: () {
          Navigator.pushNamed(context, "/DealCenterDetails");
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
                                  "Deal center",
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/postDeal");
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: CustomTheme.appColors.primaryColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "Post a deals",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CustomTheme.appColors.primaryColor,
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
                                    pauseDuration: Duration(milliseconds: 800),
                                    backDuration: Duration(milliseconds: 1000),
                                    child: Text("Tap on an offer to view!",
                                        style: TextStyle(
                                            fontSize: 24,
                                            color:
                                                CustomTheme.appColors.white)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  // color: CustomTheme.appColors.bjpOrange,
                                  child: GoogleMap(
                                    onTap: (argument) {
                                      // setState(
                                      //   () {
                                      //     talentInfo = false;
                                      //   },
                                      // );
                                    },
                                    // onMapCreated: (GoogleMapController
                                    //     controller) {
                                    //   mapController = controller;
                                    // },
                                    zoomControlsEnabled: false,
                                    markers: markers,
                                    mapToolbarEnabled: false,
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: true,
                                    initialCameraPosition: CameraPosition(
                                      target: _center,
                                      zoom: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/manageDeals");
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: CustomTheme.appColors.primaryColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "Manage deals",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
