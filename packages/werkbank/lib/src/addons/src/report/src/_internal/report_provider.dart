import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_persistent_controller.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/reports/feature_introductions.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/reports/report_change_log.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/sanitize_reports.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/shortcuts_component.dart';
import 'package:werkbank/src/addons/src/report/src/report.dart';
import 'package:werkbank/src/utils/utils.dart';

class ReportsManager {
  ReportsManager({
    required this.reports,
    required this.acceptReport,
  });

  final Set<Report> reports;
  final ValueChanged<Report> acceptReport;
}

class ReportProvider extends StatefulWidget {
  const ReportProvider({
    required this.reports,
    required this.showChangelog,
    required this.showShortcuts,
    required this.showFeatureIntroductions,
    required this.child,
    super.key,
  });

  static ReportsManager of(BuildContext context) {
    final reports = context
        .dependOnInheritedWidgetOfExactType<_InheritedReports>()!
        .reports
        .toSet();
    return ReportsManager(
      reports: reports,
      acceptReport: (report) {
        ApplicationOverlayLayerEntry.access
            .persistentControllerOf<ReportPersistentController>(context)
            .accept(report);
      },
    );
  }

  final Set<Report> reports;
  final bool showChangelog;
  final bool showShortcuts;
  final bool showFeatureIntroductions;

  final Widget child;

  @override
  State<ReportProvider> createState() => _ReportProviderState();
}

class _ReportProviderState extends State<ReportProvider> {
  late final ReportPersistentController _controller;
  bool initialized = false;
  final Set<Report> _reportCandidates = {};
  late Set<Report> _reports;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      _controller = ApplicationOverlayLayerEntry.access
          .persistentControllerOf<ReportPersistentController>(context);

      _collectCandidates();
      _updateReports();
      _controller.addListener(_updateReports);
      initialized = true;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateReports);
    super.dispose();
  }

  void _collectCandidates() {
    if (widget.showShortcuts) {
      _reportCandidates.add(
        const PermanentReport(
          id: 'shortcuts',
          title: 'Shortcuts',
          sortHint: SortHint(2000),
          collapsible: true,
          content: ShortcutsComponent(),
        ),
      );
    }
    if (widget.showChangelog) {
      _reportCandidates.addAll(changelogReports);
    }
    if (widget.showFeatureIntroductions) {
      _reportCandidates.addAll(featureIntroductions);
    }

    _reportCandidates.addAll(widget.reports);
  }

  void _updateReports() {
    _reports = sanitizeReports(_reportCandidates, _controller.persistentData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedReports(
      reports: _reports,
      child: widget.child,
    );
  }
}

class _InheritedReports extends InheritedWidget {
  const _InheritedReports({
    required this.reports,
    required super.child,
  });

  final Set<Report> reports;

  @override
  bool updateShouldNotify(covariant _InheritedReports oldWidget) {
    return reports != oldWidget.reports;
  }
}
