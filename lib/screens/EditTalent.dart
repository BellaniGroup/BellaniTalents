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
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../services/ApiService.dart';
import '../../../theme/custom_theme.dart';

class EditTalent extends StatefulWidget {
  const EditTalent({Key? key}) : super(key: key);

  @override
  State<EditTalent> createState() => _EditTalentState();
}

class _EditTalentState extends State<EditTalent> {
  TextEditingController _textController = new TextEditingController();
  TextEditingController _textController2 = new TextEditingController();
  TextEditingController _textController3 = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  FocusNode _textFocus2 = new FocusNode();
  FocusNode _textFocus3 = new FocusNode();
  bool focused = false;
  bool focused2 = false;
  bool focused3 = false;
  bool _show = false;
  var locale, code, number;
  final now = DateTime.now();
  Account user = AccountApiFromJson(sp.getString("userdata")!);
  var selectedGender, selectedDob;
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');

  @override
  initState() {
    super.initState();
    selectedGender = user.gender;
    selectedDob = user.dob;

    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    _textController.text = user.name;
    _textFocus2.addListener(onChange);
    _textController2.addListener(onChange);
    _textController2.text = user.phone;
    _textFocus3.addListener(onChange);
    _textController3.addListener(onChange);
    _textController3.text = user.email;
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
              bottomSheet: _showBottomSheet(now),
              body: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_show) {
                      _show = false;
                    }
                  });
                },
                child: SafeArea(
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
                                      "Edit Talents",
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
                                cursorColor: CustomTheme.appColors.white,
                                textInputAction: TextInputAction.go,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: CustomTheme.appColors.white,
                                    fontSize: 12),
                                decoration: InputDecoration(
                                  suffixIcon: Container(
                                    height: 20,
                                    width: 20,
                                    margin: EdgeInsets.only(
                                        left: 20, top: 5, bottom: 5),
                                    child: SvgPicture.asset("assets/edit.svg"),
                                  ),
                                  contentPadding: EdgeInsets.only(bottom: 0),
                                  filled: true,
                                  hintText: focused ? "" : user.name,
                                  hintStyle: TextStyle(
                                      height: 1.8,
                                      color: CustomTheme.appColors.white),
                                  fillColor:
                                      CustomTheme.appColors.primaryColor50,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomTheme
                                            .appColors.primaryColor50,
                                        width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomTheme
                                            .appColors.primaryColor50,
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
                                cursorColor: CustomTheme.appColors.white,
                                textInputAction: TextInputAction.go,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: CustomTheme.appColors.white,
                                    fontSize: 12),
                                decoration: InputDecoration(
                                  suffixIcon: Container(
                                    height: 20,
                                    width: 20,
                                    margin: EdgeInsets.only(
                                        left: 20, top: 5, bottom: 5),
                                    child: SvgPicture.asset("assets/edit.svg"),
                                  ),
                                  contentPadding: EdgeInsets.only(bottom: 0),
                                  filled: true,
                                  hintText: focused ? "" : "Enter new name",
                                  hintStyle: TextStyle(
                                      height: 1.8,
                                      color: CustomTheme.appColors.white),
                                  fillColor:
                                      CustomTheme.appColors.primaryColor50,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomTheme
                                            .appColors.primaryColor50,
                                        width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomTheme
                                            .appColors.primaryColor50,
                                        width: 0.0),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            if (!_textController.text.isEmpty ||
                                !_textController2.text.isEmpty ||
                                !_textController3.text.isEmpty) {
                              var mobileValid =
                                  await ApiService().verifyMobile(number, code);
                              if (mobileValid.available.contains("true")) {
                                var emailValid = await ApiService()
                                    .verifyEmail(_textController3.text);
                                if (emailValid.available.contains("true")) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpScreen(
                                              otpType: "edit_profile",
                                              username: "null",
                                              name: _textController.text,
                                              mobile: _textController2.text,
                                              email: _textController3.text,
                                              dob: "null",
                                              gender: "null",
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
                                  backgroundColor: CustomTheme.appColors.white,
                                  content: Container(
                                    height: 32,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No changes",
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
                                        "Save changes",
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
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  void onChange() {
    String searchText = _textController.text;
    bool hasFocus = _textFocus.hasFocus;

    if (hasFocus) {
      setState(() {
        focused = true;
        if (_textController.text == user.name) {
          _textController.text = "";
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
        if (_textController2.text == user.phone) {
          _textController2.text = "";
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
        if (_textController3.text == user.email) {
          _textController3.text = "";
        }
      });
    } else {
      setState(() {
        focused3 = false;
      });
    }
  }

  Widget? _showBottomSheet(now) {
    if (_show) {
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
          //     return Container(
          //       height: 200,
          //       width: double.infinity,
          //       color: CustomTheme.appColors.white,
          //       alignment: Alignment.center,
          //       child: GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             _show = false;
          //           });
          //         },
          //         child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(
          //                 "Enter one time password",
          //                 style: TextStyle(
          //                     fontSize: 19,
          //                     color: CustomTheme.appColors.secondaryColor),
          //               ),
          //               Container(
          //                 height: 40,
          //                 width: double.infinity,
          //                 margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: [
          //                     Container(
          //                       height: 40,
          //                       width: 36,
          //                       alignment: Alignment.center,
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(6),
          //                         color: CustomTheme.appColors.secondaryColor,
          //                       ),
          //                       child: TextFormField(
          //                           cursorColor: CustomTheme.appColors.white,
          //                           textInputAction: TextInputAction.go,
          //                           keyboardType: TextInputType.multiline,
          //                           maxLines: null,
          //                           textAlign: TextAlign.center,
          //                           style: TextStyle(
          //                               color: CustomTheme.appColors.white,
          //                               fontSize: 12),
          //                           decoration: InputDecoration(
          //                             contentPadding: EdgeInsets.only(bottom: 0),
          //                             filled: true,
          //                             fillColor:
          //                                 CustomTheme.appColors.secondaryColor,
          //                             // disabledBorder: InputBorder.none,
          //                             // enabledBorder: OutlineInputBorder(
          //                             //   borderSide: BorderSide(
          //                             //       color: CustomTheme
          //                             //           .appColors.secondaryColor,
          //                             //       width: 0.0),
          //                             // ),
          //                             // focusedBorder: OutlineInputBorder(
          //                             //   borderSide: BorderSide(
          //                             //       color: CustomTheme
          //                             //           .appColors.secondaryColor,
          //                             //       width: 0.0),
          //                             // ),
          //                           )),
          //                     ),
          //                     Container(
          //                       height: 40,
          //                       width: 36,
          //                       alignment: Alignment.center,
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(6),
          //                         color: CustomTheme.appColors.secondaryColor,
          //                       ),
          //                     ),
          //                     Container(
          //                       height: 40,
          //                       width: 36,
          //                       alignment: Alignment.center,
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(6),
          //                         color: CustomTheme.appColors.secondaryColor,
          //                       ),
          //                     ),
          //                     Container(
          //                       height: 40,
          //                       width: 36,
          //                       alignment: Alignment.center,
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(6),
          //                         color: CustomTheme.appColors.secondaryColor,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ]),
          //       ),
          //     );
        },
      );
    } else {
      return null;
    }
  }
}
