import 'package:flutter/material.dart';

import '../../backend/schema/bought_ticket_record.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import './store_widget.dart' show StoreWidget;

class StoreModel extends FlutterFlowModel<StoreWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  List<bool> alreadyBought = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<bool> deactivateButton = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  bool ignoreFocus = true;

  List<BoughtTicketRecord>? userTickets;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

}
