import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WerkbankComponent get wOverviewTileUseCaseComponent => WerkbankComponent(
  name: 'WOverviewTile',
  builder: (c) {
    c
      ..description(
        'A tile which shows a use case in the overview.',
      )
      ..background.named('T: Background')
      ..constraints.initial(width: 200, height: 264)
      ..overview.minimumSize(width: 200, height: 264);
  },
  useCases: [
    WerkbankUseCase(
      name: 'Single Thumbnail',
      builder: wOverviewTileUseChase,
    ),
    WerkbankUseCase(
      name: 'Multiple Thumbnails',
      builder: wOverviewTileMultiUseChase,
    ),
  ],
);

WidgetBuilder wOverviewTileUseChase(UseCaseComposer c) {
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

WidgetBuilder wOverviewTileMultiUseChase(UseCaseComposer c) {
  final path = c.knobs.string(
    'Path',
    initialValue: 'My Folder/My Component/My Component',
  );
  final thumbnailCount = c.knobs.intSlider(
    'Thumbnail Count',
    initialValue: 3,
    max: 100,
  );

  return (context) {
    return WOverviewTile.multi(
      onPressed: () {
        UseCase.dispatchTextNotification(context, 'onPressed');
      },
      nameSegments: path.value.split('/'),
      thumbnailBuilders: [
        for (var i = 0; i < thumbnailCount.value; i++)
          if (i != 3)
            (context) => ColoredBox(
              color: Colors.primaries[i % Colors.primaries.length],
            )
          else
            null,
      ],
    );
  };
}
