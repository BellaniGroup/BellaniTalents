import 'package:bellani_talents_market/model/VerifyUsernameResponse.dart';
import 'package:bellani_talents_market/screens/otp/OtpScreen.dart';
import 'package:bellani_talents_market/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../main.dart';
import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../theme/custom_theme.dart';
import '../otp/bloc/otp_bloc.dart';
import 'bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  TextEditingController _otpController = new TextEditingController();
  TextEditingController _otpController2 = new TextEditingController();
  TextEditingController _otpController3 = new TextEditingController();
  TextEditingController _otpController4 = new TextEditingController();
  TextEditingController _textController = new TextEditingController();
  TextEditingController _textController2 = new TextEditingController();
  TextEditingController _textController3 = new TextEditingController();
  TextEditingController _textController4 = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  FocusNode _textFocus2 = new FocusNode();
  FocusNode _textFocus3 = new FocusNode();
  FocusNode _textFocus4 = new FocusNode();
  bool focused = false;
  bool focused2 = false;
  bool focused3 = false;
  bool focused4 = false;
  final GlobalKey<FormState> _otpKey = GlobalKey();
  var focusNode0 = FocusNode();
  var focusNode1 = FocusNode();
  var focusNode2 = FocusNode();
  var focusNode3 = FocusNode();
  bool _showDatePicker = false;
  var selectedGender, selectedDob;
  final now = DateTime.now();
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');
  List<String> genders = ["Male", "Female"];
  bool _agreeTerms = false, reachedBottom = false;
  var locale = "IN", code = "+91", number;
  var _controller = ScrollController();

  @override
  void initState() {
    selectedDob = "Select Dob";

    super.initState();
    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    _textFocus2.addListener(onChange);
    _textController2.addListener(onChange);
    _textFocus3.addListener(onChange);
    _textController3.addListener(onChange);

    _controller.addListener(() {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - 70) {
        setState(() {
          reachedBottom = true;
        });
      } else {
        setState(() {
          reachedBottom = false;
        });
      }
    });
  }

  void onChange() {
    String searchText = _textController.text;
    bool hasFocus = _textFocus.hasFocus;

    if (hasFocus) {
      setState(() {
        focused = true;
        // dismiss bottom sheet if open
        if (_showDatePicker) {
          _showDatePicker = false;
        }
      });
    } else {
      setState(() {
        focused = false;
      });
    }

    String searchText2 = _textController2.text;
    bool hasFocus2 = _textFocus2.hasFocus;

    if (hasFocus2) {
      setState(() {
        focused2 = true;
        // dismiss bottom sheet if open
        if (_showDatePicker) {
          _showDatePicker = false;
        }
      });
    } else {
      setState(() {
        focused2 = false;
      });
    }

    String searchText3 = _textController3.text;
    bool hasFocus3 = _textFocus3.hasFocus;

    if (hasFocus3) {
      setState(() {
        focused3 = true;
        // dismiss bottom sheet if open
        if (_showDatePicker) {
          _showDatePicker = false;
        }
      });
    } else {
      setState(() {
        focused3 = false;
      });
    }

    String searchText4 = _textController4.text;
    bool hasFocus4 = _textFocus4.hasFocus;

    if (hasFocus4) {
      setState(() {
        focused4 = true;
        // dismiss bottom sheet if open
        if (_showDatePicker) {
          _showDatePicker = false;
        }
      });
    } else {
      setState(() {
        focused4 = false;
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
            BlocProvider<RegisterBloc>(
                create: (context) => RegisterBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: CustomTheme.appColors.primaryColor,
              bottomSheet: _showBottomSheet(now),
              body: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_showDatePicker) {
                      _showDatePicker = false;
                    }
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
                                  child: SvgPicture.asset(
                                      "assets/left_arrow_white.svg")),
                            ),
                            Expanded(
                              child: Center(
                                child: MarqueeWidget(
                                  animationDuration:
                                      Duration(milliseconds: 1000),
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
                        // register(),
                        registerNew(),
                        Expanded(
                          child: Column(children: [
                            Expanded(
                              child: Column(children: [
                                Container(
                                  height: 30,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: CustomTheme.appColors.primaryColor50,
                                  ),
                                  child: Text(
                                    "Terms and conditions",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: CustomTheme.appColors.white,
                                    ),
                                    child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            "hjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\n",
                                            style: TextStyle(
                                                color: CustomTheme
                                                    .appColors.secondaryColor),
                                          ),
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_agreeTerms) {
                                      setState(() {
                                        _agreeTerms = false;
                                      });
                                    } else {
                                      setState(() {
                                        _agreeTerms = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6)),
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                    ),
                                    child: Row(
                                      children: [
                                        if (!_agreeTerms)
                                          Container(
                                            height: 20,
                                            width: 20,
                                            margin: EdgeInsets.only(
                                                left: 5, right: 10),
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: SvgPicture.asset(
                                                "assets/tick_unselected.svg"),
                                          ),
                                        if (_agreeTerms)
                                          Container(
                                            height: 20,
                                            width: 20,
                                            margin: EdgeInsets.only(
                                                left: 5, right: 10),
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: SvgPicture.asset(
                                                "assets/tick_selected.svg"),
                                          ),
                                        Text("Accept terms and conditions")
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_agreeTerms) {
                                  if (!_textController.text.isEmpty &&
                                      !_textController2.text.isEmpty &&
                                      !_textController3.text.isEmpty &&
                                      !_textController4.text.isEmpty &&
                                      selectedDob != "Select Dob" &&
                                      selectedGender != null) {
                                    var usernameValid = await ApiService()
                                        .verifyUsername(_textController.text);
                                    if (usernameValid.available
                                        .contains("true")) {
                                      var mobileValid = await ApiService()
                                          .verifyMobile(number, code);
                                      if (mobileValid.available
                                          .contains("true")) {
                                        var emailValid = await ApiService()
                                            .verifyEmail(_textController4.text);
                                        if (emailValid.available
                                            .contains("true")) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OtpScreen(
                                                      otpType: "register",
                                                      username:
                                                          _textController.text,
                                                      name:
                                                          _textController2.text,
                                                      mobile:
                                                          _textController3.text,
                                                      email:
                                                          _textController4.text,
                                                      dob: selectedDob,
                                                      gender: selectedGender,
                                                      code: code,
                                                      locale: locale,
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
                                              "Entered email is already registered",
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
                                            "Entered mobile number is already registered",
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
                                          "This username is already taken",
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
                                      "Please agree terms and conditions",
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
                                      child: SvgPicture.asset(
                                          "assets/right_arrow.svg"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget? _showBottomSheet(now) {
    if (_showDatePicker &&
        !(WidgetsBinding.instance.window.viewInsets.bottom > 0.0)) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 180,
            color: CustomTheme.appColors.primaryColor50,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: DatePickerWidget(
              looping: true, // default is not looping
              firstDate: new DateTime(now.year - 100), //DateTime(1960),
              lastDate: new DateTime(now.year - 13, now.month, now.day),
              initialDate: new DateTime(now.year - 30), // DateTime(1994),
              dateFormat:
                  // "MM-dd(E)",
                  "dd/MMMM/yyyy",
              //     locale: DatePicker.localeFromString('he'),
              onChange: (DateTime newDate, _a) {
                setState(() {
                  selectedDob = formattedDate.format(newDate);
                });
              },
              pickerTheme: DateTimePickerTheme(
                backgroundColor: CustomTheme.appColors.primaryColor50,
                itemTextStyle: TextStyle(
                    color: CustomTheme.appColors.white,
                    fontSize: 19,
                    fontFamily: "AvenirNext"),
                dividerColor: CustomTheme.appColors.primaryColor,
              ),
            ),
          );
        },
      );
    } else {
      return null;
    }
  }

  // register() {
  //   return BlocBuilder<RegisterBloc, RegisterState>(
  //     builder: (context, state) {
  //       if (state is UserRegisteredState) {
  //         return Expanded(
  //           child: Container(
  //             margin: EdgeInsets.only(top: 20),
  //             child: Column(children: [
  //               Text(
  //                 "Welcome to OneBellani!",
  //                 style: TextStyle(fontSize: 24),
  //               ),
  //               Text("Your new account is now ready!",
  //                   style: TextStyle(fontSize: 18)),
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.of(context).pushNamedAndRemoveUntil(
  //                       '/', (Route<dynamic> route) => false);
  //                 },
  //                 child: Container(
  //                   margin: EdgeInsets.only(top: 20),
  //                   padding: EdgeInsets.all(10),
  //                   decoration: BoxDecoration(
  //                     color: CustomTheme.appColors.primaryColor50,
  //                     borderRadius: BorderRadius.circular(6),
  //                   ),
  //                   child: Text("Go to home ->"),
  //                 ),
  //               )
  //             ]),
  //           ),
  //         );
  //       }
  //       return Container(
  //         // color: CustomTheme.appColors.white,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(6),
  //           color: CustomTheme.appColors.secondaryColor,
  //           boxShadow: [
  //             BoxShadow(
  //               color: CustomTheme.appColors.black.withOpacity(0.3),
  //               blurRadius: 8,
  //               spreadRadius: 3,
  //               offset: const Offset(0, 8),
  //             ),
  //           ],
  //         ),
  //         child: Padding(
  //           padding: EdgeInsets.all(10),
  //           child: Column(
  //             children: [
  //               ClipRRect(
  //                   borderRadius: BorderRadius.circular(6),
  //                   child: Container(
  //                     height: 30,
  //                     color: CustomTheme.appColors.primaryColor,
  //                     child: Center(
  //                       child: TextFormField(
  //                           controller: _textController,
  //                           focusNode: _textFocus,
  //                           cursorColor: CustomTheme.appColors.white,
  //                           textInputAction: TextInputAction.go,
  //                           maxLines: 1,
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: CustomTheme.appColors.white,
  //                               fontSize: 12),
  //                           decoration: InputDecoration(
  //                             contentPadding: EdgeInsets.zero,
  //                             filled: false,
  //                             fillColor: CustomTheme.appColors.white,
  //                             disabledBorder: InputBorder.none,
  //                             hintText:
  //                                 focused ? "" : "Enter your legal full name",
  //                             hintStyle: TextStyle(
  //                                 height: 1.8,
  //                                 color: CustomTheme.appColors.white),
  //                             enabledBorder: OutlineInputBorder(
  //                               borderSide: BorderSide(
  //                                   color: CustomTheme.appColors.secondaryColor,
  //                                   width: 0.0),
  //                             ),
  //                             focusedBorder: OutlineInputBorder(
  //                               borderSide: BorderSide(
  //                                   color: CustomTheme.appColors.secondaryColor,
  //                                   width: 0.0),
  //                             ),
  //                           )),
  //                     ),
  //                   )),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(6),
  //                     child: Container(
  //                       height: 30,
  //                       color: CustomTheme.appColors.primaryColor,
  //                       child: Row(children: [
  //                         Expanded(
  //                           child: TextFormField(
  //                             controller: _textController2,
  //                             focusNode: _textFocus2,
  //                             cursorColor: CustomTheme.appColors.white,
  //                             textInputAction: TextInputAction.go,
  //                             maxLines: 1,
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 color: CustomTheme.appColors.white,
  //                                 fontSize: 12),
  //                             decoration: InputDecoration(
  //                               contentPadding: EdgeInsets.zero,
  //                               filled: false,
  //                               fillColor: CustomTheme.appColors.white,
  //                               disabledBorder: InputBorder.none,
  //                               hintText: focused2
  //                                   ? ""
  //                                   : "Enter your desired username",
  //                               hintStyle: TextStyle(
  //                                   height: 1.8,
  //                                   color: CustomTheme.appColors.white),
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(
  //                                     color:
  //                                         CustomTheme.appColors.secondaryColor,
  //                                     width: 0.0),
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(
  //                                     color:
  //                                         CustomTheme.appColors.secondaryColor,
  //                                     width: 0.0),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ]),
  //                     )),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(6),
  //                     child: Container(
  //                       height: 30,
  //                       color: CustomTheme.appColors.primaryColor,
  //                       child: IntlPhoneField(
  //                         controller: _textController3,
  //                         focusNode: _textFocus3,
  //                         initialCountryCode: "IN",
  //                         countries: countriesList,
  //                         dropdownIcon: Icon(
  //                           Icons.arrow_drop_down,
  //                           color: CustomTheme.appColors.white,
  //                         ),
  //                         pickerDialogStyle: PickerDialogStyle(
  //                           searchFieldCursorColor: CustomTheme.appColors.white,
  //                           // listTileDivider: Divider(thickness: 1, color: CustomTheme.appColors.white,),
  //                           backgroundColor:
  //                               CustomTheme.appColors.secondaryColor,
  //                           searchFieldInputDecoration: InputDecoration(
  //                             counterText: "",
  //                             contentPadding: EdgeInsets.zero,
  //                             filled: false,
  //                             suffixIcon: Icon(
  //                               Icons.search,
  //                               color: CustomTheme.appColors.white,
  //                             ),
  //                             // fillColor: CustomTheme.appColors.white,
  //                             hintText: "Select country",
  //                             hintStyle: TextStyle(
  //                                 height: 1.8,
  //                                 color: CustomTheme.appColors.white),
  //                             labelStyle:
  //                                 TextStyle(color: CustomTheme.appColors.white),
  //                             // enabledBorder: OutlineInputBorder(
  //                             //   borderSide: BorderSide(
  //                             //       color: CustomTheme.appColors.white,
  //                             //       width: 0.0),
  //                             // ),
  //                             focusedBorder: UnderlineInputBorder(
  //                               borderSide: BorderSide(
  //                                   color: CustomTheme.appColors.white),
  //                             ),
  //                           ),
  //                           countryNameStyle:
  //                               TextStyle(color: CustomTheme.appColors.white),
  //                           countryCodeStyle:
  //                               TextStyle(color: CustomTheme.appColors.white),
  //                         ),
  //                         cursorColor: CustomTheme.appColors.white,
  //                         textInputAction: TextInputAction.go,
  //                         textAlign: TextAlign.center,
  //                         keyboardType: TextInputType.number,
  //                         style: TextStyle(
  //                             color: CustomTheme.appColors.white, fontSize: 12),
  //                         inputFormatters: <TextInputFormatter>[
  //                           FilteringTextInputFormatter.digitsOnly,
  //                         ],
  //                         disableLengthCheck: true,
  //                         decoration: InputDecoration(
  //                           counterText: "",
  //                           contentPadding: EdgeInsets.zero,
  //                           filled: false,
  //                           fillColor: CustomTheme.appColors.white,
  //                           disabledBorder: InputBorder.none,
  //                           hintText:
  //                               focused3 ? "" : "Enter your mobile number",
  //                           errorStyle: TextStyle(height: 0),
  //                           focusedErrorBorder: InputBorder.none,
  //                           errorBorder: InputBorder.none,
  //                           errorMaxLines: 1,
  //                           hintStyle: TextStyle(
  //                               height: 1.8,
  //                               color: CustomTheme.appColors.white),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(
  //                                 color: CustomTheme.appColors.secondaryColor,
  //                                 width: 0.0),
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(
  //                                 color: CustomTheme.appColors.secondaryColor,
  //                                 width: 0.0),
  //                           ),
  //                         ),
  //                         onChanged: (phone) {
  //                           locale = phone.countryISOCode;
  //                           code = phone.countryCode;
  //                           number = phone.number;
  //                         },
  //                         onCountryChanged: (country) {
  //                           print('Country changed to: ' + country.name);
  //                         },
  //                       ),
  //                     )),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     if (_agreeTerms) {
  //                       setState(() {
  //                         _agreeTerms = false;
  //                       });
  //                     } else {
  //                       setState(() {
  //                         _agreeTerms = true;
  //                       });
  //                     }
  //                   },
  //                   child: Row(
  //                     children: [
  //                       if (!_agreeTerms)
  //                         ClipRRect(
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(6),
  //                             bottomLeft: Radius.circular(6),
  //                           ),
  //                           child: Container(
  //                             height: 30,
  //                             width: 30,
  //                             color: CustomTheme.appColors.primaryColor,
  //                             child: Center(
  //                               child: SvgPicture.asset(
  //                                   "assets/tick_unselected.svg"),
  //                             ),
  //                           ),
  //                         ),
  //                       if (_agreeTerms)
  //                         ClipRRect(
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(6),
  //                             bottomLeft: Radius.circular(6),
  //                           ),
  //                           child: Container(
  //                             height: 30,
  //                             width: 30,
  //                             color: CustomTheme.appColors.primaryColor,
  //                             child: Center(
  //                               child: SvgPicture.asset(
  //                                   "assets/tick_selected.svg"),
  //                             ),
  //                           ),
  //                         ),
  //                       Expanded(
  //                         child: Padding(
  //                           padding: EdgeInsets.only(left: 0),
  //                           child: ClipRRect(
  //                               borderRadius: BorderRadius.only(
  //                                 topRight: Radius.circular(6),
  //                                 bottomRight: Radius.circular(6),
  //                               ),
  //                               child: Container(
  //                                 height: 30,
  //                                 color: CustomTheme.appColors.primaryColor,
  //                                 child: Center(
  //                                     child: Text(
  //                                   "I agree to all the terms and conditions",
  //                                   style: TextStyle(
  //                                       color: CustomTheme.appColors.white,
  //                                       fontSize: 12),
  //                                 )),
  //                               )),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(6),
  //                     child: Container(
  //                       height: 30,
  //                       color: CustomTheme.appColors.primaryColor,
  //                       child: Row(children: [
  //                         GestureDetector(
  //                           onTap: () async {
  //                             if (_agreeTerms) {
  //                               if (!_textController.text.isEmpty ||
  //                                   !_textController2.text.isEmpty ||
  //                                   !_textController3.text.isEmpty) {
  //                                 var usernameValid = await ApiService()
  //                                     .verifyUsername(_textController2.text);
  //                                 if (usernameValid.available
  //                                     .contains("true")) {
  //                                   var mobileValid = await ApiService()
  //                                       .verifyMobile(number, code);
  //                                   if (mobileValid.available
  //                                       .contains("true")) {
  //                                     ScaffoldMessenger.of(context)
  //                                         .showSnackBar(SnackBar(
  //                                       backgroundColor:
  //                                           CustomTheme.appColors.primaryColor,
  //                                       content: Text(
  //                                         "Otp sent",
  //                                         style: TextStyle(
  //                                             color:
  //                                                 CustomTheme.appColors.white),
  //                                       ),
  //                                     ));
  //                                   } else {
  //                                     ScaffoldMessenger.of(context)
  //                                         .showSnackBar(SnackBar(
  //                                       backgroundColor:
  //                                           CustomTheme.appColors.primaryColor,
  //                                       content: Text(
  //                                         "Entered mobile number is already registered",
  //                                         style: TextStyle(
  //                                             color:
  //                                                 CustomTheme.appColors.white),
  //                                       ),
  //                                     ));
  //                                   }
  //                                 } else {
  //                                   ScaffoldMessenger.of(context)
  //                                       .showSnackBar(SnackBar(
  //                                     backgroundColor:
  //                                         CustomTheme.appColors.primaryColor,
  //                                     content: Text(
  //                                       "This username is already taken",
  //                                       style: TextStyle(
  //                                           color: CustomTheme.appColors.white),
  //                                     ),
  //                                   ));
  //                                 }
  //                               } else {
  //                                 ScaffoldMessenger.of(context)
  //                                     .showSnackBar(SnackBar(
  //                                   backgroundColor:
  //                                       CustomTheme.appColors.primaryColor,
  //                                   content: Text(
  //                                     "Please fill all fields",
  //                                     style: TextStyle(
  //                                         color: CustomTheme.appColors.white),
  //                                   ),
  //                                 ));
  //                               }
  //                             } else {
  //                               ScaffoldMessenger.of(context)
  //                                   .showSnackBar(SnackBar(
  //                                 backgroundColor:
  //                                     CustomTheme.appColors.primaryColor,
  //                                 content: Text(
  //                                   "Please agree terms and conditions",
  //                                   style: TextStyle(
  //                                       color: CustomTheme.appColors.white),
  //                                 ),
  //                               ));
  //                             }
  //                           },
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               color: CustomTheme.appColors.secondaryColor,
  //                               borderRadius: BorderRadius.circular(6),
  //                             ),
  //                             padding: EdgeInsets.all(3),
  //                             margin: EdgeInsets.only(left: 4),
  //                             child: MarqueeWidget(
  //                               animationDuration: Duration(milliseconds: 1000),
  //                               pauseDuration: Duration(milliseconds: 800),
  //                               backDuration: Duration(milliseconds: 1000),
  //                               child: Padding(
  //                                 padding: EdgeInsets.symmetric(horizontal: 8),
  //                                 child: Text(
  //                                   "Get one time password",
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                       color: CustomTheme.appColors.white,
  //                                       fontSize: 12),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Spacer(),
  //                         Container(
  //                             decoration: BoxDecoration(
  //                               color: CustomTheme.appColors.white,
  //                               borderRadius: BorderRadius.circular(5),
  //                             ),
  //                             child: Form(
  //                               key: _otpKey,
  //                               child: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceEvenly,
  //                                   children: [
  //                                     Container(
  //                                       width: 4,
  //                                       height: 1,
  //                                     ),
  //                                     Container(
  //                                       height: 20,
  //                                       width: 18,
  //                                       margin:
  //                                           EdgeInsets.symmetric(vertical: 5),
  //                                       padding: EdgeInsets.only(left: 3),
  //                                       decoration: BoxDecoration(
  //                                           border: Border.all(
  //                                             color: CustomTheme
  //                                                 .appColors.secondaryColor,
  //                                           ),
  //                                           color: CustomTheme
  //                                               .appColors.secondaryColor,
  //                                           borderRadius:
  //                                               const BorderRadius.all(
  //                                                   Radius.circular(5))),
  //                                       child: TextFormField(
  //                                         focusNode: focusNode0,
  //                                         controller: _otpController,
  //                                         onChanged: (value) {
  //                                           if (value.length == 1) {
  //                                             FocusScope.of(context)
  //                                                 .requestFocus(focusNode1);
  //                                           }
  //                                         },
  //                                         style: const TextStyle(
  //                                           height: 1.2,
  //                                           fontSize: 12,
  //                                         ),
  //                                         inputFormatters: <TextInputFormatter>[
  //                                           FilteringTextInputFormatter
  //                                               .digitsOnly,
  //                                         ],
  //                                         maxLength: 1,
  //                                         textAlign: TextAlign.center,
  //                                         keyboardType: TextInputType.number,
  //                                         decoration: const InputDecoration(
  //                                             border: InputBorder.none,
  //                                             counterText: ""),
  //                                         validator: (value) {
  //                                           if (value!.isEmpty) {
  //                                             return "";
  //                                           } else {
  //                                             return null;
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       width: 4,
  //                                       height: 1,
  //                                     ),
  //                                     Container(
  //                                       height: 20,
  //                                       width: 18,
  //                                       padding: EdgeInsets.only(left: 3),
  //                                       decoration: BoxDecoration(
  //                                           border: Border.all(
  //                                             color: CustomTheme
  //                                                 .appColors.secondaryColor,
  //                                           ),
  //                                           color: CustomTheme
  //                                               .appColors.secondaryColor,
  //                                           borderRadius:
  //                                               const BorderRadius.all(
  //                                                   Radius.circular(5))),
  //                                       child: TextFormField(
  //                                         controller: _otpController2,
  //                                         focusNode: focusNode1,
  //                                         onChanged: (value) {
  //                                           if (value.length == 1) {
  //                                             FocusScope.of(context)
  //                                                 .requestFocus(focusNode2);
  //                                           }
  //                                           if (value.isEmpty) {
  //                                             FocusScope.of(context)
  //                                                 .requestFocus(focusNode0);
  //                                           }
  //                                         },
  //                                         style: const TextStyle(
  //                                           fontSize: 12,
  //                                           height: 1.2,
  //                                         ),
  //                                         inputFormatters: <TextInputFormatter>[
  //                                           FilteringTextInputFormatter
  //                                               .digitsOnly,
  //                                         ],
  //                                         maxLength: 1,
  //                                         textAlign: TextAlign.center,
  //                                         keyboardType: TextInputType.number,
  //                                         decoration: const InputDecoration(
  //                                             border: InputBorder.none,
  //                                             counterText: ""),
  //                                         validator: (value) {
  //                                           if (value!.isEmpty) {
  //                                             return "";
  //                                           } else {
  //                                             return null;
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       width: 4,
  //                                       height: 1,
  //                                     ),
  //                                     Container(
  //                                       height: 20,
  //                                       width: 18,
  //                                       padding: EdgeInsets.only(left: 3),
  //                                       decoration: BoxDecoration(
  //                                           border: Border.all(
  //                                             color: CustomTheme
  //                                                 .appColors.secondaryColor,
  //                                           ),
  //                                           color: CustomTheme
  //                                               .appColors.secondaryColor,
  //                                           borderRadius:
  //                                               const BorderRadius.all(
  //                                                   Radius.circular(5))),
  //                                       child: TextFormField(
  //                                         focusNode: focusNode2,
  //                                         controller: _otpController3,
  //                                         onChanged: (value) {
  //                                           if (value.length == 1) {
  //                                             FocusScope.of(context)
  //                                                 .requestFocus(focusNode3);
  //                                           }
  //                                           if (value.isEmpty) {
  //                                             FocusScope.of(context)
  //                                                 .requestFocus(focusNode1);
  //                                           }
  //                                         },
  //                                         style: const TextStyle(
  //                                           fontSize: 12,
  //                                           height: 1.2,
  //                                         ),
  //                                         maxLength: 1,
  //                                         textAlign: TextAlign.center,
  //                                         keyboardType: TextInputType.number,
  //                                         inputFormatters: <TextInputFormatter>[
  //                                           FilteringTextInputFormatter
  //                                               .digitsOnly,
  //                                         ],
  //                                         decoration: const InputDecoration(
  //                                             border: InputBorder.none,
  //                                             counterText: ""),
  //                                         validator: (value) {
  //                                           if (value!.isEmpty) {
  //                                             return "";
  //                                           } else {
  //                                             return null;
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       width: 4,
  //                                       height: 1,
  //                                     ),
  //                                     Container(
  //                                       height: 20,
  //                                       width: 18,
  //                                       padding: EdgeInsets.only(left: 3),
  //                                       decoration: BoxDecoration(
  //                                           border: Border.all(
  //                                             color: CustomTheme
  //                                                 .appColors.secondaryColor,
  //                                           ),
  //                                           color: CustomTheme
  //                                               .appColors.secondaryColor,
  //                                           borderRadius:
  //                                               const BorderRadius.all(
  //                                                   Radius.circular(5))),
  //                                       child: TextFormField(
  //                                         controller: _otpController4,
  //                                         focusNode: focusNode3,
  //                                         onChanged: (value) {
  //                                           if (value.isEmpty) {
  //                                             FocusScope.of(context)
  //                                                 .requestFocus(focusNode2);
  //                                           }
  //                                         },
  //                                         style: const TextStyle(
  //                                           fontSize: 12,
  //                                           height: 1.2,
  //                                         ),
  //                                         maxLength: 1,
  //                                         inputFormatters: <TextInputFormatter>[
  //                                           FilteringTextInputFormatter
  //                                               .digitsOnly,
  //                                         ],
  //                                         textAlign: TextAlign.center,
  //                                         keyboardType: TextInputType.number,
  //                                         decoration: const InputDecoration(
  //                                             border: InputBorder.none,
  //                                             counterText: ""),
  //                                         validator: (value) {
  //                                           if (value!.isEmpty) {
  //                                             return "";
  //                                           } else {
  //                                             return null;
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       width: 4,
  //                                       height: 1,
  //                                     ),
  //                                   ]),
  //                             )),
  //                         GestureDetector(
  //                           onTap: () async {
  //                             if (_agreeTerms) {
  //                               if (!_textController.text.isEmpty ||
  //                                   !_textController2.text.isEmpty ||
  //                                   !_textController3.text.isEmpty) {
  //                                 var usernameValid = await ApiService()
  //                                     .verifyUsername(_textController2.text);
  //                                 if (usernameValid.available
  //                                     .contains("true")) {
  //                                   if (_otpKey.currentState!.validate() &&
  //                                       _otpController.text == "8" &&
  //                                       _otpController2.text == "9" &&
  //                                       _otpController3.text == "8" &&
  //                                       _otpController4.text == "9") {
  //                                     var mobileValid = await ApiService()
  //                                         .verifyMobile(number, code);
  //                                     if (mobileValid.available
  //                                         .contains("true")) {
  //                                       // BlocProvider.of<RegisterBloc>(context)
  //                                       //     .add(RegisterUser(
  //                                       //         _textController.text,
  //                                       //         _textController2.text,
  //                                       //         finalNumber));
  //                                     } else {
  //                                       ScaffoldMessenger.of(context)
  //                                           .showSnackBar(SnackBar(
  //                                         backgroundColor: CustomTheme
  //                                             .appColors.primaryColor,
  //                                         content: Text(
  //                                           "Entered mobile number is already registered",
  //                                           style: TextStyle(
  //                                               color: CustomTheme
  //                                                   .appColors.white),
  //                                         ),
  //                                       ));
  //                                     }
  //                                   } else {
  //                                     ScaffoldMessenger.of(context)
  //                                         .showSnackBar(SnackBar(
  //                                       backgroundColor:
  //                                           CustomTheme.appColors.primaryColor,
  //                                       content: Text(
  //                                         "Invalid OTP",
  //                                         style: TextStyle(
  //                                             color:
  //                                                 CustomTheme.appColors.white),
  //                                       ),
  //                                     ));
  //                                   }
  //                                 } else {
  //                                   ScaffoldMessenger.of(context)
  //                                       .showSnackBar(SnackBar(
  //                                     backgroundColor:
  //                                         CustomTheme.appColors.primaryColor,
  //                                     content: Text(
  //                                       "This username is already taken",
  //                                       style: TextStyle(
  //                                           color: CustomTheme.appColors.white),
  //                                     ),
  //                                   ));
  //                                 }
  //                               } else {
  //                                 ScaffoldMessenger.of(context)
  //                                     .showSnackBar(SnackBar(
  //                                   backgroundColor:
  //                                       CustomTheme.appColors.primaryColor,
  //                                   content: Text(
  //                                     "Please fill all fields",
  //                                     style: TextStyle(
  //                                         color: CustomTheme.appColors.white),
  //                                   ),
  //                                 ));
  //                               }
  //                             } else {
  //                               ScaffoldMessenger.of(context)
  //                                   .showSnackBar(SnackBar(
  //                                 backgroundColor:
  //                                     CustomTheme.appColors.primaryColor,
  //                                 content: Text(
  //                                   "Please agree terms and conditions",
  //                                   style: TextStyle(
  //                                       color: CustomTheme.appColors.white),
  //                                 ),
  //                               ));
  //                             }
  //                           },
  //                           child: Padding(
  //                             padding: EdgeInsets.only(left: 5),
  //                             child: ClipRRect(
  //                                 borderRadius: BorderRadius.circular(6),
  //                                 child: Container(
  //                                   height: 30,
  //                                   width: 30,
  //                                   color: CustomTheme.appColors.primaryColor,
  //                                   child: Center(
  //                                     child: SvgPicture.asset(
  //                                         "assets/tick_unselected.svg"),
  //                                   ),
  //                                 )),
  //                           ),
  //                         ),
  //                       ]),
  //                     )),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  registerNew() {
    return Column(
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
                style:
                    TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    // child: SvgPicture.asset("assets/edit.svg"),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0),
                  filled: true,
                  hintText: focused ? "" : "Enter your desired username",
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
          ]),
        ),
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
              child: SvgPicture.asset("assets/name_tag.svg"),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController2,
                focusNode: _textFocus2,
                cursorColor: CustomTheme.appColors.white,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    // child: SvgPicture.asset("assets/edit.svg"),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0),
                  filled: true,
                  hintText: focused2 ? "" : "Enter your legal full name",
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
          ]),
        ),
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
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: CustomTheme.appColors.secondaryColor,
                  borderRadius: BorderRadius.circular(6)),
              child: SvgPicture.asset("assets/call.svg"),
            ),
            Expanded(
              child: Container(
                height: 30,
                // padding: EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                    color: CustomTheme.appColors.primaryColor50,
                    borderRadius: BorderRadius.circular(6)),
                child: IntlPhoneField(
                  dropdownTextStyle: TextStyle(fontSize: 12),
                  controller: _textController3,
                  focusNode: _textFocus3,
                  initialCountryCode: "IN",
                  countries: countriesList,
                  dropdownIcon: Icon(
                    Icons.arrow_drop_down,
                    color: CustomTheme.appColors.white,
                  ),
                  pickerDialogStyle: PickerDialogStyle(
                    searchFieldCursorColor: CustomTheme.appColors.white,
                    // listTileDivider: Divider(thickness: 1, color: CustomTheme.appColors.white,),
                    backgroundColor: CustomTheme.appColors.secondaryColor,
                    searchFieldInputDecoration: InputDecoration(
                      counterText: "",
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                      suffixIcon: Icon(
                        Icons.search,
                        color: CustomTheme.appColors.white,
                      ),
                      // fillColor: CustomTheme.appColors.white,
                      hintText: "Select country",
                      hintStyle: TextStyle(
                          height: 1.8, color: CustomTheme.appColors.white),
                      labelStyle: TextStyle(
                          color: CustomTheme.appColors.secondaryColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomTheme.appColors.secondaryColor,
                            width: 0.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomTheme.appColors.secondaryColor),
                      ),
                    ),
                    countryNameStyle:
                        TextStyle(color: CustomTheme.appColors.white),
                    countryCodeStyle:
                        TextStyle(color: CustomTheme.appColors.white),
                  ),
                  cursorColor: CustomTheme.appColors.white,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      color: CustomTheme.appColors.white, fontSize: 12),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  disableLengthCheck: true,
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                    fillColor: CustomTheme.appColors.white,
                    disabledBorder: InputBorder.none,
                    suffixIcon: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      // child: SvgPicture.asset("assets/edit.svg"),
                    ),
                    hintText: focused3 ? "" : "Enter your mobile number",
                    errorStyle: TextStyle(height: 0),
                    focusedErrorBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    errorMaxLines: 1,
                    hintStyle: TextStyle(
                        height: 1.8, color: CustomTheme.appColors.white),
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
                  onChanged: (phone) {
                    number = phone.number;
                  },
                  onCountryChanged: (country) {
                    locale = country.code;
                    code = "+" + country.dialCode;
                    print('Country changed to: ' +
                        country.code +
                        country.dialCode);
                  },
                ),
              ),
            ),
          ]),
        ),
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
              child: SvgPicture.asset("assets/email_maroon.svg"),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController4,
                focusNode: _textFocus4,
                cursorColor: CustomTheme.appColors.white,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    // child: SvgPicture.asset("assets/edit.svg"),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0),
                  filled: true,
                  hintText: focused4 ? "" : "Enter your email address",
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
          ]),
        ),
        Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (!_showDatePicker &&
                      !(WidgetsBinding.instance.window.viewInsets.bottom >
                          0.0)) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _showDatePicker = true;
                  } else {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _showDatePicker = false;
                  }
                });
              },
              child: Container(
                height: 30,
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 5, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: CustomTheme.appColors.primaryColor50,
                ),
                child: Row(children: [
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.all(5),
                    child: Container(
                        height: 20,
                        width: 20,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.secondaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: SvgPicture.asset("assets/calendar.svg")),
                  ),
                  Expanded(
                      child: Text(
                    selectedDob,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  )),
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.all(5),
                    // child:
                    //     SvgPicture.asset("assets/edit.svg"),
                  ),
                ]),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 30,
              width: double.infinity,
              margin: EdgeInsets.only(left: 5, right: 10, top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomTheme.appColors.primaryColor50,
              ),
              child: Row(children: [
                Container(
                  height: 20,
                  width: 20,
                  margin: EdgeInsets.all(5),
                  child: SvgPicture.asset("assets/morf.svg"),
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: CustomTheme.appColors.secondaryColor,
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        alignment: Alignment.center,
                        icon: Visibility(
                          visible: false,
                          child: Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            // child: SvgPicture.asset(
                            //     "assets/edit.svg"),
                          ),
                        ),
                        //select a service
                        hint: MarqueeWidget(
                          animationDuration: Duration(milliseconds: 1000),
                          pauseDuration: Duration(milliseconds: 800),
                          backDuration: Duration(milliseconds: 1000),
                          child: Text("Select gender",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: CustomTheme.appColors.white)),
                        ),
                        items: genders.map((String dropDownString) {
                          return DropdownMenuItem<String>(
                            value: dropDownString,
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: MarqueeWidget(
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    pauseDuration: Duration(milliseconds: 800),
                                    backDuration: Duration(milliseconds: 1000),
                                    child: Text(
                                      dropDownString,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: CustomTheme.appColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        value: selectedGender,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: 20,
                  margin: EdgeInsets.all(5),
                  // child: SvgPicture.asset("assets/edit.svg"),
                ),
              ]),
            ),
          ),
        ]),
      ],
    );
  }
}
