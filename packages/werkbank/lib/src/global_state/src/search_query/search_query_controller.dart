import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class SearchQueryController extends GlobalStateController {
  SearchQueryController() {
    textEditingController.addListener(notifyListeners);
  }

  // When the query hits around 50 characters, the bitap algorithm
  // leads to weird results. So we limit the query length.
  static const int maxQueryLength = 42;

  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  String get query => textEditingController.text;

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (!isWarmStart) {
      return;
    }
    if (json is String) {
      textEditingController.text = json;
    }
    notifyListeners();
  }

  @override
  Object? toJson() {
    return textEditingController.text;
  }

  @override
  void dispose() {
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
