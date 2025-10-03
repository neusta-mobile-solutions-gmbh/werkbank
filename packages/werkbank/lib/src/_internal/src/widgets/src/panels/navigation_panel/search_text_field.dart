import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
  });

  @override
  State<SearchTextField> createState() => SearchTextFieldState();
}

class SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _textEditingController;
  SearchQueryController? _searchQueryController;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _searchQueryController?.removeListener(_searchQueryControllerChanged);
    _searchQueryController = WerkbankPersistence.maybeSearchQueryController(
      context,
    );
    _searchQueryController!.addListener(_searchQueryControllerChanged);

    if (!_initialized) {
      _textEditingController = TextEditingController(
        text: _searchQueryController!.query,
      );
      _textEditingController.addListener(_textEditingControllerChanged);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _searchQueryController?.removeListener(_searchQueryControllerChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  void _textEditingControllerChanged() {
    _searchQueryController!.updateSearchQuery(_textEditingController.text);
    setState(() {});
  }

  void _searchQueryControllerChanged() {
    if (_searchQueryController!.query.isEmpty) {
      _textEditingController.clear();
    }
    if (_textEditingController.text != _searchQueryController!.query) {
      _textEditingController.text = _searchQueryController!.query;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WTextField(
      maxLength: SearchQueryController.maxQueryLength,
      hintText: context.sL10n.navigationPanel.search.hint,
      focusNode: _searchQueryController!.focusNode,
      controller: _textEditingController,
      showClearButton: true,
    );
  }
}
