import 'package:flutter/cupertino.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WerkbankComponent get textAreaComponent => WerkbankComponent(
  name: 'WTextArea',
  builder: (c) {
    c
      ..description(
        'A component used do display some static text.',
      )
      ..tags([Tags.display])
      ..constraints.initial(width: 500);
  },
  useCases: [
    WerkbankUseCase(
      name: 'WTextArea',
      builder: wTextAreaUseCase,
    ),
    WerkbankUseCase(
      name: 'WTextAreaTextSpan',
      builder: wTextAreaTextSpanUseCase,
    ),
  ],
);

//ignore_for_file: lines_longer_than_80_chars
WidgetBuilder wTextAreaUseCase(UseCaseComposer c) {
  c.constraints
    ..initial(width: 300)
    ..overview();
  c.overview.minimumSize(width: 300);

  final contentText = c.knobs.stringMultiLine(
    'Content Text',
    initialValue:
        'This is a sample text for the text area. It demonstrates how the component displays text. You can edit this text to see how the widget responds to changes.',
  );

  return (context) {
    return WTextArea(
      text: contentText.value,
    );
  };
}

WidgetBuilder wTextAreaTextSpanUseCase(UseCaseComposer c) {
  c.constraints
    ..initial(width: 300)
    ..overview();
  c.overview.minimumSize(width: 300);
  final textSpanBold = c.knobs.stringMultiLine(
    'Text Span Bold',
    initialValue: 'This is the bold part of the text.',
  );

  final textSpanNormal = c.knobs.stringMultiLine(
    'Text Span Normal',
    initialValue:
        ' This is the normal part of the text. It continues the example',
  );
  return (context) {
    return WTextArea.textSpan(
      textSpan: TextSpan(
        children: [
          TextSpan(
            text: textSpanBold.value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: textSpanNormal.value,
          ),
        ],
      ),
    );
  };
}
