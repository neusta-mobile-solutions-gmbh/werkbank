import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/werkbank_app_global_state/werkbank_app_global_state.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final searchQueryController = GlobalStateManager.of(
      context,
    ).werkbankApp.searchQuery;
    return WTextField(
      maxLength: SearchQueryController.maxQueryLength,
      hintText: context.sL10n.navigationPanel.search.hint,
      focusNode: searchQueryController.focusNode,
      controller: searchQueryController.textEditingController,
      showClearButton: true,
    );
  }
}
