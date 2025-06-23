import 'package:werkbank/src/addons/src/report/src/_internal/report_persistent_data.dart';
import 'package:werkbank/werkbank.dart';

Set<Report> sanitizeReports(Set<Report> reports, ReportPersistentData data) {
  final sanitizedReports = <Report>{};
  for (final report in reports) {
    if (report.display(data)) {
      sanitizedReports.add(report);
    }
  }

  return sanitizedReports;
}
