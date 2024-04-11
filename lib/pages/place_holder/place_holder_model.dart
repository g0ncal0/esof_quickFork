import '/flutter_flow/flutter_flow_util.dart';
import 'place_holder_widget.dart' show PlaceHolderWidget;
import 'package:flutter/material.dart';

class PlaceHolderModel extends FlutterFlowModel<PlaceHolderWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
