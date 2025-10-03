import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_data.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/utils/utils.dart';

// Not sealed because you may want to add your own report types.
abstract class Report {
  const Report({
    required this.id,
    required this.title,
    required this.content,
    required this.sortHint,
    required this.collapsible,
  });

  final String id;

  final String title;
  final Widget content;

  final SortHint sortHint;

  final bool collapsible;

  bool display(ReportData data);
}

class PermanentReport extends Report {
  const PermanentReport({
    required super.id,
    required super.title,
    required super.content,
    super.sortHint = SortHint.central,
    super.collapsible = false,
  });

  factory PermanentReport.markdown({
    required String id,
    required String title,
    required String markdown,
    SortHint sortHint = SortHint.central,
  }) {
    return PermanentReport(
      id: id,
      title: title,
      content: WMarkdown(data: markdown),
      sortHint: sortHint,
    );
  }

  @override
  bool display(ReportData data) {
    return true;
  }
}

class AcceptableReport extends Report {
  const AcceptableReport({
    required super.id,
    required super.title,
    required super.content,
    super.sortHint = SortHint.central,
    super.collapsible = false,
  });

  factory AcceptableReport.markdown({
    required String id,
    required String title,
    required String markdown,
    SortHint sortHint = SortHint.central,
  }) {
    return AcceptableReport(
      id: id,
      title: title,
      content: WMarkdown(data: markdown),
      sortHint: sortHint,
    );
  }

  @override
  bool display(ReportData data) {
    final entry = data.entries[id];
    return !(entry?.accepted ?? false);
  }
}

class NewContentReport extends Report {
  const NewContentReport({
    required super.id,
    required super.title,
    required super.content,
    super.sortHint = SortHint.central,
    required this.publishDate,
    super.collapsible = false,
  });

  factory NewContentReport.markdown({
    required String id,
    required String title,
    required DateTime publishDate,
    required String markdown,
    SortHint sortHint = SortHint.central,
  }) {
    return NewContentReport(
      id: id,
      title: title,
      content: WMarkdown(data: markdown),
      sortHint: sortHint,
      publishDate: publishDate,
    );
  }

  final DateTime publishDate;

  @override
  bool display(ReportData data) {
    final entry = data.entries[id];
    final notAcceptedYet = !(entry?.accepted ?? false);
    final wasAddedRecently = data.firstTimeReportAddonWasExecuted.isBefore(
      publishDate,
    );
    if (notAcceptedYet && wasAddedRecently) {
      return true;
    }

    return false;
  }
}
