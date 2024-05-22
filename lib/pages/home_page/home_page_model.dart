import 'package:flutter/material.dart';

import '../../backend/schema/weekely_meals_record.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import './home_page_widget.dart' show HomePageWidget;

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  WeekelyMealsRecord? mealInfoLunch;
  WeekelyMealsRecord? mealInfoDinner;
  List<String>? descriptionsLunch;
  List<String>? descriptionsDinner;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
