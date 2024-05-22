import 'dart:convert';

import 'package:esof/sigarraApi/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/firebase_auth/firebase_auth_manager.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../sigarraApi/sigarraApi.dart';
import './perfil_model.dart';

export './perfil_model.dart';

class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;

  Uint8List? image;

  late AppStateNotifier _appStateNotifier;

  bool _isLoading = true;

  void _clearLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!_dispose) {
      setState(() {
        prefs.setString('user_up_code', '');
        prefs.setString('user_password', '');
        prefs.setString('user_faculty', '');
        prefs.setString('user_image_small', '');

        _appStateNotifier.username = '';
        _appStateNotifier.password = '';
        _appStateNotifier.faculty = '';
        _appStateNotifier.image_small = '';

        final authManager = FirebaseAuthManager();
        authManager.signOut();
      });
    }
  }

  Future<Session?> _loadSession() async {
    return sigarraLogin(_appStateNotifier.username, _appStateNotifier.password);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());
    _appStateNotifier = AppStateNotifier.instance;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Session? session = await _loadSession();

      if (session != null) {
        image = base64Decode(_appStateNotifier.image_big) as Uint8List;
        if (image == null || image!.isEmpty) {
          image = (await getImage(session.cookies, session.username)).bodyBytes;
        }
      } else {
        context.go('/sigarraLogin');
      }

      if (!_dispose) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  bool _dispose = false;

  @override
  void dispose() {
    try {
      _dispose = true;
      super.dispose();
    } catch (_) {}
  }

  void _showWorkerLoginPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController passwordController =
            TextEditingController();

        return AlertDialog(
          title: Text('Worker Login'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (passwordController.text == '1234') {
                  _appStateNotifier.setAdmin(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Worker access granted!'),
                    ),
                  );
                  this.context.pushReplacement('/');
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid password'),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        backgroundColor: Theme.of(context).brightness.name == "dark"
            ? Color(0xff2c2c2c)
            : Color(0xFFf2cece),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2E1F1F),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              final returnValue = {'success': false};
              while (!Navigator.of(context).canPop()) {}
              Navigator.of(context).pop(returnValue);
            },
          ),
          title: Text(
            '',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _isLoading
            ? Center(child: SpinningFork())
            : SafeArea(
                top: true,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.59, -0.77),
                      child: Text(
                        'Profile',
                        style:
                            FlutterFlowTheme.of(context).headlineLarge.override(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFFD2AD94),
                                ),
                      ),
                    ),
                    if (image != null)
                      Align(
                        alignment: AlignmentDirectional(0.82, -0.92),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18.0),
                          child: Image.memory(image!),
                        ),
                      ),
                    if (_appStateNotifier.phoneNum.isEmpty)
                      Align(
                        alignment: AlignmentDirectional(0.04, 0.34),
                        child: FFButtonWidget(
                          onPressed: () {
                            var clickedStatus = ValueNotifier<bool>(false);
                            return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) {
                                  RegExp regex = RegExp(r'^[0-9]{9,}$');
                                  var inputController = TextEditingController();
                                  return AlertDialog(
                                      clipBehavior: Clip.none,
                                      title: const Text('Add your number'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            TextField(
                                              keyboardType: TextInputType.phone,
                                              maxLength: 9,
                                              autofocus: true,
                                              controller: inputController,
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ValueListenableBuilder(
                                            valueListenable: clickedStatus,
                                            builder:
                                                (context, bool isClicked, _) {
                                              return TextButton(
                                                child: const Text('Ok!'),
                                                onPressed: isClicked
                                                    ? () {}
                                                    : () async {
                                                        clickedStatus.value =
                                                            true;
                                                        if (regex.hasMatch(
                                                            inputController
                                                                .text)) {
                                                          _appStateNotifier
                                                              .setPhoneNum(
                                                                  "351#${inputController.text}");
                                                          this.context.pushReplacement('/');
                                                          if (_appStateNotifier.phoneNum.length == 13) {
                                                            return showDialog<void>(
                                                                context: context,
                                                                barrierDismissible: false,
                                                                // user must tap button!
                                                                builder: (BuildContext context) {
                                                                  return AlertDialog(
                                                                      title: const Text('Add your number'),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            ListBody(
                                                                          children: <Widget>[
                                                                            Text("Sucessufully added number"),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                              this.context.pushReplacement('/');
                                                                          },
                                                                          child:
                                                                              Text('Ok'),
                                                                        )
                                                                      ]);
                                                                });
                                                          }
                                                        } else {
                                                          return showDialog<
                                                                  void>(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              // user must tap button!
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                    title: const Text(
                                                                        'Missing Phone Number.'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Dismiss'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )
                                                                    ]);
                                                              });
                                                        }
                                                      },
                                              );
                                            })
                                      ]);
                                });
                          },
                          text: 'Associate MBWay',
                          options: FFButtonOptions(
                            width: 300.0,
                            height: 68.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 25.0,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    if (_appStateNotifier.phoneNum.isNotEmpty)
                      Align(
                        alignment: AlignmentDirectional(0.04, 0.34),
                        child: FFButtonWidget(
                          onPressed: () {
                            var clickedStatus = ValueNotifier<bool>(false);
                            return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) {
                                  var inputController = TextEditingController();
                                  return AlertDialog(
                                      clipBehavior: Clip.none,
                                      title: const Text('Removing number'),
                                      content: Text('Do you wish to proceed?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            _appStateNotifier.setPhoneNum("");
                                            this.context.pushReplacement('/');
                                          },
                                          child: Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            this.context.pushReplacement('/');
                                          },
                                          child: Text('No'),
                                        )
                                      ]);
                                });
                          },
                          text: _appStateNotifier.phoneNum.split('#')[1],
                          options: FFButtonOptions(
                            width: 300.0,
                            height: 68.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 25.0,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    Align(
                      alignment: AlignmentDirectional(-0.01, 0.92),
                      child: FFButtonWidget(
                        onPressed: () async {
                          _appStateNotifier.setAdmin(false);
                          _clearLogin();
                          context.go('/sigarraLogin');
                        },
                        text: 'Sign Out',
                        options: FFButtonOptions(
                          width: 200.0,
                          height: 66.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Color(0xFF252322),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Color(0xFFD2AD94),
                                    fontSize: 25.0,
                                  ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    if (!_appStateNotifier.isAdmin)
                      Align(
                        alignment: AlignmentDirectional(-0.01, 0.65),
                        child: FFButtonWidget(
                          onPressed: () {
                            _showWorkerLoginPopup();
                          },
                          text: 'Worker Login',
                          options: FFButtonOptions(
                            width: 200.0,
                            height: 66.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF252322),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFFD2AD94),
                                  fontSize: 25.0,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    if (_appStateNotifier.isAdmin)
                      Align(
                        alignment: AlignmentDirectional(-0.01, 0.65),
                        child: FFButtonWidget(
                          onPressed: () {
                            _appStateNotifier.setAdmin(false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Worker Logout done successfully!'),
                              ),
                            );
                            this.context.pushReplacement('/');
                          },
                          text: 'Worker Logout',
                          options: FFButtonOptions(
                            width: 200.0,
                            height: 66.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF252322),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFFD2AD94),
                                  fontSize: 25.0,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
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
