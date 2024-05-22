import 'package:flutter/material.dart';

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
