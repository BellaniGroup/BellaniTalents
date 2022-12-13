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

class EditTalentProfile extends StatefulWidget {
  const EditTalentProfile({Key? key}) : super(key: key);

  @override
  State<EditTalentProfile> createState() => _EditTalentProfileState();
}

class _EditTalentProfileState extends State<EditTalentProfile> {
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
  DateTime _pickerDate = DateTime.now();
  Account user = AccountApiFromJson(sp.getString("userdata")!);
  var selectedGender, selectedDob;
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');
  List<String> services = ["s1", "s2", "s3"];
  List<String> categories = ["c1", "c2", "c3"];
  List<String> languages = ["lang 1", "lang 2", "lang 3"];
  var selectedCategory, selectedServices;
  var selectedCategory2, selectedServices2;
  var selectedLang;
  bool _agreeTerms = false;

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
                                      "Edit - Talents package",
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
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
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
                                          "assets/name_tag.svg"),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _textController,
                                        focusNode: _textFocus,
                                        cursorColor:
                                            CustomTheme.appColors.white,
                                        textInputAction: TextInputAction.go,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: CustomTheme.appColors.white,
                                            fontSize: 12),
                                        decoration: InputDecoration(
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, "/editTalent");
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 5, bottom: 5),
                                              child: SvgPicture.asset(
                                                  "assets/edit.svg"),
                                            ),
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(bottom: 0),
                                          filled: true,
                                          hintText: focused ? "" : user.name,
                                          hintStyle: TextStyle(
                                              height: 1.8,
                                              color:
                                                  CustomTheme.appColors.white),
                                          fillColor: CustomTheme
                                              .appColors.primaryColor50,
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
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
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
                                          "assets/stage_name.svg"),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        cursorColor:
                                            CustomTheme.appColors.white,
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
                                            child: SvgPicture.asset(
                                                "assets/edit.svg"),
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(bottom: 0),
                                          filled: true,
                                          hintText: "Stage name",
                                          hintStyle: TextStyle(
                                              height: 1.8,
                                              color:
                                                  CustomTheme.appColors.white),
                                          fillColor: CustomTheme
                                              .appColors.primaryColor50,
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
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
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
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
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
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child:
                                          SvgPicture.asset("assets/call.svg"),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        // margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            color: CustomTheme
                                                .appColors.primaryColor50,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: IntlPhoneField(
                                          controller: _textController2,
                                          focusNode: _textFocus2,
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
                                            backgroundColor: CustomTheme
                                                .appColors.secondaryColor,
                                            searchFieldInputDecoration:
                                                InputDecoration(
                                              counterText: "",
                                              contentPadding: EdgeInsets.zero,
                                              filled: false,
                                              suffixIcon: Icon(
                                                Icons.search,
                                                color:
                                                    CustomTheme.appColors.white,
                                              ),
                                              // fillColor: CustomTheme.appColors.white,
                                              hintText: "Select country",
                                              hintStyle: TextStyle(
                                                  height: 1.8,
                                                  color: CustomTheme
                                                      .appColors.white),
                                              labelStyle: TextStyle(
                                                  color: CustomTheme.appColors
                                                      .secondaryColor),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    width: 0.0),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor),
                                              ),
                                            ),
                                            countryNameStyle: TextStyle(
                                                color: CustomTheme
                                                    .appColors.white),
                                            countryCodeStyle: TextStyle(
                                                color: CustomTheme
                                                    .appColors.white),
                                          ),
                                          cursorColor:
                                              CustomTheme.appColors.white,
                                          textInputAction: TextInputAction.go,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              color:
                                                  CustomTheme.appColors.white,
                                              fontSize: 12),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          disableLengthCheck: true,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            contentPadding: EdgeInsets.zero,
                                            filled: false,
                                            fillColor:
                                                CustomTheme.appColors.white,
                                            disabledBorder: InputBorder.none,
                                            suffixIcon: Container(
                                              height: 20,
                                              width: 20,
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 5, bottom: 5),
                                              child: SvgPicture.asset(
                                                  "assets/edit.svg"),
                                            ),
                                            hintText:
                                                focused2 ? "" : user.phone,
                                            errorStyle: TextStyle(height: 0),
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            errorMaxLines: 1,
                                            hintStyle: TextStyle(
                                                height: 1.8,
                                                color: CustomTheme
                                                    .appColors.white),
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
                                            print('Country changed to: ' +
                                                country.name);
                                          },
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Container(
                                  height: 30,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
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
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: SvgPicture.asset(
                                          "assets/whatsapp.svg"),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        // margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            color: CustomTheme
                                                .appColors.primaryColor50,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: IntlPhoneField(
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
                                                color:
                                                    CustomTheme.appColors.white,
                                              ),
                                              // fillColor: CustomTheme.appColors.white,
                                              hintText: "Select country",
                                              hintStyle: TextStyle(
                                                  height: 1.8,
                                                  color: CustomTheme
                                                      .appColors.white),
                                              labelStyle: TextStyle(
                                                  color: CustomTheme.appColors
                                                      .secondaryColor),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    width: 0.0),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor),
                                              ),
                                            ),
                                            countryNameStyle: TextStyle(
                                                color: CustomTheme
                                                    .appColors.white),
                                            countryCodeStyle: TextStyle(
                                                color: CustomTheme
                                                    .appColors.white),
                                          ),
                                          cursorColor:
                                              CustomTheme.appColors.white,
                                          textInputAction: TextInputAction.go,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              color:
                                                  CustomTheme.appColors.white,
                                              fontSize: 12),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          disableLengthCheck: true,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            contentPadding: EdgeInsets.zero,
                                            filled: false,
                                            fillColor:
                                                CustomTheme.appColors.white,
                                            disabledBorder: InputBorder.none,
                                            suffixIcon: Container(
                                              height: 20,
                                              width: 20,
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 5, bottom: 5),
                                              child: SvgPicture.asset(
                                                  "assets/edit.svg"),
                                            ),
                                            hintText:
                                                "Primary WhatsApp number*",
                                            errorStyle: TextStyle(height: 0),
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            errorMaxLines: 1,
                                            hintStyle: TextStyle(
                                                height: 1.8,
                                                color: CustomTheme
                                                    .appColors.white),
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
                                            code = phone.countryCode;
                                            number = phone.number;
                                          },
                                          onCountryChanged: (country) {
                                            print('Country changed to: ' +
                                                country.name);
                                          },
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Container(
                                  height: 30,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
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
                                      child: TextFormField(
                                        controller: _textController3,
                                        focusNode: _textFocus3,
                                        cursorColor:
                                            CustomTheme.appColors.white,
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
                                            child: SvgPicture.asset(
                                                "assets/edit.svg"),
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(bottom: 0),
                                          filled: true,
                                          hintText: focused3 ? "" : user.email,
                                          hintStyle: TextStyle(
                                              height: 1.8,
                                              color:
                                                  CustomTheme.appColors.white),
                                          fillColor: CustomTheme
                                              .appColors.primaryColor50,
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
                                Row(children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // setState(() {
                                        //   if (_show) {
                                        //     _show = false;
                                        //   } else {
                                        //     _show = true;
                                        //   }
                                        // });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 5, top: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: CustomTheme
                                              .appColors.primaryColor50,
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
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
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
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 30,
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          left: 5, right: 10, top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: CustomTheme
                                            .appColors.primaryColor50,
                                      ),
                                      child: Row(children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          margin: EdgeInsets.all(5),
                                          child: SvgPicture.asset(
                                              "assets/morf.svg"),
                                        ),
                                        Expanded(
                                          child: Text(
                                            user.gender,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: CustomTheme
                                                    .appColors.white),
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
                                        padding:
                                            EdgeInsets.only(left: 5, right: 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            height: 30,
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: Center(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    canvasColor: CustomTheme
                                                        .appColors
                                                        .secondaryColor,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 30,
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor50,
                                                        child: Row(children: [
                                                          Container(
                                                              height: 20,
                                                              width: 20,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              decoration: BoxDecoration(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/service_maroon.svg")),
                                                          Expanded(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              icon: Visibility(
                                                                  visible:
                                                                      false,
                                                                  child: Icon(Icons
                                                                      .arrow_downward)),
                                                              hint: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
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
                                                                      "Service 1*",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .white)),
                                                                ),
                                                              ),
                                                              items: services
                                                                  .map((String
                                                                      dropDownString) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      dropDownString,
                                                                  child:
                                                                      MediaQuery(
                                                                    data: MediaQuery.of(
                                                                            context)
                                                                        .copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            MarqueeWidget(
                                                                          animationDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          pauseDuration:
                                                                              Duration(milliseconds: 800),
                                                                          backDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          child:
                                                                              Text(
                                                                            dropDownString,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(color: CustomTheme.appColors.white),
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
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            height: 30,
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: Center(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    canvasColor: CustomTheme
                                                        .appColors
                                                        .secondaryColor,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0, right: 5),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 30,
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor50,
                                                        child: Row(children: [
                                                          Container(
                                                              height: 20,
                                                              width: 20,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              decoration: BoxDecoration(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/service_maroon.svg")),
                                                          Expanded(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              icon: Visibility(
                                                                  visible:
                                                                      false,
                                                                  child: Icon(Icons
                                                                      .arrow_downward)),
                                                              hint: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
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
                                                              items: categories
                                                                  .map((String
                                                                      dropDownString) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      dropDownString,
                                                                  child:
                                                                      MediaQuery(
                                                                    data: MediaQuery.of(
                                                                            context)
                                                                        .copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            MarqueeWidget(
                                                                          animationDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          pauseDuration:
                                                                              Duration(milliseconds: 800),
                                                                          backDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          child:
                                                                              Text(
                                                                            dropDownString,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(color: CustomTheme.appColors.white),
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
                                        padding:
                                            EdgeInsets.only(left: 5, right: 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            height: 30,
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: Center(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    canvasColor: CustomTheme
                                                        .appColors
                                                        .secondaryColor,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 30,
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor50,
                                                        child: Row(children: [
                                                          Container(
                                                              height: 20,
                                                              width: 20,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              decoration: BoxDecoration(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/service_maroon.svg")),
                                                          Expanded(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              icon: Visibility(
                                                                  visible:
                                                                      false,
                                                                  child: Icon(Icons
                                                                      .arrow_downward)),
                                                              hint: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
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
                                                              items: services
                                                                  .map((String
                                                                      dropDownString) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      dropDownString,
                                                                  child:
                                                                      MediaQuery(
                                                                    data: MediaQuery.of(
                                                                            context)
                                                                        .copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            MarqueeWidget(
                                                                          animationDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          pauseDuration:
                                                                              Duration(milliseconds: 800),
                                                                          backDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          child:
                                                                              Text(
                                                                            dropDownString,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(color: CustomTheme.appColors.white),
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
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            height: 30,
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: Center(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    canvasColor: CustomTheme
                                                        .appColors
                                                        .secondaryColor,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0, right: 5),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 30,
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor50,
                                                        child: Row(children: [
                                                          Container(
                                                              height: 20,
                                                              width: 20,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              decoration: BoxDecoration(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/service_maroon.svg")),
                                                          Expanded(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              icon: Visibility(
                                                                  visible:
                                                                      false,
                                                                  child: Icon(Icons
                                                                      .arrow_downward)),
                                                              hint: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
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
                                                              items: categories
                                                                  .map((String
                                                                      dropDownString) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      dropDownString,
                                                                  child:
                                                                      MediaQuery(
                                                                    data: MediaQuery.of(
                                                                            context)
                                                                        .copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            MarqueeWidget(
                                                                          animationDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          pauseDuration:
                                                                              Duration(milliseconds: 800),
                                                                          backDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          child:
                                                                              Text(
                                                                            dropDownString,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(color: CustomTheme.appColors.white),
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
                                        padding:
                                            EdgeInsets.only(left: 5, right: 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                            height: 30,
                                            color: CustomTheme
                                                .appColors.secondaryColor,
                                            child: Center(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    canvasColor: CustomTheme
                                                        .appColors
                                                        .secondaryColor,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Container(
                                                        height: 30,
                                                        color: CustomTheme
                                                            .appColors
                                                            .primaryColor50,
                                                        child: Row(children: [
                                                          Container(
                                                              height: 20,
                                                              width: 20,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              decoration: BoxDecoration(
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/languages.svg")),
                                                          Expanded(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              icon: Visibility(
                                                                  visible:
                                                                      false,
                                                                  child: Icon(Icons
                                                                      .arrow_downward)),
                                                              hint: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
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
                                                                      "Languages (Minimum 1)*",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .white)),
                                                                ),
                                                              ),
                                                              items: languages
                                                                  .map((String
                                                                      dropDownString) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      dropDownString,
                                                                  child:
                                                                      MediaQuery(
                                                                    data: MediaQuery.of(
                                                                            context)
                                                                        .copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            MarqueeWidget(
                                                                          animationDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          pauseDuration:
                                                                              Duration(milliseconds: 800),
                                                                          backDuration:
                                                                              Duration(milliseconds: 1000),
                                                                          child:
                                                                              Text(
                                                                            dropDownString,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(color: CustomTheme.appColors.white),
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
                                                                    selectedLang =
                                                                        newValue;
                                                                  },
                                                                );
                                                              },
                                                              value:
                                                                  selectedLang,
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
                              ],
                            ),
                          ),
                        ),
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
                                  backgroundColor: CustomTheme.appColors.white,
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
                                  backgroundColor: CustomTheme.appColors.white,
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
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, "/selectPlanScreen");
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Submit change",
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
        },
      );
    } else {
      return null;
    }
  }
}
