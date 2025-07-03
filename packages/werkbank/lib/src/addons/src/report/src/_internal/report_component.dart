import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_provider.dart';
import 'package:werkbank/werkbank.dart';

class ReportComponent extends StatelessWidget {
  const ReportComponent({
    required this.report,
    super.key,
  });

  final Report report;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DefaultTextStyle.merge(
                overflow: TextOverflow.ellipsis,
                style: context.werkbankTextTheme.headline.copyWith(
                  color: context.werkbankColorScheme.text,
                ),
                child: Text(
                  report.title,
                ),
              ),
            ),
            if (report is! PermanentReport)
              WIconButton(
                onPressed: () {
                  ReportProvider.of(context).acceptReport(report);
                },
                padding: const EdgeInsets.all(6),
                icon: const Icon(WerkbankIcons.x),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Flexible(
          child: Builder(
            builder: (context) {
              Widget widget = WBorderedBox(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                backgroundColor: context.werkbankColorScheme.field,
                child: Padding(
                  padding: report.preview
                      ? const EdgeInsets.fromLTRB(8, 8, 8, 48)
                      : const EdgeInsets.all(8),
                  child: report.content,
                ),
              );

              if (report.preview) {
                widget = WPreviewHeight(child: widget);
              }

              return widget;
            },
          ),
        ),
      ],
    );
  }
}
