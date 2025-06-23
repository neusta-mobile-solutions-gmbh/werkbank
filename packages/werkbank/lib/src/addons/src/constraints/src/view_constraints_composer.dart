import 'package:werkbank/werkbank.dart';

extension ViewConstraintsComposerExtension on UseCaseComposer {
  ViewConstraintsComposer get constraints => ViewConstraintsComposer(this);
}

extension type ViewConstraintsComposer(UseCaseComposer _c) {}
