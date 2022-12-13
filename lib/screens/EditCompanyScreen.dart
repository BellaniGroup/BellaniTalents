import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../main.dart';
import '../model/MarqueeWidget.dart';
import '../services/ApiService.dart';
import '../strings/strings.dart';
import '../theme/custom_theme.dart';
import 'otp/OtpScreen.dart';
import 'transaction/bloc/transaction_bloc.dart';

class EditCompanyScreen extends StatefulWidget {
  const EditCompanyScreen({Key? key}) : super(key: key);

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
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
  bool _agreeTerms = false;
  var locale = "IN", code = "+91", number;

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
            BlocProvider<TransactionBloc>(
                create: (context) => TransactionBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: CustomTheme.appColors.primaryColor,
            body: SafeArea(
              child: Container(
                width: double.infinity,
                color: CustomTheme.appColors.secondaryColor,
                child: Column(children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomTheme.appColors.primaryColor,
                    ),
                    child: Text(
                      "OneBellani - Edit Company",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  registerNew(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/manageEmployees");
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                  "Manage employees",
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
                  Spacer(),
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
                          if (usernameValid.available.contains("true")) {
                            var mobileValid =
                                await ApiService().verifyMobile(number, code);
                            if (mobileValid.available.contains("true")) {
                              var emailValid = await ApiService()
                                  .verifyEmail(_textController4.text);
                              if (emailValid.available.contains("true")) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                            otpType: "register",
                                            username: _textController.text,
                                            name: _textController2.text,
                                            mobile: _textController3.text,
                                            email: _textController4.text,
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
                              backgroundColor: CustomTheme.appColors.white,
                              content: Container(
                                height: 32,
                                alignment: Alignment.center,
                                child: Text(
                                  "Please fill all fields",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: sp.getString("selectedFont"),
                                      color:
                                          CustomTheme.appColors.secondaryColor),
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
                                "Please agree terms and conditions",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: sp.getString("selectedFont"),
                                    color:
                                        CustomTheme.appColors.secondaryColor),
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
                            child: SvgPicture.asset("assets/right_arrow.svg"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              child: SvgPicture.asset("assets/companyName.svg"),
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
                  hintText: focused ? "" : "Company's legal name*",
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
              child: SvgPicture.asset("assets/username_tag_maroon.svg"),
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
                  hintText: focused2 ? "" : "Enter desired username*",
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
                    hintText: focused3 ? "" : "Enter mobile number*",
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
                  hintText: focused4 ? "" : "Enter your email address*",
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
                  child: SvgPicture.asset("assets/employee.svg"),
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
                          child: Text("Employees",
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
