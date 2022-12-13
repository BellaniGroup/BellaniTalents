import 'dart:developer';

import 'package:bellani_talents_market/model/Talents.dart';
import 'package:bellani_talents_market/screens/home/HomeScreen.dart';
import 'package:bellani_talents_market/screens/talents/bloc/talents_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/ApiService.dart';
import '../../strings/strings.dart';
import '../../theme/custom_theme.dart';

class TalentsScreen extends StatelessWidget {
  const TalentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    var selectedCity = arguments["selectedCity"];
    var selectedCategory = arguments["selectedCategory"];
    var selectedType = arguments["selectedType"];

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TalentsBloc(
                RepositoryProvider.of<ApiService>(context),
              )..add(LoadTalentsEvent(
                  selectedCity, selectedCategory, selectedType)),
            )
          ],
          child: Scaffold(
            backgroundColor: CustomTheme.appColors.primaryColor,
            body: BlocBuilder<TalentsBloc, TalentsState>(
              builder: (context, state) {
                if (state is TalentsLoadedState) {
                  return SafeArea(
                    child: CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  setHeader(),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20, bottom: 20),
                                      child: SizedBox(
                                        height: height > 850 ? 500 : 360,
                                        width: 290,
                                        child: GridView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: state.talents.length,
                                          scrollDirection: Axis.horizontal,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                          ),
                                          itemBuilder: (context, index) =>
                                              Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/talentDetails',
                                                      arguments: {
                                                        "talent_id": state
                                                            .talents[index].id,
                                                        "selectedCity":
                                                            selectedCity,
                                                        "selectedCategory":
                                                            selectedCategory,
                                                        "selectedType":
                                                            selectedType,
                                                      });
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: Image.network(state
                                                          .talents[index]
                                                          .photo),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Container(
                                                  width: 80,
                                                  child: Text(
                                                    state.talents[index].stageName,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: CustomTheme
                                                            .appColors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  setFooter()
                                ]),
                          ),
                        ]),
                  );
                }
                if (state is TalentsLoadingState) {
                  return Center(
                      child: SizedBox(
                    height: 70,
                    width: 70,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ));
                } else {
                  return Center(
                      child: SizedBox(
                          height: 70, width: 70, child: Text("No Internet")));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget setHeader() {
    return Column(children: [
      Container(
        height: 70,
        width: double.infinity,
        color: CustomTheme.appColors.white,
        child: Center(
          child: Container(
            width: 320,
            height: 50,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  width: 50,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.network(
                        "https://live.staticflickr.com/65535/52005982529_6326aa8d83_n.jpg"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Text("Namaste, ",
                          style:
                              TextStyle(color: CustomTheme.appColors.textGrey)),
                      Text("@hemamalini",
                          style: TextStyle(
                              color: CustomTheme.appColors.bjpOrange)),
                      Text("!",
                          style:
                              TextStyle(color: CustomTheme.appColors.textGrey)),
                    ]),
                    Row(children: [
                      Text("B 12336 | Gold | ",
                          style:
                              TextStyle(color: CustomTheme.appColors.textGrey)),
                      Text("View profile >",
                          style: TextStyle(
                              color: CustomTheme.appColors.bjpOrange)),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }

   Widget setFooter() {
    return Container(
      height: 70,
      width: double.infinity,
      color: CustomTheme.appColors.white,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            width: 320,
            height: 50,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  width: 54,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SvgPicture.asset("assets/package.svg"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Text("Add the ",
                          style:
                              TextStyle(color: CustomTheme.appColors.textGrey)),
                      Text("Talents ",
                          style: TextStyle(
                              color: CustomTheme.appColors.secondaryColor)),
                      Text("Package",
                          style:
                              TextStyle(color: CustomTheme.appColors.textGrey)),
                    ]),
                    Row(children: [
                      Text("Get B 2,500 | ",
                          style:
                              TextStyle(color: CustomTheme.appColors.textGrey)),
                      Text("Add now >",
                          style: TextStyle(
                              color: CustomTheme.appColors.bjpOrange)),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
