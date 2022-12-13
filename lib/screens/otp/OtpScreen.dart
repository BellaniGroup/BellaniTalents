import 'package:bellani_talents_market/main.dart';
import 'package:bellani_talents_market/screens/IntermediateScreen.dart';
import 'package:bellani_talents_market/screens/otp/bloc/otp_bloc.dart';
import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/MarqueeWidget.dart';

class OtpScreen extends StatefulWidget {
  String otpType, username, name, mobile, email, dob, gender, code, locale;
  OtpScreen({
    Key? key,
    required String this.otpType,
    required String this.username,
    required String this.name,
    required String this.mobile,
    required String this.email,
    required String this.dob,
    required String this.gender,
    required String this.code,
    required String this.locale,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState(
      otpType, username, name, mobile, email, dob, gender, code, locale);
}

class _OtpScreenState extends State<OtpScreen> {
  String otpType, username, name, mobile, email, dob, gender, code, locale;
  _OtpScreenState(
      String this.otpType,
      String this.username,
      String this.name,
      String this.mobile,
      String this.email,
      String this.dob,
      String this.gender,
      String this.code,
      String this.locale);

  TextEditingController _otpController = new TextEditingController();
  TextEditingController _otpController2 = new TextEditingController();
  TextEditingController _otpController3 = new TextEditingController();
  TextEditingController _otpController4 = new TextEditingController();
  TextEditingController _otpController5 = new TextEditingController();
  TextEditingController _otpController6 = new TextEditingController();
  TextEditingController _otpController7 = new TextEditingController();
  TextEditingController _otpController8 = new TextEditingController();
  TextEditingController _otpController9 = new TextEditingController();
  TextEditingController _otpController10 = new TextEditingController();
  TextEditingController _otpController11 = new TextEditingController();
  TextEditingController _otpController12 = new TextEditingController();
  final GlobalKey<FormState> _mobileOtpKey = GlobalKey();
  final GlobalKey<FormState> _emailOtpKey = GlobalKey();
  var focusNode0 = FocusNode();
  var focusNode1 = FocusNode();
  var focusNode2 = FocusNode();
  var focusNode3 = FocusNode();
  var focusNode4 = FocusNode();
  var focusNode5 = FocusNode();
  var focusNode6 = FocusNode();
  var focusNode7 = FocusNode();
  var focusNode8 = FocusNode();
  var focusNode9 = FocusNode();
  var focusNode10 = FocusNode();
  var focusNode11 = FocusNode();

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
            BlocProvider<OtpBloc>(
                create: (context) => OtpBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
            // resizeToAvoidBottomInset: false,
            backgroundColor: CustomTheme.appColors.primaryColor,
            body: SafeArea(
              child: Container(
                color: CustomTheme.appColors.secondaryColor,
                child: Column(children: [
                  if (otpType == "register") registerOtp(),
                  if (otpType == "login") loginOtp(),
                  if (otpType == "name" || otpType == "email" || otpType == "mobile") editProfileOtp(),
                  if (otpType == "registerCompany") registerCompanyOtp(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  editProfileOtp() {
    return BlocBuilder<OtpBloc, OtpState>(
      builder: (context, state) {
        if (state is UserUpdatedState) {
          return Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              child: Column(children: [
                Text(
                  "Edited Profile",
                  style: TextStyle(fontSize: 24),
                ),
                Text("Your new profile is now ready!",
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
          );
        }
        return Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(6),
                //   bottomRight: Radius.circular(6),
                // ),
                color: CustomTheme.appColors.primaryColor,
                // boxShadow: [
                //   BoxShadow(
                //     color:
                //         CustomTheme.appColors.black.withOpacity(0.25),
                //     blurRadius: 3,
                //     spreadRadius: 0,
                //     offset: const Offset(0, 5),
                //   ),
                // ],
              ),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      color: CustomTheme.appColors.primaryColor,
                      padding: EdgeInsets.all(14),
                      child: SvgPicture.asset("assets/left_arrow_white.svg")),
                ),
                Expanded(
                  child: Center(
                    child: MarqueeWidget(
                      animationDuration: Duration(milliseconds: 1000),
                      pauseDuration: Duration(milliseconds: 800),
                      backDuration: Duration(milliseconds: 1000),
                      child: Text(
                        "Edit OneBellani",
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
            otpToMobile(),
            otpToEmail(),
            GestureDetector(
              onTap: () {
                if (_mobileOtpKey.currentState!.validate() &&
                    _emailOtpKey.currentState!.validate()) {
                  if (_otpController.text == "5" &&
                      _otpController2.text == "5" &&
                      _otpController3.text == "5" &&
                      _otpController4.text == "5" &&
                      _otpController5.text == "5" &&
                      _otpController6.text == "5") {
                    if (_otpController7.text == "5" &&
                        _otpController8.text == "5" &&
                        _otpController9.text == "5" &&
                        _otpController10.text == "5" &&
                        _otpController11.text == "5" &&
                        _otpController12.text == "5") {
                      if (otpType == "name") {
                        BlocProvider.of<OtpBloc>(context)
                            .add(UpdateUserNameEvent(sp.getString("token"), name));
                      }
                      if (otpType == "email") {
                        BlocProvider.of<OtpBloc>(context)
                            .add(UpdateUserEmailEvent(sp.getString("token"), email));
                      }
                       if (otpType == "mobile") {
                        BlocProvider.of<OtpBloc>(context)
                            .add(UpdateUserMobileEvent(sp.getString("token"), code, mobile, locale));
                      }
                    } else {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          // padding: EdgeInsets.only(top: 30),
                          backgroundColor: CustomTheme.appColors.white,
                          content: Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              "email otp invalid",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: sp.getString("selectedFont"),
                                  color: CustomTheme.appColors.secondaryColor),
                            ),
                          ),
                        ));
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        // padding: EdgeInsets.only(top: 30),
                        backgroundColor: CustomTheme.appColors.white,
                        content: Container(
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(
                            "mobile otp invalid",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: sp.getString("selectedFont"),
                                color: CustomTheme.appColors.secondaryColor),
                          ),
                        ),
                      ));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      // padding: EdgeInsets.only(top: 30),
                      backgroundColor: CustomTheme.appColors.white,
                      content: Container(
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          "Please fill all fields",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: sp.getString("selectedFont"),
                              color: CustomTheme.appColors.secondaryColor),
                        ),
                      ),
                    ));
                }
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
                            "Update OneBellani",
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
      },
    );
  }

  registerOtp() {
    return BlocBuilder<OtpBloc, OtpState>(
      builder: (context, state) {
        if (state is UserRegisteredState) {
          return Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              child: Column(children: [
                Text(
                  "Welcome to OneBellani!",
                  style: TextStyle(fontSize: 24),
                ),
                Text("Your new account is now ready!",
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
          );
        }
        return Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(6),
                //   bottomRight: Radius.circular(6),
                // ),
                color: CustomTheme.appColors.primaryColor,
                // boxShadow: [
                //   BoxShadow(
                //     color:
                //         CustomTheme.appColors.black.withOpacity(0.25),
                //     blurRadius: 3,
                //     spreadRadius: 0,
                //     offset: const Offset(0, 5),
                //   ),
                // ],
              ),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      color: CustomTheme.appColors.primaryColor,
                      padding: EdgeInsets.all(14),
                      child: SvgPicture.asset("assets/left_arrow_white.svg")),
                ),
                Expanded(
                  child: Center(
                    child: MarqueeWidget(
                      animationDuration: Duration(milliseconds: 1000),
                      pauseDuration: Duration(milliseconds: 800),
                      backDuration: Duration(milliseconds: 1000),
                      child: Text(
                        "OneBellani - Register",
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
            otpToMobile(),
            otpToEmail(),
            GestureDetector(
              onTap: () {
                if (_mobileOtpKey.currentState!.validate() &&
                    _emailOtpKey.currentState!.validate()) {
                  if (_otpController.text == "5" &&
                      _otpController2.text == "5" &&
                      _otpController3.text == "5" &&
                      _otpController4.text == "5" &&
                      _otpController5.text == "5" &&
                      _otpController6.text == "5") {
                    if (_otpController7.text == "5" &&
                        _otpController8.text == "5" &&
                        _otpController9.text == "5" &&
                        _otpController10.text == "5" &&
                        _otpController11.text == "5" &&
                        _otpController12.text == "5") {
                      BlocProvider.of<OtpBloc>(context).add(RegisterUser(
                          username,
                          name,
                          mobile,
                          email,
                          dob,
                          gender,
                          locale,
                          code));
                    } else {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          // padding: EdgeInsets.only(top: 30),
                          backgroundColor: CustomTheme.appColors.white,
                          content: Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              "email otp invalid",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: sp.getString("selectedFont"),
                                  color: CustomTheme.appColors.secondaryColor),
                            ),
                          ),
                        ));
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        // padding: EdgeInsets.only(top: 30),
                        backgroundColor: CustomTheme.appColors.white,
                        content: Container(
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(
                            "mobile otp invalid",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: sp.getString("selectedFont"),
                                color: CustomTheme.appColors.secondaryColor),
                          ),
                        ),
                      ));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      // padding: EdgeInsets.only(top: 30),
                      backgroundColor: CustomTheme.appColors.white,
                      content: Container(
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          "Please fill all fields",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: sp.getString("selectedFont"),
                              color: CustomTheme.appColors.secondaryColor),
                        ),
                      ),
                    ));
                }
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
                            "Complete registration",
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
      },
    );
  }

  loginOtp() {
    return BlocBuilder<OtpBloc, OtpState>(
      builder: (context, state) {
        if (state is LoggedInState) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return IntermediateScreen();
          }));
        }
        return Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(6),
                //   bottomRight: Radius.circular(6),
                // ),
                color: CustomTheme.appColors.primaryColor,
                // boxShadow: [
                //   BoxShadow(
                //     color:
                //         CustomTheme.appColors.black.withOpacity(0.25),
                //     blurRadius: 3,
                //     spreadRadius: 0,
                //     offset: const Offset(0, 5),
                //   ),
                // ],
              ),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      color: CustomTheme.appColors.primaryColor,
                      padding: EdgeInsets.all(14),
                      child: SvgPicture.asset("assets/left_arrow_white.svg")),
                ),
                Expanded(
                  child: Center(
                    child: MarqueeWidget(
                      animationDuration: Duration(milliseconds: 1000),
                      pauseDuration: Duration(milliseconds: 800),
                      backDuration: Duration(milliseconds: 1000),
                      child: Text(
                        "OneBellani - Register",
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
            otpToMobile(),
            GestureDetector(
              onTap: () async {
                if (_mobileOtpKey.currentState!.validate()) {
                  if (_otpController.text == "5" &&
                      _otpController2.text == "5" &&
                      _otpController3.text == "5" &&
                      _otpController4.text == "5" &&
                      _otpController5.text == "5" &&
                      _otpController6.text == "5") {
                    final ApiService _apiService = ApiService();
                    final activity = await _apiService.loginUser(username);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('token', activity.token);
                    Navigator.pushNamed(
                      context,
                      "/intermediateScreen",
                      arguments: {'talent': activity.talent},
                    );
                    // BlocProvider.of<OtpBloc>(context)
                    //     .add(LoginUserEvent(username,  (){
                    //         Navigator.pushNamed(context, "/");
                    //     } ));
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        // padding: EdgeInsets.only(top: 30),
                        backgroundColor: CustomTheme.appColors.white,
                        content: Container(
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(
                            "mobile otp invalid",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: sp.getString("selectedFont"),
                                color: CustomTheme.appColors.secondaryColor),
                          ),
                        ),
                      ));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      // padding: EdgeInsets.only(top: 30),
                      backgroundColor: CustomTheme.appColors.white,
                      content: Container(
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          "Please fill all fields",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: sp.getString("selectedFont"),
                              color: CustomTheme.appColors.secondaryColor),
                        ),
                      ),
                    ));
                }
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
                            "Complete login",
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
      },
      // ),
    );
  }

  otpToMobile() {
    return Container(
      height: 100,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          color: CustomTheme.appColors.primaryColor,
          borderRadius: BorderRadius.circular(6)),
      child: Column(children: [
        Container(
          height: 30,
          width: double.infinity,
          decoration: BoxDecoration(
              color: CustomTheme.appColors.primaryColor50,
              borderRadius: BorderRadius.circular(6)),
          child: Center(child: Text("Enter the code sent to your mobile")),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Form(
            key: _mobileOtpKey,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: CustomTheme.appColors.secondaryColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    focusNode: focusNode0,
                    controller: _otpController,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode1);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode1,
                    controller: _otpController2,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode2);
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode0);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode2,
                    controller: _otpController3,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode3);
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode1);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode3,
                    controller: _otpController4,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode4);
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode2);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode4,
                    controller: _otpController5,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode5);
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode3);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode5,
                    controller: _otpController6,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode4);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  otpToEmail() {
    return Container(
      height: 100,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          color: CustomTheme.appColors.primaryColor,
          borderRadius: BorderRadius.circular(6)),
      child: Column(children: [
        Container(
          height: 30,
          width: double.infinity,
          decoration: BoxDecoration(
              color: CustomTheme.appColors.primaryColor50,
              borderRadius: BorderRadius.circular(6)),
          child: Center(child: Text("Enter the code sent to your email")),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Form(
            key: _emailOtpKey,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: CustomTheme.appColors.secondaryColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    focusNode: focusNode6,
                    controller: _otpController7,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode7);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode7,
                    controller: _otpController8,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode8);
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode6);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode8,
                    controller: _otpController9,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode9);
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode7);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode9,
                    controller: _otpController10,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode10);
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode8);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode10,
                    controller: _otpController11,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).requestFocus(focusNode11);
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode9);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
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
                  child: TextFormField(
                    focusNode: focusNode11,
                    controller: _otpController12,
                    cursorColor: CustomTheme.appColors.white,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(focusNode10);
                      }
                    },
                    style: const TextStyle(
                      height: 1.2,
                      fontSize: 24,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        errorStyle: TextStyle(height: 0),
                        border: InputBorder.none,
                        counterText: ""),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      } else {
                        return null;
                      }
                    },
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  registerCompanyOtp() {
    return BlocBuilder<OtpBloc, OtpState>(
      builder: (context, state) {
        if (state is CompanyRegisteredState) {
          return Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              child: Column(children: [
                Text(
                  "Welcome to OneBellani!",
                  style: TextStyle(fontSize: 24),
                ),
                Text("Your new corporate account is now ready!",
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
          );
        }
        return Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(6),
                //   bottomRight: Radius.circular(6),
                // ),
                color: CustomTheme.appColors.primaryColor,
                // boxShadow: [
                //   BoxShadow(
                //     color:
                //         CustomTheme.appColors.black.withOpacity(0.25),
                //     blurRadius: 3,
                //     spreadRadius: 0,
                //     offset: const Offset(0, 5),
                //   ),
                // ],
              ),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      color: CustomTheme.appColors.primaryColor,
                      padding: EdgeInsets.all(14),
                      child: SvgPicture.asset("assets/left_arrow_white.svg")),
                ),
                Expanded(
                  child: Center(
                    child: MarqueeWidget(
                      animationDuration: Duration(milliseconds: 1000),
                      pauseDuration: Duration(milliseconds: 800),
                      backDuration: Duration(milliseconds: 1000),
                      child: Text(
                        "OneBellani - Register",
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
            otpToMobile(),
            otpToEmail(),
            GestureDetector(
              onTap: () {
                if (_mobileOtpKey.currentState!.validate() &&
                    _emailOtpKey.currentState!.validate()) {
                  if (_otpController.text == "5" &&
                      _otpController2.text == "5" &&
                      _otpController3.text == "5" &&
                      _otpController4.text == "5" &&
                      _otpController5.text == "5" &&
                      _otpController6.text == "5") {
                    if (_otpController7.text == "5" &&
                        _otpController8.text == "5" &&
                        _otpController9.text == "5" &&
                        _otpController10.text == "5" &&
                        _otpController11.text == "5" &&
                        _otpController12.text == "5") {
                      BlocProvider.of<OtpBloc>(context).add(CompanyRegister(
                          sp.getString("token").toString(),
                          username,
                          name,
                          mobile,
                          email,
                          dob,
                          gender,
                          locale,
                          code));
                    } else {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          // padding: EdgeInsets.only(top: 30),
                          backgroundColor: CustomTheme.appColors.white,
                          content: Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              "email otp invalid",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: sp.getString("selectedFont"),
                                  color: CustomTheme.appColors.secondaryColor),
                            ),
                          ),
                        ));
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        // padding: EdgeInsets.only(top: 30),
                        backgroundColor: CustomTheme.appColors.white,
                        content: Container(
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(
                            "mobile otp invalid",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: sp.getString("selectedFont"),
                                color: CustomTheme.appColors.secondaryColor),
                          ),
                        ),
                      ));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      // padding: EdgeInsets.only(top: 30),
                      backgroundColor: CustomTheme.appColors.white,
                      content: Container(
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          "Please fill all fields",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: sp.getString("selectedFont"),
                              color: CustomTheme.appColors.secondaryColor),
                        ),
                      ),
                    ));
                }
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
                            "Complete registration",
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
      },
    );
  }
}
