import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/package_copies/dropdown_button2/dropdown_button2.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

/// A dropdown button with a custom design.
///
/// {@category Werkbank Components}
class WDropdown<T> extends StatelessWidget {
  const WDropdown({
    required this.items,
    required this.value,
    this.onChanged,
    super.key,
  });

  /// The value of the dropdown button.
  final T value;

  /// The dropdown items to be displayed.
  final List<WDropdownMenuItem<T>> items;

  /// Called when the user selects an item.
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    return WTempDisabler(
      enabled: onChanged != null,
      child: DropdownButton2<T>(
        value: value ?? items.first.value,
        items: items.map((item) => item._toDropdownMenuItem(context)).toList(),
        isExpanded: true,
        underline: const SizedBox(),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: context.werkbankColorScheme.field,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: context.werkbankColorScheme.background,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          overlayColor: WidgetStatePropertyAll(
            context.werkbankColorScheme.backgroundActive.withValues(
              alpha: 0.1,
            ),
          ),
        ),
        iconStyleData: IconStyleData(
          iconEnabledColor: context.werkbankColorScheme.fieldContent,
          icon: const Icon(
            WerkbankIcons.caretDown,
            size: 16,
          ),
        ),
        onChanged: (value) {
          onChanged?.call(value as T);
        },
      ),
    );
  }
}

/// A dropdown menu item for [WDropdown].
/// It is used to create a dropdown menu item with a custom design.
class WDropdownMenuItem<T> {
  /// Creates a [WDropdownMenuItem].
  const WDropdownMenuItem({
    required this.child,
    required this.value,
  });

  final T value;
  final Widget child;

  DropdownMenuItem<T> _toDropdownMenuItem(BuildContext context) {
    return DropdownMenuItem<T>(
      value: value,
      child: DefaultTextStyle.merge(
        style: context.werkbankTextTheme.input.copyWith(
          overflow: TextOverflow.ellipsis,
          color: context.werkbankColorScheme.fieldContent,
        ),
        child: child,
      ),
    );
  }
}
