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

class EditOneBellani extends StatefulWidget {
  const EditOneBellani({Key? key}) : super(key: key);

  @override
  State<EditOneBellani> createState() => _EditOneBellaniState();
}

class _EditOneBellaniState extends State<EditOneBellani> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool focused = false;
  bool _show = false;
  var edit;
  var locale, code, number;
  final now = DateTime.now();
  Account user = AccountApiFromJson(sp.getString("userdata")!);
  var selectedGender, selectedDob;
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');

  @override
  initState() {
    super.initState();

    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    edit = arguments["edit"];

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
                                      "Edit OneBellani",
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
                        if (edit == "name")
                          Container(
                            height: 30,
                            width: double.infinity,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                  controller: _textController,
                                  focusNode: _textFocus,
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
                                      child:
                                          SvgPicture.asset("assets/edit.svg"),
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
                        if (edit == "email")
                          Container(
                            height: 30,
                            width: double.infinity,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.primaryColor50,
                            ),
                            child: Row(children: [
                              Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                                child:
                                    SvgPicture.asset("assets/email_maroon.svg"),
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
                                      color: CustomTheme.appColors.white,
                                      fontSize: 12),
                                  decoration: InputDecoration(
                                    suffixIcon: Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.only(
                                          left: 20, top: 5, bottom: 5),
                                      child:
                                          SvgPicture.asset("assets/edit.svg"),
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: 0),
                                    filled: true,
                                    hintText: focused ? "" : "Enter new email",
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
                        if (edit == "mobile")
                          Container(
                            height: 30,
                            width: double.infinity,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                  // margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: IntlPhoneField(
                                    controller: _textController,
                                    focusNode: _textFocus,
                                    initialCountryCode: user.locale,
                                    countries: countriesList,
                                    dropdownIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: CustomTheme.appColors.white,
                                    ),
                                    pickerDialogStyle: PickerDialogStyle(
                                      searchFieldCursorColor:
                                          CustomTheme.appColors.white,
                                      // listTileDivider: Divider(thickness: 1, color: CustomTheme.appColors.white,),
                                      backgroundColor:
                                          CustomTheme.appColors.secondaryColor,
                                      searchFieldInputDecoration:
                                          InputDecoration(
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
                                            height: 1.8,
                                            color: CustomTheme.appColors.white),
                                        labelStyle: TextStyle(
                                            color: CustomTheme
                                                .appColors.secondaryColor),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: CustomTheme
                                                  .appColors.secondaryColor,
                                              width: 0.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: CustomTheme
                                                  .appColors.secondaryColor),
                                        ),
                                      ),
                                      countryNameStyle: TextStyle(
                                          color: CustomTheme.appColors.white),
                                      countryCodeStyle: TextStyle(
                                          color: CustomTheme.appColors.white),
                                    ),
                                    cursorColor: CustomTheme.appColors.white,
                                    textInputAction: TextInputAction.go,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: CustomTheme.appColors.white,
                                        fontSize: 12),
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
                                        margin: EdgeInsets.only(
                                            left: 20, top: 5, bottom: 5),
                                        child:
                                            SvgPicture.asset("assets/edit.svg"),
                                      ),
                                      hintText:
                                          focused ? "" : "Enter new number",
                                      errorStyle: TextStyle(height: 0),
                                      focusedErrorBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      errorMaxLines: 1,
                                      hintStyle: TextStyle(
                                          height: 1.8,
                                          color: CustomTheme.appColors.white),
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
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            if (!_textController.text.isEmpty) {
                              if (edit == "mobile") {
                                var mobileAvailable = await ApiService()
                                    .verifyMobile(_textController.text,
                                        code != null ? code : user.countryCode);
                                if (mobileAvailable.available
                                    .contains("true")) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpScreen(
                                              otpType: edit,
                                              username: user.username,
                                              name: edit == "name"
                                                  ? _textController.text
                                                  : user.name,
                                              mobile: edit == "mobile"
                                                  ? _textController.text
                                                  : user.phone,
                                              email: edit == "email"
                                                  ? _textController.text
                                                  : user.email,
                                              dob: user.dob,
                                              gender: user.gender,
                                              code: edit == "mobile" &&
                                                      code != null
                                                  ? code
                                                  : user.countryCode,
                                              locale: edit == "mobile" &&
                                                      locale != null
                                                  ? locale
                                                  : user.locale,
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
                                          "This mobile number is already registered",
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
                              }
                              if (edit == "email") {
                                var emailAvailable = await ApiService()
                                    .verifyEmail(_textController.text);
                                if (emailAvailable.available.contains("true")) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpScreen(
                                              otpType: edit,
                                              username: user.username,
                                              name: edit == "name"
                                                  ? _textController.text
                                                  : user.name,
                                              mobile: edit == "mobile"
                                                  ? _textController.text
                                                  : user.phone,
                                              email: edit == "email"
                                                  ? _textController.text
                                                  : user.email,
                                              dob: user.dob,
                                              gender: user.gender,
                                              code: edit == "mobile" &&
                                                      code != null
                                                  ? code
                                                  : user.countryCode,
                                              locale: edit == "mobile" &&
                                                      locale != null
                                                  ? locale
                                                  : user.locale,
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
                                          "This email is already registered",
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
                              }
                              if (edit == "name") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                            otpType: edit,
                                            username: user.username,
                                            name: edit == "name"
                                                ? _textController.text
                                                : user.name,
                                            mobile: edit == "mobile"
                                                ? _textController.text
                                                : user.phone,
                                            email: edit == "email"
                                                ? _textController.text
                                                : user.email,
                                            dob: user.dob,
                                            gender: user.gender,
                                            code:
                                                edit == "mobile" && code != null
                                                    ? code
                                                    : user.countryCode,
                                            locale: edit == "mobile" &&
                                                    locale != null
                                                ? locale
                                                : user.locale,
                                          )),
                                );
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
