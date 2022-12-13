import 'package:bellani_talents_market/model/DealRequirementModel.dart';
import 'package:bellani_talents_market/screens/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../theme/custom_theme.dart';
import '../main.dart';
import '../model/AvailableCategories.dart';
import '../model/AvailableServices.dart';
import '../model/Success.dart';

class DealRequirements extends StatefulWidget {
  const DealRequirements({Key? key}) : super(key: key);

  @override
  State<DealRequirements> createState() => _DealRequirements();
}

class _DealRequirements extends State<DealRequirements> {
  List<String> services = [];
  List<String> categories = [];
  // var selectedCategory, selectedServices;
  List<DealRequirementModel> dealRequirements = [];
  var focusNode0 = FocusNode();
  var focusNode1 = FocusNode();
  var _apiService = ApiService();
  bool focused = false;
  var deal_id;
  var token = sp.getString("token");
  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();

    getServices(token);
    dealRequirements.insert(
        0,
        DealRequirementModel(
          service: null,
          category: null,
          members: null,
          pricing: null,
          availableCategories: null,
          textController1: TextEditingController(),
          textController2: TextEditingController(),
        ));
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

  // void getCategories(String? token, String service) async {
  //   AvailableCategories availableCategories =
  //       await _apiService.getAvailableCategories(token!, service);
  //   categories.clear();
  //   for (var i = 0; i < availableCategories.categories.length; i++) {
  //     setState(() {
  //       categories.add(availableCategories.categories[i]);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    deal_id = arguments["deal_id"];

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
                              child: MarqueeWidget(
                                animationDuration: Duration(milliseconds: 1000),
                                pauseDuration: Duration(milliseconds: 800),
                                backDuration: Duration(milliseconds: 1000),
                                child: Text(
                                  "Post a deal",
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
                      Expanded(
                        child: Column(children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Column(children: [
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: CustomTheme.appColors.primaryColor,
                                  ),
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                    ),
                                    child: Row(children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        margin: EdgeInsets.all(10),
                                        // child: SvgPicture.asset(
                                        //     "assets/add.svg"),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Deal requirements",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (!dealRequirements[dealRequirements.length - 1].textController1.text.isEmpty &&
                                                !dealRequirements[
                                                        dealRequirements
                                                                .length -
                                                            1]
                                                    .textController2
                                                    .text
                                                    .isEmpty &&
                                                dealRequirements[
                                                            dealRequirements
                                                                    .length -
                                                                1]
                                                        .service !=
                                                    null &&
                                                dealRequirements[
                                                            dealRequirements
                                                                    .length -
                                                                1]
                                                        .category !=
                                                    null) {
                                              dealRequirements.insert(
                                                  dealRequirements.length,
                                                  DealRequirementModel(
                                                    service: null,
                                                    category: null,
                                                    members: null,
                                                    pricing: null,
                                                    availableCategories: null,
                                                    textController1:
                                                        TextEditingController(),
                                                    textController2:
                                                        TextEditingController(),
                                                  ));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(
                                                  // padding: EdgeInsets.only(top: 30),
                                                  backgroundColor: CustomTheme
                                                      .appColors.white,
                                                  content: Container(
                                                    height: 32,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Please fill all fields",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              sp.getString(
                                                                  "selectedFont"),
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor),
                                                    ),
                                                  ),
                                                ));
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          color: CustomTheme
                                              .appColors.primaryColor50,
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(3),
                                          child: SvgPicture.asset(
                                              "assets/add.svg"),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6))),
                                      child: Column(children: [
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  dealRequirements.length,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  height: 70,
                                                  width: double.infinity,
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Row(children: [
                                                    Expanded(
                                                      child: Column(children: [
                                                        Row(children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      left: 5,
                                                                      right: 0),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                    child:
                                                                        DropdownButtonHideUnderline(
                                                                      child:
                                                                          Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          canvasColor: CustomTheme
                                                                              .appColors
                                                                              .secondaryColor,
                                                                        ),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            color:
                                                                                CustomTheme.appColors.primaryColor50,
                                                                            child:
                                                                                Row(children: [
                                                                              Container(height: 20, width: 20, padding: EdgeInsets.all(2), margin: EdgeInsets.only(left: 5), decoration: BoxDecoration(color: CustomTheme.appColors.secondaryColor, borderRadius: BorderRadius.circular(6)), child: SvgPicture.asset("assets/service_maroon.svg")),
                                                                              Expanded(
                                                                                child: DropdownButton<String>(
                                                                                  isExpanded: true,
                                                                                  icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                                                                                  hint: Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                    child: Center(
                                                                                      child: MarqueeWidget(
                                                                                        animationDuration: Duration(milliseconds: 1000),
                                                                                        pauseDuration: Duration(milliseconds: 800),
                                                                                        backDuration: Duration(milliseconds: 1000),
                                                                                        child: Text(
                                                                                            //select a category
                                                                                            "Service " + (index + 1).toString() + "*",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontSize: 12, color: CustomTheme.appColors.white)),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  items: services.map((String dropDownString) {
                                                                                    return DropdownMenuItem<String>(
                                                                                      value: dropDownString,
                                                                                      child: MediaQuery(
                                                                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                                        child: Center(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                            child: MarqueeWidget(
                                                                                              animationDuration: Duration(milliseconds: 1000),
                                                                                              pauseDuration: Duration(milliseconds: 800),
                                                                                              backDuration: Duration(milliseconds: 1000),
                                                                                              child: Text(
                                                                                                dropDownString,
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (String? newValue) async {
                                                                                    AvailableCategories availableCategories = await _apiService.getAvailableCategories(token!, newValue!);
                                                                                    dealRequirements[index].availableCategories?.clear();
                                                                                    setState(
                                                                                      () {
                                                                                        dealRequirements[index] = DealRequirementModel(service: newValue, category: null, members: dealRequirements[index].members, pricing: dealRequirements[index].pricing, availableCategories: availableCategories.categories, textController1: dealRequirements[index].textController1, textController2: dealRequirements[index].textController2);
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  value: dealRequirements[index].service,
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
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      left: 5,
                                                                      right: 5),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .secondaryColor,
                                                                  child: Center(
                                                                    child:
                                                                        DropdownButtonHideUnderline(
                                                                      child:
                                                                          Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          canvasColor: CustomTheme
                                                                              .appColors
                                                                              .secondaryColor,
                                                                        ),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            color:
                                                                                CustomTheme.appColors.primaryColor50,
                                                                            child:
                                                                                Row(children: [
                                                                              Container(height: 20, width: 20, padding: EdgeInsets.all(2), margin: EdgeInsets.only(left: 5), decoration: BoxDecoration(color: CustomTheme.appColors.secondaryColor, borderRadius: BorderRadius.circular(6)), child: SvgPicture.asset("assets/service_maroon.svg")),
                                                                              Expanded(
                                                                                child: DropdownButton<String>(
                                                                                  isExpanded: true,
                                                                                  alignment: Alignment.center,
                                                                                  icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                                                                                  hint: Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                    child: Center(
                                                                                      child: MarqueeWidget(
                                                                                        animationDuration: Duration(milliseconds: 1000),
                                                                                        pauseDuration: Duration(milliseconds: 800),
                                                                                        backDuration: Duration(milliseconds: 1000),
                                                                                        child: Text(
                                                                                            //select a category
                                                                                            "Category " + (index + 1).toString() + "*",
                                                                                            style: TextStyle(fontSize: 12, color: CustomTheme.appColors.white)),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  items: dealRequirements[index].availableCategories?.map((String dropDownString) {
                                                                                    return DropdownMenuItem<String>(
                                                                                      value: dropDownString,
                                                                                      child: MediaQuery(
                                                                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                                        child: Center(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                            child: MarqueeWidget(
                                                                                              animationDuration: Duration(milliseconds: 1000),
                                                                                              pauseDuration: Duration(milliseconds: 800),
                                                                                              backDuration: Duration(milliseconds: 1000),
                                                                                              child: Text(
                                                                                                dropDownString,
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (String? newValue) {
                                                                                    setState(
                                                                                      () {
                                                                                        dealRequirements[index] = DealRequirementModel(service: dealRequirements[index].service, category: newValue, members: dealRequirements[index].members, pricing: dealRequirements[index].pricing, availableCategories: dealRequirements[index].availableCategories, textController1: dealRequirements[index].textController1, textController2: dealRequirements[index].textController2);
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  value: dealRequirements[index].category,
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
                                                        ]),
                                                        Row(children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      left: 5,
                                                                      right: 0),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .primaryColor50,
                                                                  child:
                                                                      TextFormField(
                                                                    // focusNode:
                                                                    // focusNode0,
                                                                    controller:
                                                                        dealRequirements[index]
                                                                            .textController1,
                                                                    cursorColor:
                                                                        CustomTheme
                                                                            .appColors
                                                                            .white,
                                                                    onChanged:
                                                                        (value) {
                                                                      dealRequirements[index] = DealRequirementModel(
                                                                          service: dealRequirements[index]
                                                                              .service,
                                                                          category: dealRequirements[index]
                                                                              .category,
                                                                          members: dealRequirements[index]
                                                                              .textController1
                                                                              .text,
                                                                          pricing:
                                                                              null,
                                                                          availableCategories: dealRequirements[index]
                                                                              .availableCategories,
                                                                          textController1: dealRequirements[index]
                                                                              .textController1,
                                                                          textController2:
                                                                              dealRequirements[index].textController2);
                                                                    },
                                                                    style:
                                                                        const TextStyle(
                                                                      height:
                                                                          1.2,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                    inputFormatters: <
                                                                        TextInputFormatter>[
                                                                      FilteringTextInputFormatter
                                                                          .digitsOnly,
                                                                    ],
                                                                    maxLength:
                                                                        4,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      counterText:
                                                                          "",
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      filled:
                                                                          false,
                                                                      fillColor: CustomTheme
                                                                          .appColors
                                                                          .white,
                                                                      disabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      hintText:
                                                                          "Members*",
                                                                      errorStyle:
                                                                          TextStyle(
                                                                              height: 0),
                                                                      focusedErrorBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      errorBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      errorMaxLines:
                                                                          1,
                                                                      hintStyle: TextStyle(
                                                                          height:
                                                                              1.8,
                                                                          fontSize:
                                                                              12,
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .white),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                CustomTheme.appColors.primaryColor50,
                                                                            width: 0.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                CustomTheme.appColors.primaryColor50,
                                                                            width: 0.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      left: 5,
                                                                      right: 5),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  color: CustomTheme
                                                                      .appColors
                                                                      .primaryColor50,
                                                                  child:
                                                                      TextFormField(
                                                                    // focusNode:
                                                                    // focusNode0,
                                                                    controller:
                                                                        dealRequirements[index]
                                                                            .textController2,
                                                                    cursorColor:
                                                                        CustomTheme
                                                                            .appColors
                                                                            .white,
                                                                    onChanged:
                                                                        (value) {
                                                                      dealRequirements[index] = DealRequirementModel(
                                                                          service: dealRequirements[index]
                                                                              .service,
                                                                          category: dealRequirements[index]
                                                                              .category,
                                                                          members: dealRequirements[index]
                                                                              .members,
                                                                          pricing: dealRequirements[index]
                                                                              .textController2
                                                                              .text,
                                                                          availableCategories: dealRequirements[index]
                                                                              .availableCategories,
                                                                          textController1: dealRequirements[index]
                                                                              .textController1,
                                                                          textController2:
                                                                              dealRequirements[index].textController2);
                                                                    },
                                                                    style:
                                                                        const TextStyle(
                                                                      height:
                                                                          1.2,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                    inputFormatters: <
                                                                        TextInputFormatter>[
                                                                      FilteringTextInputFormatter
                                                                          .digitsOnly,
                                                                    ],
                                                                    maxLength:
                                                                        4,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      counterText:
                                                                          "",
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      filled:
                                                                          false,
                                                                      fillColor: CustomTheme
                                                                          .appColors
                                                                          .white,
                                                                      disabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      hintText:
                                                                          "Pricing*",
                                                                      errorStyle:
                                                                          TextStyle(
                                                                              height: 0),
                                                                      focusedErrorBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      errorBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      errorMaxLines:
                                                                          1,
                                                                      hintStyle: TextStyle(
                                                                          height:
                                                                              1.8,
                                                                          fontSize:
                                                                              12,
                                                                          color: CustomTheme
                                                                              .appColors
                                                                              .white),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                CustomTheme.appColors.primaryColor50,
                                                                            width: 0.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                CustomTheme.appColors.primaryColor50,
                                                                            width: 0.0),
                                                                      ),
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return "";
                                                                      } else {
                                                                        return null;
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      ]),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          dealRequirements
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 70,
                                                        width: 30,
                                                        margin: EdgeInsets.only(
                                                            right: 5, top: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: CustomTheme
                                                              .appColors
                                                              .secondaryColor,
                                                        ),
                                                        child: SvgPicture.asset(
                                                            "assets/delete.svg"),
                                                      ),
                                                    )
                                                  ]),
                                                );
                                              }),
                                        )
                                      ])),
                                ),
                              ]),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!dealRequirements[
                                          dealRequirements.length - 1]
                                      .textController1
                                      .text
                                      .isEmpty &&
                                  !dealRequirements[dealRequirements.length - 1]
                                      .textController2
                                      .text
                                      .isEmpty &&
                                  dealRequirements[dealRequirements.length - 1]
                                          .service !=
                                      null &&
                                  dealRequirements[dealRequirements.length - 1]
                                          .category !=
                                      null) {
                                Success suc = await ApiService()
                                    .addDealRequirements(
                                        deal_id, dealRequirements);
                                if (suc.status == "success") {
                                  Navigator.pushNamed(
                                      context, "/selectDealLocation",
                                      arguments: {"deal_id": deal_id});
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
                                          "Select location",
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
              )),
        ),
      ),
    );
  }
}
