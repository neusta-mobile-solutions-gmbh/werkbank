import 'package:example_werkbank/src/example_app/components/relaxation_card.dart';
import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get relaxationCardUseCase => WerkbankUseCase(
  name: 'RelaxationCard',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.overview.minimumSize(width: 350, height: 380);

  final titleKnob = c.knobs.string(
    'Title',
    initialValue: 'Title',
  );

  final descriptionKnob = c.knobs.stringMultiLine(
    'Description',
    initialValue:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam '
        'nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam '
        'erat, sed diam voluptua.',
  );

  return (context) {
    return RelaxationCard(
      image: const Image(
        image: AssetImage('assets/pexels-lkloeppel-2416585.jpg'),
      ),
      title: Text(titleKnob.value),
      description: Text(
        descriptionKnob.value,
      ),
    );
  };
}
