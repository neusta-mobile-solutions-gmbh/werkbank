import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/constraints_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension ViewConstraintsMetadataExtension on UseCaseMetadata {
  ViewConstraints get initialViewConstraints =>
      get<_ViewConstraintsMetadataEntry>()?.initialViewConstraints ??
      ViewConstraints.looseViewLimited;

  ViewConstraints get overviewViewConstraints =>
      get<_ViewConstraintsMetadataEntry>()?.overviewViewConstraints ??
      initialViewConstraints;

  List<ViewConstraintsPreset> get viewConstraintsPresets =>
      (get<_ViewConstraintsMetadataEntry>()?.viewConstraintsPresets ??
              const IList.empty())
          .unlockView;
}

extension ViewConstraintsExtension on ViewConstraintsComposer {
  UseCaseComposer get _c => this as UseCaseComposer;

  void initialConstraints(
    BoxConstraints constraints, {
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) {
    final viewConstraints = ViewConstraints.fromBoxConstraints(
      constraints,
      viewLimitedMaxWidth: viewLimitedMaxWidth,
      viewLimitedMaxHeight: viewLimitedMaxHeight,
    );
    _c
      ..getTransientStateEntry<ConstraintsStateEntry>()
          .setInitialViewConstraints(
            viewConstraints,
          )
      ..setMetadata(
        (_c.getMetadata<_ViewConstraintsMetadataEntry>() ??
                _ViewConstraintsMetadataEntry.initial)
            .copyWith(
              initialViewConstraints: viewConstraints,
            ),
      );
  }

  void initialSize(
    Size size, {
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) => initialConstraints(
    BoxConstraints.tight(size),
    viewLimitedMaxWidth: viewLimitedMaxWidth,
    viewLimitedMaxHeight: viewLimitedMaxHeight,
  );

  void initial({
    double? width,
    double? height,
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) => initialConstraints(
    BoxConstraints.tightFor(width: width, height: height),
    viewLimitedMaxWidth: viewLimitedMaxWidth,
    viewLimitedMaxHeight: viewLimitedMaxHeight,
  );

  void overviewConstraints(
    BoxConstraints constraints, {
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) {
    final viewConstraints = ViewConstraints.fromBoxConstraints(
      constraints,
      viewLimitedMaxWidth: viewLimitedMaxWidth,
      viewLimitedMaxHeight: viewLimitedMaxHeight,
    );
    _c.setMetadata(
      (_c.getMetadata<_ViewConstraintsMetadataEntry>() ??
              _ViewConstraintsMetadataEntry.initial)
          .copyWith(
            overviewViewConstraints: viewConstraints,
          ),
    );
  }

  void overviewSize(
    Size size, {
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) => overviewConstraints(
    BoxConstraints.tight(size),
    viewLimitedMaxWidth: viewLimitedMaxWidth,
    viewLimitedMaxHeight: viewLimitedMaxHeight,
  );

  void overview({
    double? width,
    double? height,
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) => overviewConstraints(
    BoxConstraints.tightFor(width: width, height: height),
    viewLimitedMaxWidth: viewLimitedMaxWidth,
    viewLimitedMaxHeight: viewLimitedMaxHeight,
  );

  void presetConstraints(
    String name,
    BoxConstraints constraints, {
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) {
    final preset = ViewConstraintsPreset(
      name: name,
      viewConstraints: ViewConstraints.fromBoxConstraints(
        constraints,
        viewLimitedMaxWidth: viewLimitedMaxWidth,
        viewLimitedMaxHeight: viewLimitedMaxHeight,
      ),
    );
    _c
      ..getTransientStateEntry<ConstraintsStateEntry>()
          .addViewConstraintsPreset(
            preset,
          )
      ..addSearchCluster(
        SearchCluster(
          semanticDescription: 'Constraints $name',
          entries: [
            FuzzySearchEntry(searchString: name),
          ],
        ),
      );
    final oldMetadata =
        _c.getMetadata<_ViewConstraintsMetadataEntry>() ??
        _ViewConstraintsMetadataEntry.initial;
    _c.setMetadata(
      oldMetadata.copyWith(
        viewConstraintsPresets: oldMetadata.viewConstraintsPresets.add(preset),
      ),
    );
  }

  void presetSize(
    String name,
    Size size, {
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) => presetConstraints(
    name,
    BoxConstraints.tight(size),
    viewLimitedMaxWidth: viewLimitedMaxWidth,
    viewLimitedMaxHeight: viewLimitedMaxHeight,
  );

  void preset(
    String name, {
    double? width,
    double? height,
    bool viewLimitedMaxWidth = true,
    bool viewLimitedMaxHeight = true,
  }) => presetConstraints(
    name,
    BoxConstraints.tightFor(width: width, height: height),
    viewLimitedMaxWidth: viewLimitedMaxWidth,
    viewLimitedMaxHeight: viewLimitedMaxHeight,
  );
}

class _ViewConstraintsMetadataEntry
    extends UseCaseMetadataEntry<_ViewConstraintsMetadataEntry> {
  const _ViewConstraintsMetadataEntry({
    required this.initialViewConstraints,
    required this.viewConstraintsPresets,
    required this.overviewViewConstraints,
  });

  static const initial = _ViewConstraintsMetadataEntry(
    initialViewConstraints: null,
    overviewViewConstraints: null,
    viewConstraintsPresets: IList.empty(),
  );

  final ViewConstraints? initialViewConstraints;
  final ViewConstraints? overviewViewConstraints;
  final IList<ViewConstraintsPreset> viewConstraintsPresets;

  _ViewConstraintsMetadataEntry copyWith({
    ViewConstraints? initialViewConstraints,
    ViewConstraints? overviewViewConstraints,
    IList<ViewConstraintsPreset>? viewConstraintsPresets,
  }) {
    return _ViewConstraintsMetadataEntry(
      initialViewConstraints:
          initialViewConstraints ?? this.initialViewConstraints,
      overviewViewConstraints:
          overviewViewConstraints ?? this.overviewViewConstraints,
      viewConstraintsPresets:
          viewConstraintsPresets ?? this.viewConstraintsPresets,
    );
  }
}
