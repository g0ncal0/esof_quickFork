import 'dart:math';

import 'package:esof/sigarraApi/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/mbWay/mbway_payments.dart';
import '../../sigarraApi/sigarraApi.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/stripe/payment_manager.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'checkout_model.dart';
export 'checkout_model.dart';

class CheckoutWidget extends StatefulWidget {
  const CheckoutWidget({
    super.key,
    required this.weekDay,
    double? mealPrice,
    bool? fullMeal,
    required this.mealID,
  })  : mealPrice = mealPrice ?? 99.99,
        fullMeal = fullMeal ?? true;

  final String? weekDay;
  final double mealPrice;
  final bool fullMeal;
  final String? mealID;

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();

  String createQrCode() {
    String generateRandomId(int length) {
      const characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
      Random random = Random();
      return String.fromCharCodes(Iterable.generate(
          length, (_) =>
          characters.codeUnitAt(random.nextInt(characters.length))));
    }
    String qrcode = generateRandomId(10); // Generate a random string of length 10
    DateTime now = DateTime.now();
    String timeStamp = now.microsecondsSinceEpoch.toString(); // Unique timestamp

    // Concatenate the timestamp with a random string
    String qrCode = qrcode + timeStamp + generateRandomId(6); // 6 additional random characters

    return qrCode;
  }

}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  late CheckoutModel _model;
  late AppStateNotifier _appStateNotifier;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckoutModel());
    _appStateNotifier = AppStateNotifier.instance;

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // mealInfoFirestoreQuery
      _model.mealInfo = await queryWeekelyMealsRecordOnce(
        queryBuilder: (weekelyMealsRecord) => weekelyMealsRecord.where(
          'weekdayMeal',
          isEqualTo: widget.mealID,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      _model.descriptions = actions.concatDescriptions(
        context,
        _model.mealInfo!.descriptionMeat,
        _model.mealInfo!.descriptionFish,
        _model.mealInfo!.descriptionVegetarian,
      );
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void showPaymentStatus(BuildContext context, bool paymentSuccessful) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(paymentSuccessful ? 'Compra bem-sucedida' : 'Erro no pagamento'),
          content: Text(paymentSuccessful ? 'O pagamento foi processado com sucesso!' : 'Ocorreu um erro durante o processamento do pagamento.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }


  
  void addTicketToFirebase() async{
      String qrcode = _model.widget.createQrCode();
      String currentTime = DateTime.now().secondsSinceEpoch.toString();
      CollectionReference<Map<String, dynamic>> ticketRef = FirebaseFirestore.instance.collection("bought_ticket");

      // Query device store info for sigarra login.
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Session? session = await sigarraLogin(prefs.getString('user_up_code')!, prefs.getString('user_password')!);

      if (session == null) {
        context.go('/sigarraLogin');
        return;
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await ticketRef.get();
      await FirebaseFirestore.instance.collection("bought_ticket").doc(qrcode).set({
        "date" : currentTime, // Incrementing the value
        "qrcodeinfo" : qrcode,
        "uid" : (currentUser)!.email ?? '',
        "fullDish" : _model.widget.fullMeal,
        "type" : _model.radioButtonValue,
        "meal_id" : _model.widget.mealID,
        "scanned" : false,
        "upCode" : session.username
      });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope (
        canPop: false,
        child: GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Color(0xFFf2cece)
            : Color(0xff2c2a2a),
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
              //context.pushNamed('Store');
            },
          ),
          title: Text(
            valueOrDefault<String>(
              widget.weekDay,
              'ERROR',
            ),
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 30.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E1F1F),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5.0,
                        color: Color(0x44111417),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 4.0, 8.0, 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 2.0, 0.0, 0.0),
                                child: Icon(
                                  Icons.fastfood_rounded,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: const AlignmentDirectional(1.0, 0.0),
                                  child: Text(
                                    'Choose your meal',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 4.0, 8.0, 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: FlutterFlowChoiceChips(
                                    options: const [
                                      ChipData('Full Meal',
                                          Icons.attach_money_sharp),
                                      ChipData('Only Main Dish',
                                          Icons.attach_money_sharp)
                                    ],
                                    onChanged: (val) async {
                                      if (val?.firstOrNull == 'Full Meal') {
                                        setState(() =>
                                        _model.choiceChipsValue =
                                            val?.firstOrNull);
                                        setState(() {
                                          _model.fullMeal = true;
                                        });
                                      }
                                      else {
                                        setState(() => _model.choiceChipsValue =
                                            val?.firstOrNull);
                                        setState(() {
                                          _model.fullMeal = false;
                                        });
                                      }
                                    },
                                    selectedChipStyle: ChipStyle(
                                      backgroundColor: Colors.deepPurple,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      iconColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      iconSize: 18.0,
                                      elevation: 4.0,
                                      borderColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    unselectedChipStyle: ChipStyle(
                                      backgroundColor: const Color(0xFF4F3B3B),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            letterSpacing: 0.0,
                                          ),
                                      iconColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      iconSize: 18.0,
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    chipSpacing: 12.0,
                                    rowSpacing: 12.0,
                                    multiselect: false,
                                    alignment: WrapAlignment.start,
                                    controller:
                                        _model.choiceChipsValueController ??=
                                            FormFieldController<List<String>>(
                                      [],
                                    ),
                                    wrapped: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    if (_model.descriptions != null &&(_model.descriptions)!.isNotEmpty && _model.choiceChipsValue != null && (_model.choiceChipsValue)!.isNotEmpty)
                      Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                      8.0, 4.0, 8.0, 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (_model.descriptions != null &&
                                (_model.descriptions)!.isNotEmpty && _model.choiceChipsValue != null && (_model.choiceChipsValue)!.isNotEmpty)
                              Expanded(
                                child: Align(
                                  alignment:
                                  const AlignmentDirectional(-1.0, 0.0),
                                  child: FlutterFlowRadioButton(
                                    options: _model.descriptions!.toList(),
                                    onChanged: (val) => setState(() {}),
                                    controller: _model
                                        .radioButtonValueController ??=
                                        FormFieldController<String>(null),
                                    optionHeight: MediaQuery.sizeOf(context).width *
                                        0.1,
                                    optionWidth:
                                    MediaQuery.sizeOf(context).width *
                                        0.8,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                    selectedTextStyle: FlutterFlowTheme.of(
                                        context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.deepPurple,
                                      letterSpacing: 0.0,
                                    ),
                                    buttonPosition:
                                    RadioButtonPosition.left,
                                    direction: Axis.vertical,
                                    radioButtonColor:
                                    Colors.deepPurple,
                                    inactiveRadioButtonColor:
                                    const Color(0xFFC6A9A9),
                                    toggleable: false,
                                    horizontalAlignment:
                                    WrapAlignment.start,
                                    verticalAlignment:
                                    WrapCrossAlignment.start,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_model.radioButtonValue != null &&
                  _model.radioButtonValue != '')
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 0.0),
                  child: Text(
                    'Your total is:',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                          fontSize: 30.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              if (_model.radioButtonValue != null &&
                  _model.radioButtonValue != '')
                Text(
                  (bool fullMeal) {
                    return fullMeal ? '2,95' : '2,75';
                  }(_model.fullMeal),
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.deepPurple,
                        fontSize: 30.0,
                        letterSpacing: 0.0,
                      ),
                ),
              if (_model.radioButtonValue != null &&
                  _model.radioButtonValue != '')
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              final paymentResponse = await processStripePayment(
                                context,
                                amount: (bool fullMeal) {
                                  return fullMeal ? 295 : 275;
                                }(_model.fullMeal),
                                currency: 'EUR',
                                customerEmail: currentUserEmail,
                                description: 'Meal',
                                allowGooglePay: false,
                                allowApplePay: false,
                                buttonColor: FlutterFlowTheme.of(context).primary,
                                buttonTextColor:
                                FlutterFlowTheme.of(context).secondary,
                              );
                              final paymentSuccessful = paymentResponse.paymentId != null && paymentResponse.paymentId!.isNotEmpty;
                              if (paymentResponse.paymentId == null &&
                                  paymentResponse.errorMessage != null) {

                                showSnackbar(
                                  context,
                                  'Error: ${paymentResponse.errorMessage}',
                                );
                              }
                              else {
                                showPaymentStatus(context, paymentSuccessful);
                              }
                              _model.paymentId = paymentResponse.paymentId ?? '';

                              ///////////////////////
                              if (paymentSuccessful) {
                                addTicketToFirebase();
                                final returnValue = {'success': true};
                                while (!Navigator.of(context).canPop()) {}
                                Navigator.of(context).pop(returnValue);
                                Navigator.of(context).pop(returnValue);
                              }
                              /*if (paymentSuccessful){
                                String generateRandomId(int length) {
                                  const characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
                                  Random random = Random();
                                  return String.fromCharCodes(Iterable.generate(
                                      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
                                }

                                String currentTime = DateTime.now().secondsSinceEpoch.toString();
                                String qrcode = generateRandomId(10); // Generate a random string of length 10
                                CollectionReference<Map<String, dynamic>> ticketRef = FirebaseFirestore.instance.collection("bought_ticket");
                                QuerySnapshot<Map<String, dynamic>> querySnapshot = await ticketRef.get();
                                await FirebaseFirestore.instance.collection("bought_ticket").doc(qrcode).set({
                                  "date" : currentTime, // Incrementing the value
                                  "qrcodeinfo" : qrcode,
                                  "uid" : (currentUser)!.email ?? '',
                                  "fullDish" : _model.widget.fullMeal,
                                  "type" : _model.radioButtonValue,
                                  "meal_id" : _model.widget.mealID,
                                  "scanned" : false
                                });

                              }*/
                              ///////////////////////

                              setState(() {});
                            },
                            text: 'Pay with card',
                            options: FFButtonOptions(
                              width: 270.0,
                              height: 50.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: const Color(0xFF2E1F1F),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                              elevation: 2.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),

                      FFButtonWidget(
                        onPressed: () async {
                          var clickedStatus = ValueNotifier<bool>(false);
                          String phoneNum = _appStateNotifier.phoneNum;

                          if (phoneNum.isNotEmpty) {
                            var result = await payWithMbway(phoneNum, _model.fullMeal ? '2.75' : '2.95');
                            String response = result.entries.first.value;

                            if (result.keys.first) {
                              return showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (
                                      BuildContext context) {
                                    return AlertDialog(
                                        title: const Text(
                                            'MbWay Response'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <
                                                Widget>[
                                              Text(
                                                  response),
                                            ],
                                          ),
                                        ),
                                        actions: <
                                            Widget>[
                                          TextButton(
                                            child: const Text(
                                                'Ok!'),
                                            onPressed: () {
                                              final returnValue = {'success': true, 'message': 'Purchase completed!'};
                                              addTicketToFirebase();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop(returnValue);
                                            },
                                          )
                                        ]
                                    );
                                  }
                              );
                            } else {
                              return showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text('MbWay Response'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(response),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text(
                                                'Dismiss'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ]
                                    );
                                  }
                              );
                            }
                          } else {
                            return showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  RegExp regex = RegExp(r'^[0-9]{9,}$');
                                  var inputController = TextEditingController();
                                  return AlertDialog(
                                      clipBehavior: Clip.none,
                                      title: const Text('MbWay Response'),
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
                                                  if (regex.hasMatch(inputController.text)) {
                                                    phoneNum = "351#${inputController.text}";
                                                    var result = await payWithMbway(
                                                        phoneNum,
                                                        _model.fullMeal
                                                            ? '2.75'
                                                            : '2.95');
                                                    String response = result
                                                        .entries.first.value;


                                                    if (result.keys.first) {
                                                      return showDialog<void>(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          // user must tap button!
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                                title: const Text('MbWay Response'),
                                                                content: SingleChildScrollView(
                                                                  child: ListBody(
                                                                    children: <Widget>[
                                                                      Text(response),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: const Text('Ok!'),
                                                                    onPressed: () {
                                                                      addTicketToFirebase();
                                                                      final returnValue = {'success': true, 'message': 'Purchase completed!'};
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).pop(returnValue);
                                                                    },
                                                                  )
                                                                ]
                                                            );
                                                          }
                                                      );
                                                    } else {
                                                      return showDialog<void>(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          // user must tap button!
                                                          builder: (
                                                              BuildContext context) {
                                                            return AlertDialog(
                                                                title: const Text('MbWay Response'),
                                                                content: SingleChildScrollView(
                                                                  child: ListBody(
                                                                    children: <Widget>[
                                                                      Text(response),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: const Text('Dismiss'),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  )
                                                                ]
                                                            );
                                                          }
                                                      );
                                                    }
                                                  } else {
                                                    return showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        // user must tap button!
                                                        builder: (
                                                            BuildContext context) {
                                                          return AlertDialog(
                                                              title: const Text(
                                                                  'Unknown error, missing Phone Number.'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: const Text('Dismiss'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
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
                          }
                        },
                        text: 'Pay with MBWay',
                        options: FFButtonOptions(
                          width: 270.0,
                          height: 50.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: const Color(0xFF2E1F1F),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 2.0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
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
    );
  }
}
