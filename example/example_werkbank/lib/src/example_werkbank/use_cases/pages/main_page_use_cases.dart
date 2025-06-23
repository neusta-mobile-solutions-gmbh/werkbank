import 'package:example_werkbank/src/example_app/pages/main_page.dart';
import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get mainPageUseCase => WerkbankUseCase(
  name: 'Main Page',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  return (context) {
    return const MainPage();
  };
}
