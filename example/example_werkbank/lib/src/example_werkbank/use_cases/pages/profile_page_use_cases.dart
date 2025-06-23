import 'package:example_werkbank/src/example_app/pages/profile_page.dart';
import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get profilePageUseCase => WerkbankUseCase(
  name: 'Profile Page',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.withScaffold(title: 'Profile');

  return (context) {
    return const ProfilePage();
  };
}
