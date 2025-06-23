import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wProjectInfoAreaUseCase(UseCaseComposer c) {
  c.overview.minimumSize(width: 350);
  final showLogo = c.knobs.boolean(
    'Show Logo',
    initialValue: true,
  );
  final showLastUpdated = c.knobs.boolean(
    'Show Last Updated',
    initialValue: true,
  );
  final showTrailing = c.knobs.boolean(
    'Show Trailing',
    initialValue: true,
  );

  return (context) {
    // TODO(lzuttermeister): Replace Padding with appearance
    return Padding(
      padding: const EdgeInsets.all(24),
      child: WProjectInfoArea(
        onTap: () {
          UseCase.dispatchTextNotification(
            context,
            'Tapped',
          );
        },
        logo: showLogo.value
            ? const ColoredBox(
                color: Colors.red,
              )
            : null,
        title: const Text('Some Title'),
        lastUpdated: showLastUpdated.value ? DateTime.now() : null,
        trailing: showTrailing.value
            ? const Icon(
                Icons.question_mark,
                color: Colors.red,
              )
            : null,
      ),
    );
  };
}
