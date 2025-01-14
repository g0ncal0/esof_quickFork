import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'checkout_widget.dart' show CheckoutWidget;

class CheckoutModel extends FlutterFlowModel<CheckoutWidget> {
  ///  Local state fields for this page.

  bool fullMeal = true;

  int? price = 295;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  // Stores action output result for [Firestore Query - Query a collection] action in Checkout widget.
  WeekelyMealsRecord? mealInfo;

  // Stores action output result for [Custom Action - concatDescriptions] action in Checkout widget.
  List<String>? descriptions;

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;

  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;

  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController;

  // Stores action output result for [Stripe Payment] action in Button widget.
  String? paymentId;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Additional helper methods.
  String? get radioButtonValue => radioButtonValueController?.value;
}
