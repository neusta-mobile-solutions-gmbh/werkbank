import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/attributed_string_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/string_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/text_span_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';
import 'package:werkbank/src/addons/src/accessibility/src/accessibility_composition.dart';
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
    void addStringField(String label, String value) {
      if (value.isNotEmpty) {
        fields.add(
          StringSemanticsDataField(
            name: label,
            value: value,
          ),
        );
      }
    }

    void addAttributedStringField(
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

    void addRawStringField(String label, String value) {
      if (value.isNotEmpty) {
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
        addRawStringField(label, value.toString());
      }
    }

    void doubleField(
      String label,
      double? value, {
      double? hiddenValue,
    }) {
      if (value != null && (hiddenValue == null || value != hiddenValue)) {
        addRawStringField(label, value.toString());
      }
    }

    addAttributedStringField('label', data.attributedLabel);
    intField('id', snapshot.id);
    addStringField('identifier', data.identifier);
    intField('platformViewId', data.platformViewId);
    addAttributedStringField(
      'value',
      data.attributedValue,
      textSelection: data.textSelection,
    );
    intField('maxValueLength', data.maxValueLength);
    intField('currentValueLength', data.currentValueLength);

    addAttributedStringField('increasedValue', data.attributedIncreasedValue);
    addAttributedStringField('decreasedValue', data.attributedDecreasedValue);
    addAttributedStringField('hint', data.attributedHint);
    addStringField('tooltip', data.tooltip);
    intField('headingLevel', data.headingLevel, hiddenValue: 0);
    doubleField('elevation', data.elevation, hiddenValue: 0);
    doubleField('thickness', data.thickness, hiddenValue: 0);

    final textDirection = data.textDirection;
    if (textDirection != null) {
      addRawStringField(
        'textDirection',
        switch (textDirection) {
          TextDirection.ltr => 'ltr',
          TextDirection.rtl => 'rtl',
        },
      );
    }
    intField('scrollChildCount', data.scrollChildCount);
    intField('scrollIndex', data.scrollIndex);
    doubleField('scrollPosition', data.scrollPosition);
    doubleField('scrollExtentMax', data.scrollExtentMax);
    doubleField('scrollExtentMin', data.scrollExtentMin);
    doubleField('scrollExtentMin', data.scrollExtentMin);

    if (data.role != SemanticsRole.none) {
      addRawStringField('role', data.role.name);
    }

    addRawStringField(
      'flags',
      [
        for (final flag in SemanticsFlag.values)
          if (data.hasFlag(flag)) flag.name,
      ].join(', '),
    );

    addRawStringField(
      'actions',
      [
        for (final action in SemanticsAction.values)
          if (data.hasAction(action)) action.name,
      ].join(
        ', ',
      ),
    );
    addRawStringField(
      'custom actions',
      [
        for (final customActionId
            in data.customSemanticsActionIds ?? const Iterable<int>.empty())
          CustomSemanticsAction.getAction(customActionId)?.label,
      ].nonNulls.join(
        ', ',
      ),
    );

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
