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
          _model.boughtTickets[0] = true;
          break;
        case 'monday-dinner':
          _model.boughtTickets[1] = true;
          break;
        case 'tuesday-lunch':
          _model.boughtTickets[2] = true;
          break;
        case 'tuesday-dinner':
          _model.boughtTickets[3] = true;
          break;
        case 'wednesday-lunch':
          _model.boughtTickets[4] = true;
          break;
        case 'wednesday-dinner':
          _model.boughtTickets[5] = true;
          break;
        case 'thursday-lunch':
          _model.boughtTickets[6] = true;
          break;
        case 'thursday-dinner':
          _model.boughtTickets[7] = true;
          break;
        case 'friday-lunch':
          _model.boughtTickets[8] = true;
          break;
        case 'friday-dinner':
          _model.boughtTickets[9] = true;
          break;
        case 'saturday-lunch':
          _model.boughtTickets[10] = true;
          break;
        case 'saturday-dinner':
          _model.boughtTickets[11] = true;
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
    print("AMERICA YAAAAAAAA"); // ToDo remove
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
                if (_model.boughtTickets[0]) Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        // Substituida por função de cima.
                        /*
                        context.pushNamed(
                          'QrCode',
                          queryParameters: {
                            'qrCodeValue': serializeParam(
                              'aqaaaaswdwfwgweg',
                              ParamType.String,
                            ),
                            'fullMeal': serializeParam(
                              false,
                              ParamType.bool,
                            ),
                          }.withoutNulls,
                        );*/
                      },
                      text: 'Print Hello World',
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
                
                
                ),
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: FFButtonWidget(
                    onPressed: () async {
                      _model.scannedValue = await FlutterBarcodeScanner.scanBarcode(
                        '#C62828', // scanning line color
                        'Cancel', // cancel button text
                        true, // whether to show the flash icon
                        ScanMode.QR,
                      );

                      DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection("bought_ticket").doc(_model.scannedValue);

                      if (documentRef != null){
                        // Check if the document exists
                        DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();
                        if (documentSnapshot.exists && !documentSnapshot.data()!["scanned"]) {
                          // Document exists and is not scanned
                          await documentRef.set({
                            "scanned": true // Ticket can only be used once
                          }, SetOptions(merge: true));
                        }
                      }

                      setState(() {});
                    },
                    text: 'Button',
                    options: FFButtonOptions(
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                ),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
