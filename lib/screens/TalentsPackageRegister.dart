import 'dart:convert';
import 'dart:io';

import 'package:bellani_talents_market/main.dart';
import 'package:bellani_talents_market/model/Account.dart';
import 'package:bellani_talents_market/model/AvailableCategories.dart';
import 'package:bellani_talents_market/model/AvailableServices.dart';
import 'package:bellani_talents_market/model/MarqueeWidget.dart';
import 'package:bellani_talents_market/model/TalentRegisterModel.dart';
import 'package:bellani_talents_market/screens/selectPlan/SelectPlanScreen.dart';
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

class TalentsPackageRegister extends StatefulWidget {
  const TalentsPackageRegister({Key? key}) : super(key: key);

  @override
  State<TalentsPackageRegister> createState() => _TalentsPackageRegisterState();
}

class _TalentsPackageRegisterState extends State<TalentsPackageRegister> {
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
  var locale2, code2, number2;
  final now = DateTime.now();
  DateTime _pickerDate = DateTime.now();
  var _apiService = ApiService();
  List<String> selectedLanguages = [];
  Account user = AccountApiFromJson(sp.getString("userdata")!);
  var selectedGender, selectedDob;
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');
  List<String> services = [];
  List<String> categories = [];
  List<String> categories2 = [];
  List<String> languages = [
    "English",
    "Hindi",
    "Tamil",
    "Malayalam",
    "Telugu",
    "Kannada"
  ];
  var token = sp.getString("token");
  var selectedCategory, selectedServices;
  var selectedCategory2, selectedServices2;
  var selectedLang;

