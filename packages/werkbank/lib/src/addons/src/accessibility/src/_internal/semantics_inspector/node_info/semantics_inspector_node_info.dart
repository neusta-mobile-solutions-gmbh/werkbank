import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/accessibility/accessibility.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/attributed_string_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/link_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/string_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/text_span_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_node_snapshot.dart';
import 'package:werkbank/src/components/components.dart';

class SemanticsInspectorNodeInfo extends StatelessWidget {
  const SemanticsInspectorNodeInfo({super.key, required this.subscription});

  final SemanticsMonitoringSubscription subscription;

  SemanticsNodeSnapshot? _findSnapshotWithId(
    int id,
    Iterable<SemanticsNodeSnapshot> snapshots,
  ) {
    for (final snapshot in snapshots) {
      if (snapshot.id == id) {
        return snapshot;
      }
      final data = _findSnapshotWithId(id, snapshot.children);
      if (data != null) {
        return data;
      }
    }
    return null;
  }

  List<Widget> _buildFields(
    BuildContext context,
    SemanticsNodeSnapshot snapshot,
  ) {
    final data = snapshot.data;
    final fields = <Widget>[];
    void stringField(String label, String value) {
      if (value.isNotEmpty) {
        fields.add(
          StringSemanticsDataField(
            name: label,
            value: value,
          ),
        );
      }
    }

    void attributedStringField(
      String label,
      AttributedString value, {
      TextSelection? textSelection,
    }) {
      if (value.string.isNotEmpty) {
        fields.add(
          AttributedStringSemanticsDataField(
            name: label,
            attributedString: value,
            textSelection: textSelection,
          ),
        );
      }
    }

    void uriField(String label, Uri? uri) {
      if (uri != null) {
        fields.add(
          LinkSemanticsDataField(
            name: label,
            uri: uri,
          ),
        );
      }
    }

    void rawStringField(String label, String? value, {bool condition = true}) {
      if (value != null && value.isNotEmpty && condition) {
        fields.add(
          TextSpanSemanticsDataField(
            name: label,
            value: TextSpan(text: value),
          ),
        );
      }
    }

    void intField(
      String label,
      int? value, {
      int? hiddenValue,
    }) {
      if (value != null && (hiddenValue == null || value != hiddenValue)) {
        rawStringField(label, value.toString());
      }
    }

    void doubleField(
      String label,
      double? value, {
      double? hiddenValue,
    }) {
      if (value != null && (hiddenValue == null || value != hiddenValue)) {
        rawStringField(label, value.toString());
      }
    }

    rawStringField(
      'isMergedIntoParent',
      'true',
      condition: snapshot.isMergedIntoParent,
    );

    rawStringField(
      'mergeAllDescendantsIntoThisNode',
      'true',
      condition: snapshot.mergeAllDescendantsIntoThisNode,
    );

    rawStringField(
      'areUserActionsBlocked',
      'true',
      condition: snapshot.areUserActionsBlocked,
    );

    attributedStringField('label', data.attributedLabel);
    intField('headingLevel', data.headingLevel, hiddenValue: 0);
    rawStringField(
      'role',
      data.role.name,
      condition: data.role != SemanticsRole.none,
    );
    attributedStringField(
      'value',
      data.attributedValue,
      textSelection: data.textSelection,
    );
    intField('maxValueLength', data.maxValueLength);
    intField('currentValueLength', data.currentValueLength);
    attributedStringField('increasedValue', data.attributedIncreasedValue);
    attributedStringField('decreasedValue', data.attributedDecreasedValue);
    rawStringField(
      'inputType',
      data.inputType.name,
      condition: data.inputType != SemanticsInputType.none,
    );
    rawStringField(
      'validationResult',
      data.validationResult.name,
      condition: data.validationResult != SemanticsValidationResult.none,
    );
    uriField('linkUrl', data.linkUrl);
    stringField('tooltip', data.tooltip);
    attributedStringField('hint', data.attributedHint);
    intField('scrollChildCount', data.scrollChildCount);
    intField('scrollIndex', data.scrollIndex);
    doubleField('scrollPosition', data.scrollPosition);
    doubleField('scrollExtentMax', data.scrollExtentMax);
    doubleField('scrollExtentMin', data.scrollExtentMin);
    doubleField('scrollExtentMin', data.scrollExtentMin);

    rawStringField(
      'flags',
      data.flagsCollection.toStrings().join(', '),
    );

    rawStringField(
      'actions',
      [
        for (final action in SemanticsAction.values)
          if (data.hasAction(action)) action.name,
      ].join(', '),
    );
    rawStringField(
      'custom actions',
      [
        for (final customActionId
            in data.customSemanticsActionIds ?? const Iterable<int>.empty())
          CustomSemanticsAction.getAction(customActionId)?.label,
      ].nonNulls.join(', '),
    );

    intField('id', snapshot.id);
    stringField('identifier', data.identifier);
    intField('platformViewId', data.platformViewId);
    intField('indexInParent', snapshot.indexInParent);
    rawStringField('controlsNodes', data.controlsNodes?.join(', '));
    rawStringField('textDirection', data.textDirection?.name);
    rawStringField('locale', data.locale?.toLanguageTag());
    rawStringField('tags', data.tags?.map((tag) => tag.name).join(', '));

    return fields;
  }

  @override
  Widget build(BuildContext context) {
    final semanticsInspectorController = InspectControlSection.access
        .compositionOf(context)
        .accessibility
        .semanticsInspectorController;
    return WControlItem(
      title: Text(
        context.sL10n.addons.accessibility.controls.activeSemanticsNode,
      ),
      layout: ControlItemLayout.spacious,
      control: SizedBox(
        height: 300,
        width: double.infinity,
        child: WFieldBox(
          contentPadding: EdgeInsets.zero,
          child: ValueListenableBuilder(
            valueListenable: semanticsInspectorController.activeSemanticsNodeId,
            builder: (context, activeNodeId, child) {
              return ValueListenableBuilder(
                valueListenable: subscription.nodes,
                builder: (context, nodes, child) {
                  final data = activeNodeId == null
                      ? null
                      : _findSnapshotWithId(
                          activeNodeId,
                          nodes ?? const Iterable.empty(),
                        );
                  if (data == null) {
                    return const SizedBox.expand();
                  }
                  final fields = _buildFields(context, data);
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: fields.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 4),
                    itemBuilder: (context, index) => fields[index],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
