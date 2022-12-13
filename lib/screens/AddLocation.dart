import 'dart:convert';
import 'dart:io';

import 'package:bellani_talents_market/main.dart';
import 'package:bellani_talents_market/model/Account.dart';
import 'package:bellani_talents_market/model/MarqueeWidget.dart';
import 'package:bellani_talents_market/screens/otp/OtpScreen.dart';
import 'package:bellani_talents_market/screens/transaction/bloc/transaction_bloc.dart';
import 'package:bellani_talents_market/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../services/ApiService.dart';
import '../../../theme/custom_theme.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  TextEditingController _textController = new TextEditingController();
  TextEditingController _textController2 = new TextEditingController();
  TextEditingController _textController3 = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  FocusNode _textFocus2 = new FocusNode();
  FocusNode _textFocus3 = new FocusNode();
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(9.561191, 96.767230);
  bool focused = false;
  bool focused2 = false;
  bool focused3 = false;
  var locale, code, number;
  final now = DateTime.now();
  Account user = AccountApiFromJson(sp.getString("userdata")!);
  var selectedGender, selectedDob;
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');

  @override
  initState() {
    super.initState();
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
            BlocProvider<TransactionBloc>(
                create: (context) => TransactionBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
              backgroundColor: CustomTheme.appColors.primaryColor,
              body: SafeArea(
                child: Container(
                  width: double.infinity,
                  color: CustomTheme.appColors.secondaryColor,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                width: 35,
                                padding: EdgeInsets.all(10),
                                color: CustomTheme.appColors.primaryColor,
                                child: SvgPicture.asset(
                                    "assets/left_arrow_white.svg"),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Add Location",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 35,
                              padding: EdgeInsets.all(10),
                              color: CustomTheme.appColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 180,
                      //   color: CustomTheme.appColors.secondaryColor,
                      //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      //   child: Container(
                      //     padding: EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //         color: CustomTheme.appColors.primaryColor,
                      //         borderRadius: BorderRadius.circular(6)),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //             child: Container(
                      //           decoration: BoxDecoration(
                      //               color: CustomTheme.appColors.secondaryColor,
                      //               borderRadius: BorderRadius.circular(6)),
                      //           child: Column(
                      //             children: [
                      //               Container(
                      //                 height: 30,
                      //                 alignment: Alignment.center,
                      //                 child: Text(
                      //                   "Chennai",
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //               ),
                      //               Expanded(
                      //                 child: Container(
                      //                   width: double.infinity,
                      //                   color: CustomTheme
                      //                       .appColors.primaryColor50,
                      //                   padding:
                      //                       EdgeInsets.symmetric(vertical: 15),
                      //                   child: SvgPicture.asset(
                      //                       "assets/location_withoutbg.svg"),
                      //                 ),
                      //               ),
                      //               Container(
                      //                 height: 30,
                      //                 alignment: Alignment.center,
                      //                 child: Text(
                      //                   "Chennai",
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         )),
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         Expanded(
                      //             child: GestureDetector(
                      //           onTap: () {
                      //             Navigator.pushNamed(
                      //                 context, "/selectLocation");
                      //           },
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //                 color:
                      //                     CustomTheme.appColors.secondaryColor,
                      //                 borderRadius: BorderRadius.circular(6)),
                      //             child: Column(
                      //               children: [
                      //                 Container(
                      //                   height: 30,
                      //                   alignment: Alignment.center,
                      //                   child: Text(
                      //                     "Location 2",
                      //                     textAlign: TextAlign.center,
                      //                   ),
                      //                 ),
                      //                 Expanded(
                      //                   child: Container(
                      //                     width: double.infinity,
                      //                     color: CustomTheme
                      //                         .appColors.primaryColor50,
                      //                     padding: EdgeInsets.symmetric(
                      //                         vertical: 15),
                      //                     child: SvgPicture.asset(
                      //                         "assets/add.svg"),
                      //                   ),
                      //                 ),
                      //                 Container(
                      //                   height: 30,
                      //                   alignment: Alignment.center,
                      //                   child: Text(
                      //                     "Add",
                      //                     textAlign: TextAlign.center,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         )),
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         Expanded(
                      //             child: Container(
                      //           decoration: BoxDecoration(
                      //               color: CustomTheme.appColors.secondaryColor,
                      //               borderRadius: BorderRadius.circular(6)),
                      //           child: Column(
                      //             children: [
                      //               Container(
                      //                 height: 30,
                      //                 alignment: Alignment.center,
                      //                 child: Text(
                      //                   "Live",
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //               ),
                      //               Expanded(
                      //                 child: Container(
                      //                   width: double.infinity,
                      //                   color: CustomTheme
                      //                       .appColors.primaryColor50,
                      //                   padding:
                      //                       EdgeInsets.symmetric(vertical: 15),
                      //                   child: SvgPicture.asset(
                      //                       "assets/location_withoutbg.svg"),
                      //                 ),
                      //               ),
                      //               Container(
                      //                 height: 30,
                      //                 alignment: Alignment.center,
                      //                 child: Text(
                      //                   "Live",
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ))
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Column(children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: CustomTheme.appColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6))),
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                              "Select location 1",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                  color: CustomTheme.appColors.primaryColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                  child: GoogleMap(
                                    onTap: (argument) {
                                      // setState(
                                      //   () {
                                      //     talentInfo = false;
                                      //   },
                                      // );
                                    },
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      mapController = controller;
                                    },
                                    zoomControlsEnabled: false,
                                    mapToolbarEnabled: false,
                                    myLocationEnabled: true,
                                                    myLocationButtonEnabled: false,
                                    onCameraMove: (position) {
                                      var selectedLocation = position.target;
                                    },
                                    initialCameraPosition: CameraPosition(
                                      target: _center,
                                      zoom: 3.0,
                                    ),
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
                        ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, "/uploadTalentImage");
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
                                      "Save location",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 35,
                                padding: EdgeInsets.all(10),
                                child:
                                    SvgPicture.asset("assets/right_arrow.svg"),
                              ),
                            ],
                          ),
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
