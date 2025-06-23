import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wTabViewUseCase(UseCaseComposer c) {
  c
    ..description(
      'A tab view that can be used to switch between different contents.',
    )
    ..tags([Tags.container])
    ..background.named('T: Background');

  c.constraints
    ..supported(const BoxConstraints(minWidth: 200))
    ..initial(width: 500, height: 500)
    ..overview();

  c.overview
    ..minimumSize(width: 300)
    ..withoutPadding();

  return (context) {
    return const WTabView(
      tabs: [
        WTab(
          title: Text('KNOBS'),
          child: _Content('KNOBS'),
        ),
        WTab(
          title: Text('ADDONS'),
          child: _Content('ADDONS'),
        ),
        WTab(
          title: Text('META'),
          child: _Content('META'),
        ),
      ],
    );
  };
}

class _Content extends StatelessWidget {
  const _Content(this.tab);

  final String tab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        tab,
        style: context.werkbankTextTheme.defaultText.apply(
          color: context.werkbankColorScheme.text,
        ),
      ),
    );
  }
}
