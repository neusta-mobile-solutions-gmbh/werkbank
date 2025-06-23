import 'package:example_werkbank/src/example_app/pages/fidgets_page.dart';
import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get fidgetsPageUseCase => WerkbankUseCase(
  name: 'Fidgets Page',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.withScaffold(title: 'Fidgets');

  return (context) {
    return const FidgetsPage();
  };
}
