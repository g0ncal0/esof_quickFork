import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'checkfirebasestats_widget.dart' show CheckFirebaseStatsWidget;

class CheckFirebaseStatsModel
    extends FlutterFlowModel<CheckFirebaseStatsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  WeekelyMealsRecord? mealInfo;
  List<String>? descriptions;

  FirebaseFirestore? firebaseFirestore;

  get getFirebaseFirestore => firebaseFirestore;

  void set setFirebaseFirestore(FirebaseFirestore? firebaseFirestore2) {
    firebaseFirestore = firebaseFirestore2;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
