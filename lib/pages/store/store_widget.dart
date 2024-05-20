import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../sigarraApi/session.dart';
import '../../sigarraApi/sigarraApi.dart';
import './store_model.dart';

export './store_model.dart';

class StoreWidget extends StatefulWidget {
  const StoreWidget({super.key});

  @override
  State<StoreWidget> createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<StoreWidget> {
  late StoreModel _model;
  Timer? _timer;
  bool _isLoading = true;
  Session? _session;

  Future<void> _getBoughtTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_session == null && _isLoading) {
      _session = await sigarraLogin(prefs.getString('user_up_code')!, prefs.getString('user_password')!);
    }

    if (_session == null) {
      context.go('/sigarraLogin');
      return;
    }

    _model.userTickets = await queryBoughtTicketRecordOnce(
      queryBuilder: (boughtTicketRecord) =>
          boughtTicketRecord.where(
            'upCode',
            isEqualTo: _session!.username,
          ),
      limit: 12,
    );

    if (_model.userTickets!.isEmpty && _model.userTickets == null) {
      _model.userTickets = [];
    }

    _model.userTickets!.forEach((element) {
      switch (element.meal_id) {
        case 'monday-lunch':
          _model.alreadyBought[0] = true;
          break;
        case 'monday-dinner':
          _model.alreadyBought[1] = true;
          break;
        case 'tuesday-lunch':
          _model.alreadyBought[2] = true;
          break;
        case 'tuesday-dinner':
          _model.alreadyBought[3] = true;
          break;
        case 'wednesday-lunch':
          _model.alreadyBought[4] = true;
          break;
        case 'wednesday-dinner':
          _model.alreadyBought[5] = true;
          break;
        case 'thursday-lunch':
          _model.alreadyBought[6] = true;
          break;
        case 'thursday-dinner':
          _model.alreadyBought[7] = true;
          break;
        case 'friday-lunch':
          _model.alreadyBought[8] = true;
          break;
        case 'friday-dinner':
          _model.alreadyBought[9] = true;
          break;
        case 'saturday-lunch':
          _model.alreadyBought[10] = true;
          break;
        case 'saturday-dinner':
          _model.alreadyBought[11] = true;
          break;
        default:
          throw ArgumentError('ERROR.');
      }
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StoreModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {

      setState(() {
        _isLoading = true;
      });

      try {
         await _getBoughtTickets();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }

      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        await _getBoughtTickets();
        setState(() {
          _isLoading = false;
        });
        Logger().i('Firebase query');
      });

    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Color(0xFFf2cece)
            : Colors.black12,
        appBar: AppBar(
          backgroundColor: Color(0xFF2E1F1F),
          automaticallyImplyLeading: false,
          title: Text(
            'Store',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: _isLoading
          ? Center(child: SpinningFork()) : SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      'Monday',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                            ? Colors.black
                                            : Color(0xFFFFFFFFF),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 5, 4),
                                    child: FFButtonWidget(
                                      onPressed:
                                        _model.alreadyBought[0] ? () {} : () async {
                                          _model.alreadyBought[0] = true;
                                          setState(() {
                                            _isLoading = true; // Update this based on your requirement
                                          });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Monday - Lunch',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'monday-lunch',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                        if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                        _model.alreadyBought[0] = value['success'] as bool;
                                        }
                                        setState(() {_isLoading = false; // Update this based on your requirement
                                        }); }).catchError((error) {
                                          setState(() {
                                          _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[0] ? 'Bought' : 'Buy lunch',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 10, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[1] ? () {} : () async {
                                        _model.alreadyBought[1] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Monday - Dinner',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'monday-dinner',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[1] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[1] ? 'Bought' : 'Buy Dinner',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      'Tuesday',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                            ? Colors.black
                                            : Color(0xFFFFFFFFF),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 5, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[2] ? () {} : () async {
                                        _model.alreadyBought[2] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Tuesday - Lunch',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'tuesday-lunch',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[2] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[2] ? 'Bought' : 'Buy lunch',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 10, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[3] ? () {} : () async {
                                        _model.alreadyBought[3] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Tuesday - Dinner',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'tuesday-dinner',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[3] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[3] ? 'Bought' : 'Buy Dinner',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      'Wednesday',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                            ? Colors.black
                                            : Color(0xFFFFFFFFF),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 5, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[4] ? () {} : () async {
                                        _model.alreadyBought[4] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Wednesday - Lunch',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'wednesday-lunch',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[4] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[4] ? 'Bought' : 'Buy lunch',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 10, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[5] ? () {} : () {
                                        _model.alreadyBought[5] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Wednesday - Dinner',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'wednesday-dinner',
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[5] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[5] ? 'Bought' : 'Buy Dinner',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        //color: _model.alreadyBought[5] ? Colors.black12 : Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      'Thursday',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                            ? Colors.black
                                            : Color(0xFFFFFFFFF),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 5, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[6] ? () {} : () async {
                                        _model.alreadyBought[6] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Thursday - Lunch',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'thursday-lunch',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[6] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[6] ? 'Bought' : 'Buy lunch',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 10, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[7] ? () {} : () async {
                                        _model.alreadyBought[7] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Thursday - Dinner',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'thursday-dinner',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[7] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[7] ? 'Bought' : 'Buy Dinner',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      'Friday',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                            ? Colors.black
                                            : Color(0xFFFFFFFFF),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 5, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[8] ? () {} : () async {
                                        _model.alreadyBought[8] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Friday - Lunch',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'friday-lunch',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[8] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[8] ? 'Bought' : 'Buy lunch',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 10, 4),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[9] ? () {} : () async {
                                        _model.alreadyBought[9] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Friday - Dinner',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'friday-dinner',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[9] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[9] ? 'Bought' : 'Buy Dinner',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      'Saturday',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                            ? Colors.black
                                            : Color(0xFFFFFFFFF),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 5, 10),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[10] ? () {} : () async {
                                        _model.alreadyBought[10] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Saturday - Lunch',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'saturday-lunch',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[10] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[10] ? 'Bought' : 'Buy lunch',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 10, 10),
                                    child: FFButtonWidget(
                                      onPressed: _model.alreadyBought[11] ? () {} : () async {
                                        _model.alreadyBought[11] = true;
                                        setState(() {
                                          _isLoading = true; // Update this based on your requirement
                                        });
                                        context.pushNamed(
                                          'Checkout',
                                          queryParameters: {
                                            'weekDay': serializeParam(
                                              'Saturday - Dinner',
                                              ParamType.String,
                                            ),
                                            'mealID': serializeParam(
                                              'saturday-dinner',
                                              ParamType.String,
                                            )
                                          }.withoutNulls,
                                        ).then((value) {
                                          if (value != null && value is Map<String, bool> && value['success'] is bool) {
                                            _model.alreadyBought[11] = value['success'] as bool;
                                          }
                                          setState(() {_isLoading = false; // Update this based on your requirement
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      text: _model.alreadyBought[11] ? 'Bought' : 'Buy Dinner',
                                      options: FFButtonOptions(
                                        height: 58,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        color: Color(0xFF2E1F1F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
