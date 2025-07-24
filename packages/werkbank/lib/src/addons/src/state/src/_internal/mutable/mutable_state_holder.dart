import 'package:werkbank/src/addons/src/state/src/value_container.dart';

class MutableStateHolder<T extends Object> extends ValueContainer<T> {
  MutableStateHolder();

  // ignore: use_setters_to_change_properties
  void prepareForBuild(T value) {
    _value = value;
  }

  T? _value;

  @override
  T get value {
    if (_value == null) {
      throw StateError(
        'The value of a state holder can only '
        'be read after the use case has '
        'finished composing. '
        'Have you accidentally accessed a state value directly in the '
        'UseCaseBuilder function instead of its returned WidgetBuilder? '
        'State should only be accessed within the widget tree or in '
        'event handlers.',
      );
    }
    return _value!;
  }
}
