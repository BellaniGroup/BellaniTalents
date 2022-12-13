import 'package:bellani_talents_market/screens/login/bloc/login_bloc.dart';
import 'package:bellani_talents_market/screens/otp/OtpScreen.dart';
import 'package:bellani_talents_market/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../main.dart';
import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../theme/custom_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool focused = false;

  @override
  void initState() {
    super.initState();
    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
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
                          // borderRadius: BorderRadius.only(
                          //   bottomLeft: Radius.circular(6),
                          //   bottomRight: Radius.circular(6),
                          // ),
                          color: CustomTheme.appColors.primaryColor,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: CustomTheme.appColors.black
                          //         .withOpacity(0.25),
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
                                  "OneBellani - Login",
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
                      login(),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  login() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          // color: CustomTheme.appColors.white,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(6),
                bottomLeft: Radius.circular(6)),
            color: CustomTheme.appColors.secondaryColor,
            // boxShadow: [
            //   BoxShadow(
            //     color: CustomTheme.appColors.black.withOpacity(0.3),
            //     blurRadius: 8,
            //     spreadRadius: 3,
            //     offset: const Offset(0, 8),
            //   ),
            // ],
          ),
          child: Column(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: CustomTheme.appColors.primaryColor50,
                ),
                child: Row(children: [
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/username_tag_maroon.svg"),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      focusNode: _textFocus,
                      cursorColor: CustomTheme.appColors.white,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CustomTheme.appColors.white, fontSize: 12),
                      decoration: InputDecoration(
                        // suffixIcon: Container(
                        //   height: 20,
                        //   width: 20,
                        //   margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                        //   // child: SvgPicture.asset("assets/edit.svg"),
                        // ),
                        contentPadding: EdgeInsets.only(bottom: 0),
                        filled: true,
                        hintText: focused ? "" : "Enter a username",
                        hintStyle: TextStyle(
                            height: 1.8, color: CustomTheme.appColors.white),
                        fillColor: CustomTheme.appColors.primaryColor50,
                        disabledBorder: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomTheme.appColors.primaryColor50,
                              width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomTheme.appColors.primaryColor50,
                              width: 0.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                      color: CustomTheme.appColors.primaryColor50,
                    ),
                    padding: EdgeInsets.all(5),
                  ),
                ]),
              ),
              GestureDetector(
                onTap: () async {
                  if (!_textController.text.isEmpty) {
                    var mobileValid =
                        await ApiService().verifyUsername(_textController.text);
                    if (mobileValid.available.contains("false")) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpScreen(
                                  otpType: "login",
                                  username: _textController.text,
                                  name: "null",
                                  mobile: "null",
                                  email: "null",
                                  dob: "null",
                                  gender: "null",
                                  locale: "null",
                                  code: "null",
                                )),
                      );
                    } else {
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
                          "Entered username is not registered",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  sp.getString("selectedFont"),
                                              color: CustomTheme
                                                  .appColors.secondaryColor),
                                        ),
                                      ),
                                    ));
                    }
                  } else {
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
                        "Please fill all fields",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  sp.getString("selectedFont"),
                                              color: CustomTheme
                                                  .appColors.secondaryColor),
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
                              "Log in to OneBellani",
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
          ),
        );
      },
    );
  }
}
