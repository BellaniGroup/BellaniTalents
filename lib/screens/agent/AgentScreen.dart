import 'package:bellani_talents_market/screens/packages/bloc/packages_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../model/MarqueeWidget.dart';
import '../../../../services/ApiService.dart';
import '../../../../theme/custom_theme.dart';
import 'bloc/agent_bloc.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({Key? key}) : super(key: key);

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
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
            BlocProvider<AgentBloc>(
                create: (context) => AgentBloc(
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
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          margin: EdgeInsets.only(right: 10),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                          child: SvgPicture.asset(
                                              "assets/agent.svg"),
                                        )),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Agent dashboard",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ]),
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
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
