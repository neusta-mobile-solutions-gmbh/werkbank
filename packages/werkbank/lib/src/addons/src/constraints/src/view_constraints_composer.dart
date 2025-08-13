import 'package:werkbank/src/use_case/use_case.dart';

extension ViewConstraintsComposerExtension on UseCaseComposer {
  ViewConstraintsComposer get constraints => ViewConstraintsComposer(this);
}

extension type ViewConstraintsComposer(UseCaseComposer _c) {}
