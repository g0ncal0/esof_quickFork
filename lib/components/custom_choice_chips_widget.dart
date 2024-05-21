import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_choice_chips.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/form_field_controller.dart';
import './custom_choice_chips_model.dart';

export './custom_choice_chips_model.dart';

class CustomChoiceChipsWidget extends StatefulWidget {
  const CustomChoiceChipsWidget({super.key});

  @override
  State<CustomChoiceChipsWidget> createState() =>
      _CustomChoiceChipsWidgetState();
}

class _CustomChoiceChipsWidgetState extends State<CustomChoiceChipsWidget> {
  late CustomChoiceChipsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomChoiceChipsModel());
  }

  bool _dispose = false;

  @override
  void dispose() {
    _model.maybeDispose();
    _dispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: FlutterFlowChoiceChips(
        options: const [
          ChipData('Full Meal', Icons.attach_money_outlined),
          ChipData('Only Main Dish', Icons.attach_money_sharp)
        ],
        onChanged: (val) =>
            setState(() => _model.choiceChipsValue = val?.firstOrNull),
        selectedChipStyle: ChipStyle(
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
              ),
          iconColor: FlutterFlowTheme.of(context).primaryText,
          iconSize: 18.0,
          elevation: 4.0,
          borderRadius: BorderRadius.circular(16.0),
        ),
        unselectedChipStyle: ChipStyle(
          backgroundColor: const Color(0xFF4F3B3B),
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).primaryBackground,
                letterSpacing: 0.0,
              ),
          iconColor: FlutterFlowTheme.of(context).primaryBackground,
          iconSize: 18.0,
          elevation: 0.0,
          borderRadius: BorderRadius.circular(16.0),
        ),
        chipSpacing: 12.0,
        rowSpacing: 12.0,
        multiselect: false,
        initialized: _model.choiceChipsValue != null,
        alignment: WrapAlignment.start,
        controller: _model.choiceChipsValueController ??=
            FormFieldController<List<String>>(
          ['Full Meal'],
        ),
        wrapped: true,
      ),
    );
  }
}
