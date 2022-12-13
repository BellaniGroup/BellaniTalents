import 'dart:collection';
import 'package:bellani_talents_market/strings/strings.dart';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/countries.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';
import '../model/MarqueeWidget.dart';
import '../model/PaymentMethods.dart';

class AddPaymentMethod extends StatefulWidget {
  AddPaymentMethod({Key? key}) : super(key: key);

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  TextEditingController _textController = new TextEditingController();
  PaymentMethods? availablePaymentMethods = null;
  FocusNode _textFocus = new FocusNode();
  int selectedYear = 0, selectedMonth = 0, _selectedDate = 32;
  late DateTime firstDayOfMonth, lastDayOfMonth, firstMonth, lastMonth;
  bool _yearSelected = false, _monthSelected = false;
  List<Country> selectedCountries = [];
  List<String> selectedCountriesIndex = [];
  var selectedCountry;
  bool focused = false;
  List<DateTime> days = [];
  var photo =
      "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=";
  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> years = [2022, 2023, 2024, 2025, 2026];
  final Map<String, String> selectedValue = HashMap();
  Account user = AccountApiFromJson(sp.getString("userdata")!);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    _textController.text = user.phone;

    for (int i = 0; i < allCountries.length; i++) {
      if (countriesList.contains(allCountries[i].code)) {
        selectedCountries.add(allCountries[i]);
        selectedCountriesIndex.add((selectedCountries.length - 1).toString());
      }
    }
  }

  void onChange() {
    String searchText = _textController.text;
    bool hasFocus = _textFocus.hasFocus;

    if (hasFocus) {
      setState(() {
        focused = true;
        if (_textController.text == user.phone) {
          _textController.text = "";
        }
      });
    } else {
      setState(() {
        focused = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // type = "username";

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
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
                            child: Text(
                              "Add a payment method",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                        )
                      ]),
                    ),
                    Container(
                      height: 30,
                      color: CustomTheme.appColors.secondaryColor,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: CustomTheme.appColors.secondaryColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 30,
                                color: CustomTheme.appColors.primaryColor50,
                                child: Row(children: [
                                  // Container(
                                  //   height: 20,
                                  //   width: 26,
                                  //   // padding: EdgeInsets.all(2),
                                  //   margin: EdgeInsets.only(left: 5),
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(6),
                                  //     child: Image.asset(
                                  //       'assets/flags/in.png',
                                  //       package: 'intl_phone_field',
                                  //       width: 32,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    height: 20,
                                    width: 50,
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      alignment: Alignment.center,
                                      icon: Visibility(
                                          visible: false,
                                          child: Icon(Icons.arrow_downward)),
                                      //select a service
                                      hint: Center(
                                        child: MarqueeWidget(
                                          animationDuration:
                                              Duration(milliseconds: 1000),
                                          pauseDuration:
                                              Duration(milliseconds: 800),
                                          backDuration:
                                              Duration(milliseconds: 1000),
                                          child: Text(
                                              selectedCountry == null
                                                  ? "Select a country"
                                                  : selectedCountry,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: CustomTheme
                                                      .appColors.white)),
                                        ),
                                      ),
                                      items: selectedCountriesIndex
                                          .map((String index) {
                                        return DropdownMenuItem<String>(
                                          value: index,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 20,
                                                    width: 26,
                                                    child: Image.asset(
                                                      'assets/flags/${selectedCountries[int.parse(index)].code.toLowerCase()}.png',
                                                      package:
                                                          'intl_phone_field',
                                                      width: 32,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Center(
                                                      child: MarqueeWidget(
                                                        animationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                        pauseDuration: Duration(
                                                            milliseconds: 800),
                                                        backDuration: Duration(
                                                            milliseconds: 1000),
                                                        child: Text(
                                                          selectedCountries[
                                                                  int.parse(
                                                                      index)]
                                                              .name,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: CustomTheme
                                                                  .appColors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 26,
                                                )
                                              ]),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) async {
                                        availablePaymentMethods =
                                            await ApiService()
                                                .getPaymentMethods(
                                                    selectedCountries[int.parse(
                                                            newValue!)]
                                                        .code);
                                        if (availablePaymentMethods?.status ==
                                            "success") {
                                          setState(
                                            () {
                                              selectedCountry = newValue;
                                            },
                                          );
                                        }
                                      },
                                      value: selectedCountry,
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 50,
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (availablePaymentMethods?.bankingOptions != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/addBankAccount", arguments: { "accDetails" : availablePaymentMethods!.bankingOptions });
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: CustomTheme.appColors.primaryColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.all(14),
                            ),
                            Expanded(
                              child: Text(
                                "Bank Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                                color: CustomTheme.appColors.primaryColor,
                                padding: EdgeInsets.all(14),
                                child:
                                    SvgPicture.asset("assets/right_arrow.svg")),
                          ]),
                        ),
                      ),
                    // Container(
                    //   height: 50,
                    //   width: double.infinity,
                    //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //       color: CustomTheme.appColors.primaryColor,
                    //       borderRadius: BorderRadius.circular(6)),
                    //   child: Row(children: [
                    //     Container(
                    //       padding: EdgeInsets.all(14),
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         "Google Pay",
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(fontSize: 14),
                    //       ),
                    //     ),
                    //     Container(
                    //         color: CustomTheme.appColors.primaryColor,
                    //         padding: EdgeInsets.all(14),
                    //         child: SvgPicture.asset("assets/right_arrow.svg")),
                    //   ]),
                    // ),
                    // Container(
                    //   height: 50,
                    //   width: double.infinity,
                    //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //       color: CustomTheme.appColors.primaryColor,
                    //       borderRadius: BorderRadius.circular(6)),
                    //   child: Row(children: [
                    //     Container(
                    //       padding: EdgeInsets.all(14),
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         "PhonePe",
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(fontSize: 14),
                    //       ),
                    //     ),
                    //     Container(
                    //         color: CustomTheme.appColors.primaryColor,
                    //         padding: EdgeInsets.all(14),
                    //         child: SvgPicture.asset("assets/right_arrow.svg")),
                    //   ]),
                    // ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
