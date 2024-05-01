import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'package:esof/pages/checkout/checkout_widget.dart';
import 'package:provider/provider.dart';

List<String> concatDescriptions(
  BuildContext context,
  String meat,
  String fish,
  String vegetarian,
) {
  List<String> options = [];
  options.add("Meat - " + meat);
  options.add("Fish - " + fish);
  options.add("Vegetarian - " + vegetarian);
  return options;
}
