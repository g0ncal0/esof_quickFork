import '/flutter_flow/flutter_flow_util.dart';
import 'meal_widget.dart' show MealWidget;
import 'package:flutter/material.dart';

class MealModel extends FlutterFlowModel<MealWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
