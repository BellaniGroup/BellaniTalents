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

class ManageOneCollab extends StatefulWidget {
  const ManageOneCollab({Key? key}) : super(key: key);

  @override
  State<ManageOneCollab> createState() => _ManageOneCollab();
}

class _ManageOneCollab extends State<ManageOneCollab> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool focused = false;
  final safeAreaKey = GlobalKey();
  Set<Marker> markers = Set();
  var photo =
      "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=";
  Marker resultMarker = Marker(
      onTap: () {
        // setState(() {
        //   talentInfo = true;
        //   selectedTalent = talents[i];
        //   mapController.animateCamera(CameraUpdate.newCameraPosition(
        //       CameraPosition(
        //           target: LatLng(double.parse(talents[i].lat),
        //               double.parse(talents[i].lng)),
        //           zoom: 10)));
        // });
      },
      markerId: MarkerId("id"),
      position: LatLng(13.063208, 80.264596),
      icon: BitmapDescriptor.defaultMarker);
  final LatLng _center = const LatLng(9.561191, 96.767230);

  @override
  void initState() {
    super.initState();
    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
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
                key: safeAreaKey,
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
                                  "Manage collabs",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: 40,
                              color: CustomTheme.appColors.primaryColor,
                              child: SvgPicture.asset("assets/edit.svg"))
                        ]),
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
                                width: double.infinity,
                                height: 50,
                                padding: EdgeInsets.only(right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CustomTheme.appColors.primaryColor50,
                                ),
                                child: Row(children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.network(photo),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "@username",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  CustomTheme.appColors.white),
                                        ),
                                        Text(
                                          "service",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  CustomTheme.appColors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "6/20",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomTheme.appColors.white),
                                  ),
                                ]),
                              ),
                              Container(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(children: [
                                      Container(
                                        width: double.infinity,
                                        height: 30,
                                        margin: EdgeInsets.only(
                                            top: 5, left: 5, right: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6)),
                                          color: CustomTheme
                                              .appColors.primaryColor50,
                                        ),
                                        child: Container(
                                            width: double.infinity,
                                            height: 30,
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: CustomTheme
                                                  .appColors.secondaryColor,
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Row(children: [
                                              Expanded(
                                                  child: Text(
                                                      "Dancers - Bharatanatyam")),
                                              Text("6/14"),
                                            ])),
                                      ),
                                      Container(
                                          width: double.infinity,
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              top: 0, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                            color: CustomTheme
                                                .appColors.primaryColor50,
                                          ),
                                          child: Row(children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              padding: EdgeInsets.all(12),
                                              color: CustomTheme
                                                  .appColors.primaryColor50,
                                              child: SvgPicture.asset(
                                                  "assets/white_x.svg"),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemCount: 16,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      height: 40,
                                                      width: 40,
                                                      margin: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: CustomTheme
                                                              .appColors
                                                              .bjpOrange,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                    );
                                                  }),
                                            ),
                                          ]))
                                    ]);
                                  },
                                  itemCount: 3,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.primaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "Leave collab",
                          style: TextStyle(fontSize: 18),
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
