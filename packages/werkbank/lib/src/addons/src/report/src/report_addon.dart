import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/report/report.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_component.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_persistent_controller.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_provider.dart';
import 'package:werkbank/src/persistence/persistence.dart';

/// {@category Configuring Addons}
class ReportAddon extends Addon {
  const ReportAddon({
    this.reports = const {},
    this.showChangelog = true,
    this.showShortcuts = true,
    this.showFeatureIntroductions = true,
  }) : super(id: addonId);

  static const addonId = 'report';

  // Add custom reports here.
  final Set<Report> reports;
  final bool showChangelog;
  final bool showShortcuts;
  final bool showFeatureIntroductions;

  @override
  List<PersistentController> createPersistentControllers() => [
    ReportPersistentController(),
  ];

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      applicationOverlay: [
        ApplicationOverlayLayerEntry(
          id: 'report_provider',
          builder: (context, child) => ReportProvider(
            reports: reports,
            showChangelog: showChangelog,
            showShortcuts: showShortcuts,
            showFeatureIntroductions: showFeatureIntroductions,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  List<HomePageComponent> buildHomePageComponents(BuildContext context) {
    final reportsManager = ReportProvider.of(context);
    return [
      for (final report in reportsManager.reports)
        HomePageComponent(
          sortHint: report.sortHint,
          child: ReportComponent(
            report: report,
          ),
        ),
    ];
  }
}
