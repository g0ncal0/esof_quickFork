import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'qr_code_model.dart';
export 'qr_code_model.dart';

class QrCodeWidget extends StatefulWidget {
  const QrCodeWidget({
    super.key,
    required this.qrCodeValue,
    required this.fullMeal,
  });

  final String? qrCodeValue;
  final bool? fullMeal;

  @override
  State<QrCodeWidget> createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> {
  late QrCodeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QrCodeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await queryUserBoughtTicketsRecordOnce(
        queryBuilder: (userBoughtTicketsRecord) =>
            userBoughtTicketsRecord.where(
          'email',
          isEqualTo: currentUserEmail,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
    });
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: const Color(0xFF2E1F1F),
          automaticallyImplyLeading: false,
          title: Text(
            'QRCode - Meal',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Type: ',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0.0,
                                ),
                          ),
                          Text(
                            widget.fullMeal! ? 'FullMeal' : 'Only main dish',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: BarcodeWidget(
                          data: widget.qrCodeValue!,
                          barcode: Barcode.qrCode(),
                          width: MediaQuery.sizeOf(context).width * 0.6,
                          height: MediaQuery.sizeOf(context).height * 0.5,
                          color: FlutterFlowTheme.of(context).primaryText,
                          backgroundColor: Colors.transparent,
                          errorBuilder: (context, error) => SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            height: MediaQuery.sizeOf(context).height * 0.5,
                          ),
                          drawText: false,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Show this QR Code',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                          ),
                      minFontSize: 13.0,
                    ),
                    AutoSizeText(
                      ' when prompted',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                          ),
                      minFontSize: 13.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
