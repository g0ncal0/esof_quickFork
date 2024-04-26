import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'place_holder_widget.dart' show PlaceHolderWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlaceHolderModel extends FlutterFlowModel<PlaceHolderWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  List<BoughtTicketRecord>? userTickets;

  List<bool> boughtTickets = [false,false,false,
                              false,false,false,
                              false,false,false,
                              false,false,false];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
