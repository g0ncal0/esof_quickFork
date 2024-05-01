import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'place_holder_model.dart';
export 'place_holder_model.dart';

class PlaceHolderWidget extends StatefulWidget {
  const PlaceHolderWidget({
    super.key,
    String? outputTest,
  }) : this.outputTest = outputTest ?? '0';

  final String outputTest;

  @override
  State<PlaceHolderWidget> createState() => _PlaceHolderWidgetState();
}

class _PlaceHolderWidgetState extends State<PlaceHolderWidget> {
  late PlaceHolderModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void updateBoughtTickets() async{
    _model.userTickets = await queryBoughtTicketRecordOnce(
      queryBuilder: (boughtTicketRecord) =>
          boughtTicketRecord.where(
            'uid',
            isEqualTo: currentUserEmail,
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

      setState(() {

      });
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlaceHolderModel());
    updateBoughtTickets();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
            'Credits',
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_model.alreadyScanned[0] && _model.ticketsInfo[0] != '') Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        // Substituida por função de cima.

                        context.pushNamed(
                          'QrCode',
                          queryParameters: {
                            'qrCodeValue': serializeParam(
                              _model.ticketsInfo[0],
                              ParamType.String,
                            ),
                            'fullMeal': serializeParam(
                              false,
                              ParamType.bool,
                            ),
                          }.withoutNulls,
                        );
                      },
                      text: 'Show Monday Lunch QR Code',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 55,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                        elevation: 2,
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
