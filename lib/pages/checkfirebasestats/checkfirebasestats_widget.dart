import 'dart:ffi';

import 'package:flutter/scheduler.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/custom_code/actions/index.dart' as actions;

import 'checkfirebasestats_model.dart';
export 'checkfirebasestats_model.dart';

class CheckFirebaseStatsWidget extends StatefulWidget {
  const CheckFirebaseStatsWidget({
    super.key,
    String? outputTest,
    required this.mealID, // Add a required parameter for mealID
  }) : this.outputTest = outputTest ?? '0';
  final String? mealID;
  final String outputTest;

  @override
  State<CheckFirebaseStatsWidget> createState() => _CheckFirebaseStatsState();
}

class _CheckFirebaseStatsState extends State<CheckFirebaseStatsWidget> {
  late CheckFirebaseStatsModel _model;
  late Map<String, dynamic> boughtItems;
  late AppStateNotifier _appStateNotifier;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckFirebaseStatsModel());
    _appStateNotifier = AppStateNotifier.instance;
    boughtItems = {}; // Initialize boughtItems here

    // On page load action.
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      // mealInfoFirestoreQuery
      _model.mealInfo = await queryWeekelyMealsRecordOnce(
        queryBuilder: (weekelyMealsRecord) =>
            weekelyMealsRecord.where(
              'weekdayMeal',
              isEqualTo: widget.mealID,
            ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      _model.descriptions = actions.concatDescriptions(
        context,
        _model.mealInfo!.descriptionMeat,
        _model.mealInfo!.descriptionFish,
        _model.mealInfo!.descriptionVegetarian,
      );

      // Fetch bought items after retrieving mealInfo
      fetchBoughtItemsForToday();
    });
  }

  Future<void> fetchBoughtItemsForToday() async {
    // Query Firestore to get the daily statistics for the specified mealId
    QuerySnapshot statDocSnapshot = await FirebaseFirestore.instance
        .collection("WeekelyMeals")
        .where("weekdayMeal", isEqualTo: widget.mealID)
        .get();

    // Check if the document exists
    if (statDocSnapshot.docs.isNotEmpty) {
      // Get the document data
      Map<String, dynamic>? data = statDocSnapshot.docs.first.data() as Map<
          String,
          dynamic>?;
      //   print("Data: $data");

      // Update boughtItems state
      if (data != null) {
        setState(() {
          boughtItems = {
            'boughtFish': data['boughtFish'] ?? 0,
            'boughtMeat': data['boughtMeat'] ?? 0,
            'boughtVegetarian': data['boughtVegetarian'] ?? 0,
            'descriptionFish': data['descriptionFish'] ?? '',
            'descriptionMeat': data['descriptionMeat'] ?? '',
            'descriptionVegetarian': data['descriptionVegetarian'] ?? '',
          };
        });
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Color(0xFFf2cece)
          : Color(0xff2c2a2a),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E1F1F),
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Meal Stats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fish meal: ${boughtItems['descriptionFish'] ?? 0}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Meat meal: ${boughtItems['descriptionMeat'] ?? 0}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Vegetarian meal: ${boughtItems['descriptionVegetarian'] ?? 0}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar('Fish', boughtItems['boughtFish'] ?? 0),
                  _buildBar('Meat', boughtItems['boughtMeat'] ?? 0),
                  _buildBar('Vegetarian', boughtItems['boughtVegetarian'] ?? 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, int value) {
    double total = ((boughtItems['boughtFish'] ?? 0) +
        (boughtItems['boughtMeat'] ?? 0) +
        (boughtItems['boughtVegetarian'] ?? 0))
        .toDouble();

    double percentage;
    if (total != 0) {
      double fishPercentage = (boughtItems['boughtFish'] ?? 0) * 100.0 / total;
      double meatPercentage = (boughtItems['boughtMeat'] ?? 0) * 100.0 / total;
      double vegetarianPercentage =
          (boughtItems['boughtVegetarian'] ?? 0) * 100.0 / total;

      switch (label) {
        case 'Fish':
          percentage = fishPercentage;
          break;
        case 'Meat':
          percentage = meatPercentage;
          break;
        case 'Vegetarian':
          percentage = vegetarianPercentage;
          break;
        default:
          percentage = 0.0;
      }
    } else {
      percentage = 0.0;
    }

    return Transform.translate(
      offset: Offset(0.0, 1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.0), // Adjust the padding as needed
            child: Text(
              '${value}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            width: 50,
            height: percentage * 5,
            color: Colors.orange,
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(0.0, -5.0), // Move the percentages text up by 5 units
              child: Text(
                '${percentage.toInt()}%',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Transform.translate(
            offset: Offset(0.0, 5.0),
            child: Text(label),
          ),
        ],
      ),
    );
  }

}