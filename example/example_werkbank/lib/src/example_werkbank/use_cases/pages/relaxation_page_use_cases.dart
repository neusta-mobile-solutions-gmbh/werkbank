import 'package:example_werkbank/src/example_app/pages/relaxation_page.dart';
import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get relaxationPageUseCase => WerkbankUseCase(
  name: 'Relaxation Page',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.withScaffold(title: 'Relaxation');

  return (context) {
    return const RelaxationPage();
  };
}
