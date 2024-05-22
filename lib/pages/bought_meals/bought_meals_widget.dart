import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../sigarraApi/session.dart';
import '../../sigarraApi/sigarraApi.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'bought_meals_model.dart';

export 'bought_meals_model.dart';

String getMealName(int idx) {
  String mealName = "";

  switch (idx) {
    case 0:
      mealName = "Monday Lunch";
      break;
    case 1:
      mealName = "Monday Dinner";
      break;
    case 2:
      mealName = "Tuesday Lunch";
      break;
    case 3:
      mealName = "Tuesday Dinner";
      break;
    case 4:
      mealName = "Wednesday Lunch";
      break;
    case 5:
      mealName = "Wednesday Dinner";
      break;
    case 6:
      mealName = "Thursday Lunch";
      break;
    case 7:
      mealName = "Thursday Dinner";
      break;
    case 8:
      mealName = "Friday Lunch";
      break;
    case 9:
      mealName = "Friday Dinner";
      break;
    case 10:
      mealName = "Saturday Lunch";
      break;
    case 11:
      mealName = "Saturday Dinner";
      break;
  }

  return mealName;
}

class NextTicketButton extends StatelessWidget {
  final BoughtMealsModel model;

  const NextTicketButton({
    Key? key,
    required this.model,
  }) : super(key: key);

  int getNextMealIdx() {
    DateTime now = DateTime.now();

    int weekday = now.weekday;
    int hour = now.hour;

    switch (weekday) {
      case 1:
        return ((hour < 15) ? 0 : 1);
      case 2:
        return ((hour < 15) ? 2 : 3);
      case 3:
        return ((hour < 15) ? 4 : 5);
      case 4:
        return ((hour < 15) ? 6 : 7);
      case 5:
        return ((hour < 15) ? 8 : 9);
      case 6:
        return ((hour < 15) ? 10 : 11);
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    int idx = getNextMealIdx();
    String mealName = getMealName(idx);

    if (!model.alreadyScanned[idx] && model.ticketsInfo[idx] != '') {
      return Padding(
        padding: const EdgeInsets.only(top: 250, bottom: 250),
        child: FFButtonWidget(
          onPressed: () async {
            context.pushNamed(
              'QrCode',
              queryParameters: {
                'qrCodeValue': serializeParam(
                  model.ticketsInfo[idx],
                  ParamType.String,
                ),
                'fullMeal': serializeParam(
                  false,
                  ParamType.bool,
                ),
              }.withoutNulls,
            );
          },
          text: 'Next Meal Ticket',
          options: FFButtonOptions(
            width: double.infinity,
            height: 100,
            color: Color(0xFF2E1F1F),
            textStyle: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Readex Pro',
                  color: Colors.white,
                  letterSpacing: 0,
                ),
            elevation: 2,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 235, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
          child: Text(
            "You don't have a ticket for the next meal \n ($mealName)",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}

class TicketButton extends StatelessWidget {
  final BoughtMealsModel model;
  final int idx;

  const TicketButton({
    Key? key,
    required this.model,
    required this.idx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mealName = getMealName(idx);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FFButtonWidget(
        onPressed: () async {
          context.pushNamed(
            'QrCode',
            queryParameters: {
              'qrCodeValue': serializeParam(
                model.ticketsInfo[idx],
                ParamType.String,
              ),
              'fullMeal': serializeParam(
                false,
                ParamType.bool,
              ),
            }.withoutNulls,
          );
        },
        text: '$mealName',
        options: FFButtonOptions(
          width: double.infinity,
          height: 55,
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          color: Color(0xFF2E1F1F),
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                letterSpacing: 0,
              ),
          elevation: 2,
        ),
      ),
    );
  }
}

class BoughtMealsWidget extends StatefulWidget {
  const BoughtMealsWidget({
    super.key,
    String? outputTest,
  }) : this.outputTest = outputTest ?? '0';

  final String outputTest;

  @override
  State<BoughtMealsWidget> createState() => _BoughtMealsWidgetState();
}

class _BoughtMealsWidgetState extends State<BoughtMealsWidget> {
  late BoughtMealsModel _model;
  bool showMore = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void updateBoughtTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Session? session = await sigarraLogin(
        prefs.getString('user_up_code')!, prefs.getString('user_password')!);

    if (session == null) {
      context.go('/sigarraLogin');
      return;
    }

    _model.userTickets = await queryBoughtTicketRecordOnce(
      queryBuilder: (boughtTicketRecord) => boughtTicketRecord.where(
        'upCode',
        isEqualTo: session.username,
      ),
      limit: 12,
    );

    if (_model.userTickets!.isEmpty && _model.userTickets == null) {
      _model.userTickets = [];
    }

    _model.userTickets!.forEach((element) {
      switch (element.meal_id) {
        case 'monday-lunch':
          _model.alreadyScanned[0] = element.scanned;
          _model.ticketsInfo[0] = element.qrcodeinfo;
          break;
        case 'monday-dinner':
          _model.alreadyScanned[1] = element.scanned;
          _model.ticketsInfo[1] = element.qrcodeinfo;
          break;
        case 'tuesday-lunch':
          _model.alreadyScanned[2] = element.scanned;
          _model.ticketsInfo[2] = element.qrcodeinfo;
          break;
        case 'tuesday-dinner':
          _model.alreadyScanned[3] = element.scanned;
          _model.ticketsInfo[3] = element.qrcodeinfo;
          break;
        case 'wednesday-lunch':
          _model.alreadyScanned[4] = element.scanned;
          _model.ticketsInfo[4] = element.qrcodeinfo;
          break;
        case 'wednesday-dinner':
          _model.alreadyScanned[5] = element.scanned;
          _model.ticketsInfo[5] = element.qrcodeinfo;
          break;
        case 'thursday-lunch':
          _model.alreadyScanned[6] = element.scanned;
          _model.ticketsInfo[6] = element.qrcodeinfo;
          break;
        case 'thursday-dinner':
          _model.alreadyScanned[7] = element.scanned;
          _model.ticketsInfo[7] = element.qrcodeinfo;
          break;
        case 'friday-lunch':
          _model.alreadyScanned[8] = element.scanned;
          _model.ticketsInfo[8] = element.qrcodeinfo;
          break;
        case 'friday-dinner':
          _model.alreadyScanned[9] = element.scanned;
          _model.ticketsInfo[9] = element.qrcodeinfo;
          break;
        case 'saturday-lunch':
          _model.alreadyScanned[10] = element.scanned;
          _model.ticketsInfo[10] = element.qrcodeinfo;
          break;
        case 'saturday-dinner':
          _model.alreadyScanned[11] = element.scanned;
          _model.ticketsInfo[11] = element.qrcodeinfo;
          break;
        default:
          throw ArgumentError('ERROR.');
      }

      if (!_dispose) {
        setState(() {});
      }
    });
  }

  bool _dispose = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BoughtMealsModel());
    updateBoughtTickets();
  }

  @override
  void dispose() {
    try {
      _dispose = true;
      super.dispose();
    } catch (_) {}
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
            'Bought Meals',
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
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NextTicketButton(model: _model),
                  GestureDetector(
                    onTap: () {
                      if (!_dispose) {
                        setState(() {
                          showMore = !showMore;
                        });
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          showMore ? 'See Less' : 'See More',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 40,
                                letterSpacing: 0,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Icon(
                            showMore
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showMore)
                    for (int i = 0; i < 12; i++)
                      if (!_model.alreadyScanned[i] &&
                          _model.ticketsInfo[i] != '')
                        TicketButton(idx: i, model: _model),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