  @override
  initState() {
    super.initState();

    getServices(token);
    selectedGender = user.gender;
    selectedDob = user.dob;

    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    _textFocus2.addListener(onChange);
    _textController2.addListener(onChange);
    _textFocus3.addListener(onChange);
    _textController3.addListener(onChange);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
        ],
        child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                                    "Talents package - Register",
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
                      Expanded(
                        child: Column(
                          children: [
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
                                      SvgPicture.asset("assets/name_tag.svg"),
                                ),
                                Expanded(
                                  child: Text(
                                    user.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  // child: SvgPicture.asset(
                                  //     "assets/name_tag.svg"),
                                ),
                              ]),
                            ),
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
                                      SvgPicture.asset("assets/stage_name.svg"),
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
                                      contentPadding:
                                          EdgeInsets.only(bottom: 0),
                                      filled: true,
                                      hintText: focused ? "" : "Stage name",
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
                                  child: SvgPicture.asset(
                                      "assets/username_tag_maroon.svg"),
                                ),
                                Expanded(
                                    child: Text(
                                  user.username,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )),
                                Container(
                                  height: 20,
                                  width: 35,
                                  margin: EdgeInsets.all(5),
                                  // child: SvgPicture.asset(
                                  //     "assets/username_tag_maroon.svg"),
                                ),
                              ]),
                            ),
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
                                      color:
                                          CustomTheme.appColors.secondaryColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: SvgPicture.asset("assets/call.svg"),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    // margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: CustomTheme
                                            .appColors.primaryColor50,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: IntlPhoneField(
                                      controller: _textController2,
                                      focusNode: _textFocus2,
                                      initialCountryCode: "IN",
                                      countries: countriesList,
                                      dropdownIcon: Icon(
                                        Icons.arrow_drop_down,
                                        color: CustomTheme.appColors.white,
                                      ),
                                      pickerDialogStyle: PickerDialogStyle(
                                        searchFieldCursorColor:
                                            CustomTheme.appColors.white,
                                        // listTileDivider: Divider(thickness: 1, color: CustomTheme.appColors.white,),
                                        backgroundColor: CustomTheme
                                            .appColors.secondaryColor,
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
                                              color:
                                                  CustomTheme.appColors.white),
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
                                          child: SvgPicture.asset(
                                              "assets/edit.svg"),
                                        ),
                                        hintText: focused2
                                            ? ""
                                            : "Primary phone number*",
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
                                        locale = phone.countryISOCode;
                                        code = phone.countryCode;
                                        number = phone.number;
                                      },
                                      onCountryChanged: (country) {
                                        code = "+" + country.dialCode;
                                        locale = country.code;

                                        print('Country changed to: ' +
                                            country.name +
                                            code +
                                            locale);
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                            ),
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
                                      color:
                                          CustomTheme.appColors.secondaryColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  child:
                                      SvgPicture.asset("assets/whatsapp.svg"),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    // margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: CustomTheme
                                            .appColors.primaryColor50,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: IntlPhoneField(
                                      controller: _textController3,
                                      focusNode: _textFocus3,
                                      initialCountryCode: "IN",
                                      countries: countriesList,
                                      dropdownIcon: Icon(
                                        Icons.arrow_drop_down,
                                        color: CustomTheme.appColors.white,
                                      ),
                                      pickerDialogStyle: PickerDialogStyle(
                                        searchFieldCursorColor:
                                            CustomTheme.appColors.white,
                                        // listTileDivider: Divider(thickness: 1, color: CustomTheme.appColors.white,),
                                        backgroundColor: CustomTheme
                                            .appColors.secondaryColor,
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
                                              color:
                                                  CustomTheme.appColors.white),
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
                                          child: SvgPicture.asset(
                                              "assets/edit.svg"),
                                        ),
                                        hintText: focused3
                                            ? ""
                                            : "Primary WhatsApp number*",
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
                                        locale2 = phone.countryISOCode;
                                        code2 = phone.countryCode;
                                        number2 = phone.number;
                                      },
                                      onCountryChanged: (country) {
                                        code2 = "+" + country.dialCode;
                                        locale2 = country.code;

                                        print('Country changed to: ' +
                                            country.name +
                                            code2 +
                                            locale2);
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                            ),
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
                                  child: SvgPicture.asset(
                                      "assets/email_maroon.svg"),
                                ),
                                Expanded(
                                  child: Text(
                                    user.email,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  // child: SvgPicture.asset(
                                  //     "assets/email_maroon.svg"),
                                ),
                              ]),
                            ),
                            Row(children: [
                              Expanded(
                                child: Container(
                                  height: 30,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 5, top: 10),
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
                                              color: CustomTheme
                                                  .appColors.secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: SvgPicture.asset(
                                              "assets/calendar.svg")),
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
                              Expanded(
                                child: Container(
                                  height: 30,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: 5, right: 10, top: 10),
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
                                          SvgPicture.asset("assets/morf.svg"),
                                    ),
                                    Expanded(
                                      child: Text(
                                        user.gender,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: CustomTheme.appColors.white),
                                      ),
                                      // child: DropdownButtonHideUnderline(
                                      //   child: Theme(
                                      //     data: Theme.of(context).copyWith(
                                      //       canvasColor: CustomTheme
                                      //           .appColors.secondaryColor,
                                      //     ),
                                      //     child: DropdownButton<String>(
                                      //       isExpanded: true,
                                      //       alignment: Alignment.center,
                                      //       icon: Visibility(
                                      //         visible: true,
                                      //         child: Container(
                                      //           height: 20,
                                      //           width: 20,
                                      //           margin: EdgeInsets.all(5),
                                      //           // child: SvgPicture.asset(
                                      //           //     "assets/edit.svg"),
                                      //         ),
                                      //       ),
                                      //       //select a service
                                      //       hint: Padding(
                                      //         padding: EdgeInsets.symmetric(
                                      //             horizontal: 10),
                                      //         child: MarqueeWidget(
                                      //           animationDuration:
                                      //               Duration(milliseconds: 1000),
                                      //           pauseDuration:
                                      //               Duration(milliseconds: 800),
                                      //           backDuration:
                                      //               Duration(milliseconds: 1000),
                                      //           child: Text("state.texts[4].text",
                                      //               style: TextStyle(
                                      //                   color: CustomTheme
                                      //                       .appColors.white)),
                                      //         ),
                                      //       ),
                                      //       items: genders
                                      //           .map((String dropDownString) {
                                      //         return DropdownMenuItem<String>(
                                      //           value: dropDownString,
                                      //           child: MediaQuery(
                                      //             data: MediaQuery.of(context)
                                      //                 .copyWith(
                                      //                     textScaleFactor: 1.0),
                                      //             child: Center(
                                      //               child: Padding(
                                      //                 padding: EdgeInsets.symmetric(
                                      //                     horizontal: 10),
                                      //                 child: MarqueeWidget(
                                      //                   animationDuration: Duration(
                                      //                       milliseconds: 1000),
                                      //                   pauseDuration: Duration(
                                      //                       milliseconds: 800),
                                      //                   backDuration: Duration(
                                      //                       milliseconds: 1000),
                                      //                   child: Text(
                                      //                     dropDownString,
                                      //                     textAlign:
                                      //                         TextAlign.center,
                                      //                     style: TextStyle(
                                      //                         fontSize: 12,
                                      //                         color: CustomTheme
                                      //                             .appColors.white),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         );
                                      //       }).toList(),
                                      //       onChanged: (String? newValue) {
                                      //         setState(() {
                                      //           selectedGender = newValue;
                                      //         });
                                      //       },
                                      //       value: selectedGender,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.all(5),
                                      // child: SvgPicture.asset("assets/morf.svg"),
                                    ),
                                  ]),
                                ),
                              ),
                            ]),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        height: 30,
                                        color: CustomTheme
                                            .appColors.secondaryColor,
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                canvasColor: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 30,
                                                    color: CustomTheme.appColors
                                                        .primaryColor50,
                                                    child: Row(children: [
                                                      Container(
                                                          height: 20,
                                                          width: 20,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          decoration: BoxDecoration(
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: SvgPicture.asset(
                                                              "assets/service_maroon.svg")),
                                                      Expanded(
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
                                                                    "Service 1*",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
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
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                  child: Center(
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
                                                                            fontSize:
                                                                                12,
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
                                                            getCategories(token,
                                                                newValue!);
                                                            setState(
                                                              () {
                                                                selectedCategory =
                                                                    null;
                                                                selectedServices =
                                                                    newValue;
                                                              },
                                                            );
                                                          },
                                                          value:
                                                              selectedServices,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        height: 30,
                                        color: CustomTheme
                                            .appColors.secondaryColor,
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                canvasColor: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0, right: 5),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 30,
                                                    color: CustomTheme.appColors
                                                        .primaryColor50,
                                                    child: Row(children: [
                                                      Container(
                                                          height: 20,
                                                          width: 20,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          decoration: BoxDecoration(
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: SvgPicture.asset(
                                                              "assets/service_maroon.svg")),
                                                      Expanded(
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          alignment:
                                                              Alignment.center,
                                                          icon: Visibility(
                                                              visible: false,
                                                              child: Icon(Icons
                                                                  .arrow_downward)),
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
                                                                    //select a category
                                                                    "Category 1*",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .white)),
                                                              ),
                                                            ),
                                                          ),
                                                          items: categories.map(
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
                                                                                CustomTheme.appColors.white,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(
                                                              () {
                                                                selectedCategory =
                                                                    newValue;
                                                              },
                                                            );
                                                          },
                                                          value:
                                                              selectedCategory,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        height: 30,
                                        color: CustomTheme
                                            .appColors.secondaryColor,
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                canvasColor: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 30,
                                                    color: CustomTheme.appColors
                                                        .primaryColor50,
                                                    child: Row(children: [
                                                      Container(
                                                          height: 20,
                                                          width: 20,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          decoration: BoxDecoration(
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: SvgPicture.asset(
                                                              "assets/service_maroon.svg")),
                                                      Expanded(
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          alignment:
                                                              Alignment.center,
                                                          icon: Visibility(
                                                              visible: false,
                                                              child: Icon(Icons
                                                                  .arrow_downward)),
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
                                                                    //select a category
                                                                    "Service 2",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
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
                                                                                CustomTheme.appColors.white,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            getCategories2(
                                                                token,
                                                                newValue!);
                                                            setState(
                                                              () {
                                                                selectedCategory2 =
                                                                    null;
                                                                selectedServices2 =
                                                                    newValue;
                                                              },
                                                            );
                                                          },
                                                          value:
                                                              selectedServices2,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        height: 30,
                                        color: CustomTheme
                                            .appColors.secondaryColor,
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                canvasColor: CustomTheme
                                                    .appColors.secondaryColor,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0, right: 5),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 30,
                                                    color: CustomTheme.appColors
                                                        .primaryColor50,
                                                    child: Row(children: [
                                                      Container(
                                                          height: 20,
                                                          width: 20,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          decoration: BoxDecoration(
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .secondaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: SvgPicture.asset(
                                                              "assets/service_maroon.svg")),
                                                      Expanded(
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          alignment:
                                                              Alignment.center,
                                                          icon: Visibility(
                                                              visible: false,
                                                              child: Icon(Icons
                                                                  .arrow_downward)),
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
                                                                    //select a category
                                                                    "Category 2",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: CustomTheme
                                                                            .appColors
                                                                            .white)),
                                                              ),
                                                            ),
                                                          ),
                                                          items: categories2
                                                              .map((String
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
                                                                                CustomTheme.appColors.white,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(
                                                              () {
                                                                selectedCategory2 =
                                                                    newValue;
                                                              },
                                                            );
                                                          },
                                                          value:
                                                              selectedCategory2,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (_show) {
                                              _show = false;
                                            } else {
                                              _show = true;
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          padding: EdgeInsets.only(
                                              left: 5, right: 10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              height: 30,
                                              color: CustomTheme
                                                  .appColors.primaryColor50,
                                              child: Row(children: [
                                                Container(
                                                    height: 20,
                                                    width: 20,
                                                    padding: EdgeInsets.all(2),
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    decoration: BoxDecoration(
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    child: SvgPicture.asset(
                                                        "assets/languages.svg")),
                                                Expanded(
                                                  child: Text(
                                                    selectedLanguages.isEmpty
                                                        ? "Languages (Minimum 1)*"
                                                        : selectedLanguages
                                                            .toString()
                                                            .replaceAll("[", "")
                                                            .replaceAll(
                                                                "]", ""),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: CustomTheme
                                                            .appColors.white),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!_textController.text.isEmpty) {
                            if (!_textController2.text.isEmpty) {
                              if (selectedServices != null &&
                                  selectedCategory != null) {
                                if (!selectedLanguages.isEmpty) {
                                  TalentRegisterModel talentRegisterdata =
                                      TalentRegisterModel(
                                          companyId: "0",
                                          name: _textController.text,
                                          primaryPhone: number,
                                          primaryPhoneCode: code,
                                          primaryPhoneLocale: locale,
                                          primaryWhatsapp: number2,
                                          primaryWhatsappCode: code2,
                                          primaryWhatsappLocale: locale2,
                                          primaryEmail: user.email,
                                          service: selectedServices,
                                          service2: selectedServices2 != null
                                              ? selectedServices2
                                              : "",
                                          category: selectedCategory,
                                          category2: selectedCategory2 != null
                                              ? selectedCategory2
                                              : "",
                                          languages: selectedLanguages
                                              .toString()
                                              .replaceAll("[", "")
                                              .replaceAll("]", ""));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectPlanScreen(
                                            talentRegisterdata:
                                                talentRegisterdata)),
                                  );
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
                                      "Please select a language known",
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
                                    "Select a service and category",
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
                                  "Fill a whatsapp number",
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
                                "Fill a stage name",
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
                                      "Select a plan",
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
              ),
            )),
      ),
    );
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

    String searchText2 = _textController2.text;
    bool hasFocus2 = _textFocus2.hasFocus;

    if (hasFocus2) {
      setState(() {
        focused2 = true;
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
              child: ListView.builder(
                  itemCount: languages.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedLanguages
                              .contains(languages.elementAt(index))) {
                            selectedLanguages
                                .remove(languages.elementAt(index));
                          } else {
                            if (selectedLanguages.length > 3) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  // padding: EdgeInsets.only(top: 30),
                                  backgroundColor: CustomTheme.appColors.white,
                                  content: Container(
                                    height: 32,
                                    alignment: Alignment.center,
                                    child: Text(
                                  "Maximum 4 languages",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily:
                                              sp.getString("selectedFont"),
                                          color: CustomTheme
                                              .appColors.secondaryColor),
                                    ),
                                  ),
                                ));
                            } else {
                              selectedLanguages.add(languages.elementAt(index));
                            }
                          }
                        });
                      },
                      child: Container(
                        height: 30,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            child: SvgPicture.asset("assets/languages.svg"),
                          ),
                          Expanded(
                              child: Text(
                            languages.elementAt(index),
                            textAlign: TextAlign.center,
                          )),
                          selectedLanguages.contains(languages.elementAt(index))
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  child: SvgPicture.asset(
                                      "assets/tick_maroon.svg"),
                                )
                              : Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  child: SvgPicture.asset(
                                      "assets/tick_unselected.svg"),
                                )
                        ]),
                      ),
                    );
                  }));
        },
      );
    } else {
      return null;
    }
  }

  void getServices(String? token) async {
    AvailableServices availableService =
        await _apiService.getAvailableServices(token!);
    services.clear();
    for (var i = 0; i < availableService.services.length; i++) {
      setState(() {
        services.add(availableService.services[i]);
      });
    }
  }

  void getCategories(String? token, String service) async {
    AvailableCategories availableCategories =
        await _apiService.getAvailableCategories(token!, service);
    categories.clear();
    for (var i = 0; i < availableCategories.categories.length; i++) {
      setState(() {
        categories.add(availableCategories.categories[i]);
      });
    }
  }

  void getCategories2(String? token, String service) async {
    AvailableCategories availableCategories2 =
        await _apiService.getAvailableCategories(token!, service);
    categories2.clear();
    for (var i = 0; i < availableCategories2.categories.length; i++) {
      setState(() {
        categories2.add(availableCategories2.categories[i]);
      });
    }
  }
}
