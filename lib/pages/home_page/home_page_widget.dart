import 'dart:convert';

import 'package:esof/flutter_flow/nav/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../sigarraApi/session.dart';
import '../../sigarraApi/sigarraApi.dart';
import '/custom_code/actions/index.dart' as actions;

import './home_page_model.dart';

export './home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  late AppStateNotifier _appStateNotifier;

  bool _isLoading = true;

  Uint8List? image_small;

  String? name;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Session?> _loadSession() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _appStateNotifier.username = prefs.getString('user_up_code') ?? "";
      _appStateNotifier.password = prefs.getString('user_password') ?? "";
      _appStateNotifier.faculty = prefs.getString('user_faculty') ?? "";
      _appStateNotifier.image_small = prefs.getString('user_image_small') ?? "";
      _appStateNotifier.image_big = prefs.getString('user_image_big') ?? "";
    });

    return sigarraLogin(_appStateNotifier.username, _appStateNotifier.password);
  }

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _model = createModel(context, () => HomePageModel());
    _isLoading = true;
    try {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        try {
          _model.mealInfoLunch = await queryWeekelyMealsRecordOnce(
            queryBuilder: (weekelyMealsRecord) =>
                weekelyMealsRecord.where(
                  'weekdayMeal',
                  isEqualTo: '${DateFormat('EEEE')
                      .format(DateTime.now())
                      .toLowerCase()}-lunch',
                ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _model.descriptionsLunch = actions.concatDescriptions(
            context,
            _model.mealInfoLunch!.descriptionMeat,
            _model.mealInfoLunch!.descriptionFish,
            _model.mealInfoLunch!.descriptionVegetarian,
          );

          _model.mealInfoDinner = await queryWeekelyMealsRecordOnce(
            queryBuilder: (weekelyMealsRecord) =>
                weekelyMealsRecord.where(
                  'weekdayMeal',
                  isEqualTo: '${DateFormat('EEEE')
                      .format(DateTime.now())
                      .toLowerCase()}-dinner',
                ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          _model.descriptionsDinner = actions.concatDescriptions(
            context,
            _model.mealInfoDinner!.descriptionMeat,
            _model.mealInfoDinner!.descriptionFish,
            _model.mealInfoDinner!.descriptionVegetarian,
          );
        } catch (e) {
          _model.descriptionsLunch = ['No meals available at this time.'];
          _model.descriptionsDinner = ['No meals available at this time.'];
        }
        setState(() {});
      });
    } catch (e) {
      setState(() {});
      _model.descriptionsLunch = ['No meals available at this time.'];
      _model.descriptionsDinner = ['No meals available at this time.'];
    }

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _isLoading = true;
      Session? session = await _loadSession();

      if (session != null) {
        image_small = base64Decode(_appStateNotifier.image_small) as Uint8List;
        if (image_small == null || image_small!.isEmpty) {
          image_small = (await getImage(session.cookies, session.username)).bodyBytes;
        }
        name = jsonDecode((await getName(session.cookies, session.username)).body)['nome'].toString().split(' ')[0];
      } else {
        context.go('/sigarraLogin');
      }

      setState(() {_isLoading = false;});
    });

  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String tempLunch = '';
    String tempDinner = '';
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).brightness.name == "dark" ? Colors.black12 : Color(0xFFf2cece),
        appBar: AppBar(
          backgroundColor: Color(0xFF2E1F1F),
          automaticallyImplyLeading: false,
          title: Text(
            'Home Page',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            if (image_small != null)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed('Perfil');
                },
                child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(image_small!, fit: BoxFit.cover), // Same radius value as above
                  )
              ),
            )
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: _isLoading
            ? Center(child: SpinningFork()) : SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 30.0, 0.0, 0.0),
                  child: Text(
                    'Welcome back,',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 26.0,
                          color: Theme.of(context).brightness.name == "dark" ? Colors.white : Colors.black
                        ),
                  ),
                ),
              ),
              if (name != null)
              Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 0.0, 0.0),
                  child: Text(
                    name!,
                    //'John Doe',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 26.0,
                          color: Theme.of(context).brightness.name == "dark" ? Colors.white : Colors.black
                        ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 80.0, 0.0, 0.0),
                  child: Container(
                    width: 333.0,
                    height: 145.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF252322),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, -1.0),
                                  child: Text(
                                    'Lunch',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 10.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(1.0, -1.0),
                                  child: Text(
                                    '12:40 - 14:30',
                                    textAlign: TextAlign.end,
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 20.0, 10.0, 0.0),
                            child: Text(
                              () {
                                _model.descriptionsLunch?.forEach((name) => tempLunch += "$name\n");
                                return tempLunch;
                              }(),
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 80.0, 0.0, 0.0),
                  child: Container(
                    width: 333.0,
                    height: 145.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF252322),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, -1.0),
                                  child: Text(
                                    'Dinner',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 10.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(1.0, -1.0),
                                  child: Text(
                                    '19:00 - 20:00',
                                    textAlign: TextAlign.end,
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 20.0, 10.0, 0.0),
                            child: Text(
                                () {
                                _model.descriptionsDinner?.forEach((name) => tempDinner += "$name\n");
                                return tempDinner;
                              }(),
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                            ),
                          ),
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
    );
  }
}
