import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'validation_model.dart';

export 'validation_model.dart';

class ValidationWidget extends StatefulWidget {
  const ValidationWidget({
    super.key,
    String? outputTest,
  }) : this.outputTest = outputTest ?? '0';

  final String outputTest;


  @override
  State<ValidationWidget> createState() => _ValidationWidgetState();
}

class _ValidationWidgetState extends State<ValidationWidget> {
  late ValidationModel _model;
  bool _isValid = true;

  Future<void> checkIfScannedCodeValid() async {
    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
        .instance
        .collection("bought_ticket")
        .doc(_model.scannedValue);

    if (documentRef != null) {
      // Check if the document exists
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await documentRef.get();
      if (documentSnapshot.exists && documentSnapshot.data()!["scanned"]) {
        _isValid = false;
      }
    } else {
      _isValid = false;
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ValidationModel());
  }

  bool _dispose = false;

  @override
  void dispose() {
    try {
      _dispose = true;
      super.dispose();
    } catch (_) {}
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
            'Ticket Validation',
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
                Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        _model.scannedValue =
                            await FlutterBarcodeScanner.scanBarcode(
                          '#C62828', // scanning line color
                          'Cancel', // cancel button text
                          true, // whether to show the flash icon
                          ScanMode.QR,
                        );

                        if (!_dispose) {
                          setState(() {
                            _isValid = true;
                          });
                        }

                        await checkIfScannedCodeValid();

                        if (_isValid) {
                          await _model.scanQrCode();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The Qrcode is valid.')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The Qrcode is invalid.')));
                        }

                        if (!_dispose) {
                          setState(() {
                            _isValid = true;
                          });
                        }

                        if (!_dispose) {
                          setState(() {});
                        }
                      },
                      text: 'Scan Ticket',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 60,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
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
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
