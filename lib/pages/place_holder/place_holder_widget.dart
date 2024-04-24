import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import './place_holder_model.dart';

export './place_holder_model.dart';

class PlaceHolderWidget extends StatefulWidget {
  const PlaceHolderWidget({super.key});

  @override
  State<PlaceHolderWidget> createState() => _PlaceHolderWidgetState();
}

class _PlaceHolderWidgetState extends State<PlaceHolderWidget> {
  late PlaceHolderModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlaceHolderModel());
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
        backgroundColor: Theme.of(context).brightness.name == "dark" ? Colors.black12 : Color(0xFFf2cece),
        appBar: AppBar(
          backgroundColor: Color(0xFF2E1F1F),
          automaticallyImplyLeading: false,
          title: Text(
            'Credits',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {
                      return showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('These are the people working on QuickFork:'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Gonçalo Nunes - up202205538'),
                                    Text('Vanessa Queirós - up202207919'),
                                    Text('António Abílio - up202205469'),
                                    Text('Tiago Rocha - up202206232'),
                                    Text('Tiago Pinheiro - up202207890')
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Approve'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Disapprove'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    DocumentReference<Map<String, dynamic>> amount = FirebaseFirestore.instance.collection("DisaproveButton").doc("AmountPressed");

                                    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await amount.get();

                                    dynamic amountOfButtonPressed = documentSnapshot.data()!["buttonPressed"];

                                    FirebaseFirestore.instance.collection("DisaproveButton").doc("AmountPressed").set({
                                                                                                    "buttonPressed" : 1 + amountOfButtonPressed
                                                                                                    });
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                    text: 'Design & Development',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 55.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                      elevation: 2.0,
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
