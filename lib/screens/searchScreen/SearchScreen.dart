import 'dart:collection';

import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../services/ApiService.dart';
import 'bloc/search_bloc.dart';

var type;
var searchScreenContext;

class SearchScreen extends StatefulWidget {
  String searchType;
  SearchScreen({required this.searchType, Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState(searchType);
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool focused = false;
  final Map<String, String> selectedValue = HashMap();

  var type;
  _SearchScreenState(this.type);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
  }

  void onChange() {
    String searchText = _textController.text;
    bool hasFocus = _textFocus.hasFocus;

    if (type == "username") {
      BlocProvider.of<SearchBloc>(searchScreenContext)
          .add(SearchTalentEvent(searchText));
    }
    if (type == "service") {
      BlocProvider.of<SearchBloc>(searchScreenContext)
          .add(SearchServiceEvent(searchText));
    }

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
    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // type = "username";

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<SearchBloc>(
                create: (context) => SearchBloc(
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
                      if (type == "username") searchUser(),
                      if (type == "service") searchService(),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget searchUser() {
    return Expanded(
      child: Column(children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: CustomTheme.appColors.primaryColor,
            // boxShadow: [
            //   BoxShadow(
            //     color: CustomTheme.appColors.black.withOpacity(0.3),
            //     blurRadius: 8,
            //     spreadRadius: 3,
            //     offset: const Offset(0, 8),
            //   ),
            // ],
          ),
          child: Container(
            height: 36,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.secondaryColor,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6)),
                        color: CustomTheme.appColors.secondaryColor,
                      ),
                      padding: EdgeInsets.all(9),
                      child: SvgPicture.asset("assets/left_arrow_white.svg")),
                ),
                Container(
                    height: 35,
                    width: 35,
                    padding: EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/username_tag.svg")),
                Expanded(
                  child: TextFormField(
                      controller: _textController,
                      focusNode: _textFocus,
                      cursorColor: CustomTheme.appColors.white,
                      textInputAction: TextInputAction.go,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CustomTheme.appColors.white, fontSize: 12),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        fillColor: CustomTheme.appColors.white,
                        disabledBorder: InputBorder.none,
                        hintText: focused ? "" : "Search by username",
                        hintStyle: TextStyle(
                            height: 1.8, color: CustomTheme.appColors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomTheme.appColors.secondaryColor,
                              width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomTheme.appColors.secondaryColor,
                              width: 0.0),
                        ),
                      )),
                ),
                Container(
                  height: 35,
                  width: 35,
                  padding: EdgeInsets.all(5),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _textController.text = "";
                    });
                  },
                  child: Container(
                      height: 35,
                      width: 35,
                      padding: EdgeInsets.all(9),
                      child: SvgPicture.asset("assets/white_x.svg")),
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            searchScreenContext = context;
            if (state is SearchedTalentState) {
              return Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        selectedValue
                            .addAll({"id": state.searchedtalents[index].id});
                        Navigator.pop(context, selectedValue);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(children: [
                          Container(
                            height: 30,
                            width: 30,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.network(
                                    state.searchedtalents[index].photo),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "@" + state.searchedtalents[index].username,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CustomTheme.appColors.white),
                              ),
                              Text(
                                state.searchedtalents[index].service +
                                    " - " +
                                    state.searchedtalents[index].category,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CustomTheme.appColors.white),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    );
                  },
                  itemCount: state.searchedtalents.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                ),
              );
            }
            return Expanded(
              child: Center(
                child: Text("No talents found"),
              ),
            );
          },
        ),
      ]),
    );
  }

  Widget searchService() {
    return Expanded(
      child: Column(children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: CustomTheme.appColors.primaryColor,
            // boxShadow: [
            //   BoxShadow(
            //     color: CustomTheme.appColors.black.withOpacity(0.3),
            //     blurRadius: 8,
            //     spreadRadius: 3,
            //     offset: const Offset(0, 8),
            //   ),
            // ],
          ),
          child: Container(
            height: 36,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: CustomTheme.appColors.secondaryColor,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6)),
                        color: CustomTheme.appColors.secondaryColor,
                      ),
                      padding: EdgeInsets.all(9),
                      child: SvgPicture.asset("assets/left_arrow_white.svg")),
                ),
                Container(
                    height: 35,
                    width: 35,
                    padding: EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/service_tag.svg")),
                Expanded(
                  child: TextFormField(
                      controller: _textController,
                      focusNode: _textFocus,
                      cursorColor: CustomTheme.appColors.white,
                      textInputAction: TextInputAction.go,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CustomTheme.appColors.white, fontSize: 12),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        fillColor: CustomTheme.appColors.white,
                        disabledBorder: InputBorder.none,
                        hintText: focused ? "" : "Search for a service",
                        hintStyle: TextStyle(
                            height: 1.8, color: CustomTheme.appColors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomTheme.appColors.secondaryColor,
                              width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomTheme.appColors.secondaryColor,
                              width: 0.0),
                        ),
                      )),
                ),
                Container(
                  height: 35,
                  width: 35,
                  padding: EdgeInsets.all(5),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _textController.text = "";
                    });
                  },
                  child: Container(
                      height: 35,
                      width: 35,
                      padding: EdgeInsets.all(9),
                      child: SvgPicture.asset("assets/white_x.svg")),
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            searchScreenContext = context;
            if (state is SearchedServiceState) {
              return Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        selectedValue.addAll(
                            {"service": state.searchedService[index].service});

                        Navigator.pop(context, selectedValue);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(children: [
                          Container(
                            height: 30,
                            width: 30,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: SvgPicture.asset("assets/service.svg"),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Service category",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CustomTheme.appColors.white),
                              ),
                              Text(
                                state.searchedService[index].service +
                                    " - " +
                                    state.searchedService[index].category,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CustomTheme.appColors.white),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    );
                  },
                  itemCount: state.searchedService.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                ),
              );
            }
            return Expanded(
              child: Center(
                child: Text("No Service found"),
              ),
            );
          },
        ),
      ]),
    );
  }
}
