import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/form_field_controller.dart';
import './custom_choice_chips_widget.dart' show CustomChoiceChipsWidget;

class CustomChoiceChipsModel extends FlutterFlowModel<CustomChoiceChipsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;

  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;

  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
