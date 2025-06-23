import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wOverviewTileUseChase(UseCaseComposer c) {
  c
    ..description(
      'A tile which shows a use case in the overview.',
    )
    ..background.named('T: Background')
    ..constraints.initial(width: 200, height: 250)
    ..overview.minimumSize(width: 200, height: 250);

  final path = c.knobs.string(
    'Path',
    initialValue: 'My Folder/My Component/My UseCase',
  );
  final hasThumbnail = c.knobs.boolean('Has Thumbnail', initialValue: true);

  return (context) {
    return WOverviewTile(
      onPressed: () {
        UseCase.dispatchTextNotification(context, 'onPressed');
      },
      nameSegments: path.value.split('/'),
      thumbnail: hasThumbnail.value
          ? const ColoredBox(
              color: Colors.red,
            )
          : null,
    );
  };
}
