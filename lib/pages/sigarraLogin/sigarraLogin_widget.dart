import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../sigarraApi/session.dart';
import '../../sigarraApi/sigarraApi.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'sigarraLogin_model.dart';
export 'sigarraLogin_model.dart';

class SigarraLoginWidget extends StatefulWidget {
  const SigarraLoginWidget({super.key});

  @override
  State<SigarraLoginWidget> createState() => _SigarraLoginWidgetState();
}

class _SigarraLoginWidgetState extends State<SigarraLoginWidget>
    with TickerProviderStateMixin {
  late SigarraLoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SigarraLoginModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    )..addListener(_dispose ? () => {} :() => setState(() {}));
    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    animationsMap.addAll({
    'columnOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
    FadeEffect(
    curve: Curves.easeInOut,
    delay: 0.ms,
    duration: 300.ms,
    begin: 0.0,
    end: 1.0,
    ),
    MoveEffect(
    curve: Curves.easeInOut,
    delay: 0.ms,
    duration: 300.ms,
    begin: const Offset(0.0, 60.0),
    end: const Offset(0.0, 0.0),
    ),
    TiltEffect(
    curve: Curves.easeInOut,
    delay: 0.ms,
    duration: 300.ms,
    begin: const Offset(-0.349, 0),
    end: const Offset(0, 0),
    ),
    ],
    ),
    });
  }

  bool _dispose = false;

  @override
  void dispose() {
    try {
      _dispose = true;
      super.dispose();
    } catch(_) {}
  }

  @override
  Widget build(BuildContext context) {
    var clickedStatus = ValueNotifier<bool>(false);
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        //backgroundColor: FlutterFlowTheme.of(context).primaryText,
        backgroundColor: Theme.of(context).brightness.name == "dark" ? Color(0xFF282727) : Color(0xFFf2cece),
        appBar: AppBar(
          backgroundColor: Color(0xFF2E1F1F),
          automaticallyImplyLeading: false,
          title: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                fontSize: 30,
                letterSpacing: 0,
              ),
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  width: 100,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    //color: FlutterFlowTheme.of(context).primaryText,
                      color: Theme.of(context).brightness.name == "dark" ? Color(0xFF282727) : Color(0xFFf2cece),
                  ),
                  alignment: AlignmentDirectional(0, -1),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: 602,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness.name == "dark" ? Color(0xFF282727) : Color(0xFFf2cece),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            alignment: AlignmentDirectional(-1, 0),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 700,
                          constraints: BoxConstraints(
                            maxWidth: 602,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness.name == "dark" ? Color(0xFF282727) : Color(0xFFf2cece),
                          ),
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment(0, 0),
                                  child: TabBar(
                                    isScrollable: false,
                                    splashFactory: NoSplash.splashFactory,
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    labelColor: Theme.of(context).brightness.name == "dark" ? Colors.white : Colors.black,
                                    //unselectedLabelColor: Color(0xFF57636C),
                                    labelPadding: EdgeInsets.all(16),
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF101213),
                                      fontSize: 36,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    indicatorColor: FlutterFlowTheme.of(context).accent3,
                                    indicatorWeight: 4,
                                    indicatorSize: TabBarIndicatorSize.label, // Adjusts indicator width to tab text

                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 0, 30),
                                    tabs: [
                                      Tab(
                                        text: 'QuickFork',
                                      ),
                                    ],
                                    controller: _model.tabBarController,
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _model.tabBarController,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 12, 12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 12, 0, 24),
                                                child: Text(
                                                  'Sign in using your Sigarra credentials',
                                                  style: FlutterFlowTheme.of(
                                                      context)
                                                      .labelMedium
                                                      .override(
                                                    fontFamily:
                                                    'Plus Jakarta Sans',
                                                    color: Theme.of(context).brightness.name == "dark" ? Colors.white : Colors.black,
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 16),
                                                child: Container(
                                                  width: double.infinity,
                                                  child: TextFormField(
                                                    controller: _model
                                                        .emailAddressTextController,
                                                    focusNode: _model
                                                        .emailAddressFocusNode,
                                                    autofocus: true,
                                                    autofillHints: [
                                                      AutofillHints.email
                                                    ],
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'UP Number',
                                                      labelStyle:
                                                      FlutterFlowTheme.of(
                                                          context)
                                                          .labelMedium
                                                          .override(
                                                        fontFamily:
                                                        'Plus Jakarta Sans',
                                                        //color: FlutterFlowTheme.of(context).primaryText,
                                                        color: Theme.of(context).brightness.name == "dark" ? Colors.white : Colors.black,

                                                        fontSize: 14,
                                                        letterSpacing:
                                                        0,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                      ),
                                                      enabledBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                          Color(0xFF4F3B3B),
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(24),
                                                      ),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                          Color(0xFF4F3B3B),
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(24),
                                                      ),
                                                      errorBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                          Color(0xFFFF5963),
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(24),
                                                      ),
                                                      focusedErrorBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                          Color(0xFFFF5963),
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(24),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                      FlutterFlowTheme.of(
                                                          context)
                                                          .alternate,
                                                      contentPadding:
                                                      EdgeInsets.all(24),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMedium
                                                        .override(
                                                      fontFamily:
                                                      'Plus Jakarta Sans',
                                                      color:
                                                      Color(0xFFFFFFFF),
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                    ),
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    cursorColor:
                                                    Color(0xFF4F3B3B),
                                                    validator: _model
                                                        .emailAddressTextControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 16),
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller: _model
                                                          .passwordTextController,
                                                      focusNode: _model
                                                          .passwordFocusNode,
                                                      autofocus: false,
                                                      autofillHints: [
                                                        AutofillHints.password
                                                      ],
                                                      obscureText: !_model
                                                          .passwordVisibility,
                                                      decoration:
                                                      InputDecoration(
                                                        isDense: false,
                                                        labelText: 'Password',
                                                        labelStyle:
                                                        FlutterFlowTheme.of(
                                                            context)
                                                            .labelMedium
                                                            .override(
                                                          fontFamily:
                                                          'Plus Jakarta Sans',
                                                          color: FlutterFlowTheme.of(
                                                              context)
                                                              .primaryText,
                                                          fontSize: 14,
                                                          letterSpacing:
                                                          0,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                        ),
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                            color: Color(
                                                                0xFF4F3B3B),
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(24),
                                                        ),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                            color: Color(0xFF4F3B3B),
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(24),
                                                        ),
                                                        errorBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                            color: Color(
                                                                0xFFFF5963),
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(24),
                                                        ),
                                                        focusedErrorBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                            color: Color(
                                                                0xFFFF5963),
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(24),
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                        FlutterFlowTheme.of(
                                                            context)
                                                            .alternate,
                                                        contentPadding:
                                                        EdgeInsets.all(24),
                                                        suffixIcon: InkWell(
                                                          onTap: _dispose ? () => {} : () => setState(
                                                                () => _model
                                                                .passwordVisibility =
                                                            !_model
                                                                .passwordVisibility,
                                                          ),
                                                          focusNode: FocusNode(
                                                              skipTraversal:
                                                              true),
                                                          child: Icon(
                                                            _model.passwordVisibility
                                                                ? Icons
                                                                .visibility_outlined
                                                                : Icons
                                                                .visibility_off_outlined,
                                                            color: FlutterFlowTheme
                                                                .of(context)
                                                                .primaryText,
                                                            size: 24,
                                                          ),
                                                        ),
                                                      ),
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontFamily:
                                                        'Plus Jakarta Sans',
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .primaryText,
                                                        fontSize: 14,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                      cursorColor:
                                                      Color(0xFF4F3B3B),
                                                      validator: _model
                                                          .passwordTextControllerValidator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                AlignmentDirectional(0, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 16),
                                                  child: ValueListenableBuilder(
                                                    valueListenable: clickedStatus,
                                                    builder: (context, bool isClicked, _) {
                                                      return FFButtonWidget(
                                                        onPressed: isClicked
                                                            ? () {}
                                                            : () async {
                                                          clickedStatus.value = true;
                                                          Session? session = await sigarraLogin(_model.emailAddressTextController.text, _model.passwordTextController.text);

                                                          if (session == null) {
                                                            isClicked = false;
                                                            clickedStatus.value = false;
                                                            return;
                                                          } else {
                                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                                            Uint8List imageBytes = (await getImage(session.cookies, session.username)).bodyBytes;
                                                            if (!_dispose) {
                                                              setState(() {
                                                                prefs.setString(
                                                                    'user_up_code',
                                                                    _model
                                                                        .emailAddressTextController
                                                                        .text);
                                                                prefs.setString(
                                                                    'user_password',
                                                                    _model
                                                                        .passwordTextController
                                                                        .text);
                                                                prefs.setString(
                                                                    'user_faculty',
                                                                    'feup');
                                                                prefs.setString(
                                                                    'user_image_small',
                                                                    base64Encode(
                                                                        imageBytes as List<
                                                                            int>));
                                                                prefs.setString(
                                                                    'user_image_big',
                                                                    base64Encode(
                                                                        imageBytes as List<
                                                                            int>));
                                                                prefs.setBool(
                                                                    'persistent_session',
                                                                    true);
                                                              });
                                                            }
                                                            context.go('/');
                                                          }
                                                        },
                                                        text: 'Sign In',
                                                        options: FFButtonOptions(
                                                          width: 230,
                                                          height: 52,
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 0, 0, 0),
                                                          iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 0, 0, 0),
                                                          color:
                                                          FlutterFlowTheme
                                                              .of(
                                                              context)
                                                              .accent3,
                                                          textStyle:
                                                          FlutterFlowTheme
                                                              .of(
                                                              context)
                                                              .titleSmall
                                                              .override(
                                                            fontFamily:
                                                            'Plus Jakarta Sans',
                                                            color: Colors
                                                                .white,
                                                            fontSize: 16,
                                                            letterSpacing:
                                                            0,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                          ),
                                                          elevation: 3,
                                                          borderSide: BorderSide(color: Colors.transparent, width: 1,),
                                                          borderRadius:
                                                            BorderRadius.circular(40),
                                                        ),
                                                      );
                                                    }
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ).animateOnPageLoad(animationsMap[
                                          'columnOnPageLoadAnimation']!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                Expanded(
                  flex: 6,
                  child: Container(
                    width: 100,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          'https://images.unsplash.com/photo-1508385082359-f38ae991e8f2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80',
                        ),
                      ),
                      borderRadius: BorderRadius.circular(0),
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
