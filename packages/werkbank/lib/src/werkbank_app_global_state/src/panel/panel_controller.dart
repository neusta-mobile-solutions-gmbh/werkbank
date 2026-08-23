import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class PanelController extends GlobalStateController
    with PersistedGlobalStateControllerMixin {
  PanelController();

  static const _leftPanelWidthKey = 'leftPanelWidth';
  static const _rightPanelWidthKey = 'rightPanelWidth';
  static const _leftExpandedKey = 'leftExpanded';
  static const _rightExpandedKey = 'rightExpanded';

  late final WPanelController wPanelController = WPanelController(
    initialLeftWidth: 500,
    initialRightWidth: 500,
  );

  @override
  Listenable get jsonChangedListenable => Listenable.merge([
    wPanelController.leftWidth,
    wPanelController.rightWidth,
    wPanelController.leftExpanded,
    wPanelController.rightExpanded,
  ]);

  @override
  String get jsonStoreKey => 'panel';

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json case {
      _leftPanelWidthKey: final double leftWidth,
      _rightPanelWidthKey: final double rightWidth,
      _leftExpandedKey: final bool leftExpanded,
      _rightExpandedKey: final bool rightExpanded,
    }) {
      wPanelController.leftWidth.value = leftWidth;
      wPanelController.rightWidth.value = rightWidth;
      wPanelController.leftExpanded.value = leftExpanded;
      wPanelController.rightExpanded.value = rightExpanded;
    }
  }

  @override
  Object? toJson() {
    return {
      _leftPanelWidthKey: wPanelController.leftWidth.value,
      _rightPanelWidthKey: wPanelController.rightWidth.value,
      _leftExpandedKey: wPanelController.leftExpanded.value,
      _rightExpandedKey: wPanelController.rightExpanded.value,
    };
  }

  @override
  void dispose() {
    wPanelController.dispose();
    super.dispose();
  }
}
