import '/flutter_flow/flutter_flow_util.dart';
import 'qr_code_widget.dart' show QrCodeWidget;
import 'package:flutter/material.dart';

class QrCodeModel extends FlutterFlowModel<QrCodeWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
