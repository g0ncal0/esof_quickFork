import 'package:flutter/material.dart';

import '../../backend/mbWay/mbway_payments.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import './perfil_model.dart';

export './perfil_model.dart';


class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;
  late AppStateNotifier _appStateNotifier;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());
    _appStateNotifier = AppStateNotifier.instance;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _showWorkerLoginPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController passwordController = TextEditingController();

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
                  Navigator.pop(context);
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
        key: scaffoldKey,
        backgroundColor: Color(0xFF1F1D1D),
        appBar: AppBar(
          backgroundColor: Color(0xFF2E1F1F),
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
              context.safePop();
            },
          ),
          title: Align(
            alignment: AlignmentDirectional(-1.29, -1.0),
            child: Text(
              'MainMenu',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 22.0,
              ),
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(-0.59, -0.77),
                child: Text(
                  'Profile',
                  style: FlutterFlowTheme.of(context).headlineLarge.override(
                    fontFamily: 'Outfit',
                    color: Color(0xFFD2AD94),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.82, -0.92),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Image.network(
                    'https://picsum.photos/seed/331/600',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),



              if(_appStateNotifier.cardNum.isEmpty)
                Align(
                  alignment: AlignmentDirectional(0, -0.20),
                  child: FFButtonWidget(
                    onPressed: () {
                      var clickedStatus = ValueNotifier<bool>(false);
                      return showDialog<void>(

                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            RegExp regex = RegExp(r'^[0-9]{9,}$');
                            var inputController = TextEditingController();
                            var cvvController = TextEditingController();
                            return AlertDialog(
                                clipBehavior: Clip.none,
                                title: const Text('Add credit card number'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      TextField(
                                        keyboardType: TextInputType.phone,
                                        maxLength: 16,
                                        autofocus: true,
                                        controller: inputController,
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.text,
                                        maxLength: 3,
                                        controller: cvvController,
                                        decoration: InputDecoration(labelText: 'CVV'),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  ValueListenableBuilder(
                                      valueListenable: clickedStatus,
                                      builder: (context, bool isClicked, _) {
                                        return TextButton(
                                          child: const Text('Ok!'),
                                          onPressed: isClicked
                                              ? () {}
                                              : () async {
                                            clickedStatus.value = true;
                                            if (regex.hasMatch(
                                                inputController.text)) {
                                              _appStateNotifier.setCardNum(inputController.text);
                                              _appStateNotifier.setCVV(cvvController.text);
                                              //aqui esta errado o result e response. é necessario verificar se existe conta mbway associada


                                              if ((_appStateNotifier.cardNum.length == 16) && (_appStateNotifier.cvv.length == 3)) {
                                                return showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // user must tap button!
                                                    builder: (
                                                        BuildContext context) {
                                                      return AlertDialog(
                                                          title: const Text(
                                                              'Add your card'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    "Sucessufully added card"),
                                                              ],
                                                            ),
                                                          ),

                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {

                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();

                                                              },
                                                              child: Text('Ok'),
                                                            )
                                                          ]
                                                      );
                                                    }
                                                );
                                              }
                                            }
                                            else {
                                              _appStateNotifier.setCardNum("");
                                              _appStateNotifier.setCVV("");
                                              return showDialog<void>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  // user must tap button!
                                                  builder: (
                                                      BuildContext context) {
                                                    return AlertDialog(
                                                        title: const Text(
                                                            'Invalid card number.'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'Dismiss'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ]
                                                    );
                                                  }
                                              );
                                            }
                                          },
                                        );
                                      })
                                ]
                            );
                          }
                      );


                    },

                    text: 'Add credit card',
                    options: FFButtonOptions(
                      width: 325.0,
                      height: 100.0,
                      padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme
                          .of(context)
                          .secondaryBackground,
                      textStyle: FlutterFlowTheme
                          .of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme
                            .of(context)
                            .primaryText,
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



              if(_appStateNotifier.cardNum.isNotEmpty)
                Align(
                  alignment: AlignmentDirectional(0, -0.20),
                  child: FFButtonWidget(
                    onPressed: () {

                      var clickedStatus = ValueNotifier<bool>(false);
                      return showDialog<void>(

                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            var inputController = TextEditingController();
                            return AlertDialog(
                                clipBehavior: Clip.none,
                                title: const Text('Removing card'),
                                content:Text('Do you wish to proceed?'),
                                actions: [
                                  TextButton(onPressed: () {
                                    _appStateNotifier.setCardNum("");
                                    _appStateNotifier.setCVV("");
                                    Navigator.of(context).pop(true);
                                  },

                                    child: Text('Yes'),
                                  ),
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },

                                    child: Text('No'),
                                  )
                                ]
                            );
                          }
                      );


                    },
                    text: 'xxxx xxxx xxxx xxxx ${_appStateNotifier.cardNum.substring(12)}',
                    options: FFButtonOptions(
                      width: 325.0,
                      height: 100.0,
                      padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme
                          .of(context)
                          .secondaryBackground,
                      textStyle: FlutterFlowTheme
                          .of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme
                            .of(context)
                            .primaryText,
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







              if(_appStateNotifier.phoneNum.isEmpty)
                Align(
                  alignment: AlignmentDirectional(0.04, 0.34),
                  child: FFButtonWidget(
                    onPressed: () {
                      var clickedStatus = ValueNotifier<bool>(false);
                      return showDialog<void>(

                          context: context,
                          barrierDismissible: true, // user must tap button!
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
                                      builder: (context, bool isClicked, _) {
                                        return TextButton(
                                          child: const Text('Ok!'),
                                          onPressed: isClicked
                                              ? () {}
                                              : () async {
                                            clickedStatus.value = true;
                                            if (regex.hasMatch(
                                                inputController.text)) {
                                              _appStateNotifier.setPhoneNum("351#${inputController.text}");
                                              //aqui esta errado o result e response. é necessario verificar se existe conta mbway associada


                                              if (_appStateNotifier.phoneNum.length == 13) {
                                                return showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // user must tap button!
                                                    builder: (
                                                        BuildContext context) {
                                                      return AlertDialog(
                                                          title: const Text(
                                                              'Add your number'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    "Sucessufully added number"),
                                                              ],
                                                            ),
                                                          ),

                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {

                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();

                                                              },
                                                              child: Text('Ok'),
                                                            )
                                                          ]
                                                      );
                                                    }
                                                );
                                              }
                                            }
                                            else {
                                              return showDialog<void>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  // user must tap button!
                                                  builder: (
                                                      BuildContext context) {
                                                    return AlertDialog(
                                                        title: const Text(
                                                            'Missing Phone Number.'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'Dismiss'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ]
                                                    );
                                                  }
                                              );
                                            }
                                          },
                                        );
                                      })
                                ]
                            );
                          }
                      );


                    },

                    text: 'Associate MBWay',
                    options: FFButtonOptions(
                      width: 300.0,
                      height: 68.0,
                      padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme
                          .of(context)
                          .primaryBackground,
                      textStyle: FlutterFlowTheme
                          .of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme
                            .of(context)
                            .primaryText,
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


              if(_appStateNotifier.phoneNum.isNotEmpty)
                Align(
                  alignment: AlignmentDirectional(0.04, 0.34),
                  child: FFButtonWidget(
                    onPressed: () {

                      var clickedStatus = ValueNotifier<bool>(false);
                      return showDialog<void>(

                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            var inputController = TextEditingController();
                            return AlertDialog(
                                clipBehavior: Clip.none,
                                title: const Text('Removing number'),
                                content:Text('Do you wish to proceed?'),
                                actions: [
                                  TextButton(onPressed: () {
                                    _appStateNotifier.setPhoneNum("");
                                    Navigator.of(context).pop(true);
                                  },

                                    child: Text('Yes'),
                                  ),
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },

                                    child: Text('No'),
                                  )
                                ]
                            );
                          }
                      );


                    },
                    text: _appStateNotifier.phoneNum.split('#')[1],
                    options: FFButtonOptions(
                      width: 300.0,
                      height: 68.0,
                      padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme
                          .of(context)
                          .primaryBackground,
                      textStyle: FlutterFlowTheme
                          .of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme
                            .of(context)
                            .primaryText,
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
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'Sign Out',
                  options: FFButtonOptions(
                    width: 200.0,
                    height: 66.0,
                    padding:
                    EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding:
                    EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF252322),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
                      padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFF252322),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
                          content: Text('Worker Logout done successfully!'),
                        ),
                      );
                    },
                    text: 'Worker Logout',
                    options: FFButtonOptions(
                      width: 200.0,
                      height: 66.0,
                      padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFF252322),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
