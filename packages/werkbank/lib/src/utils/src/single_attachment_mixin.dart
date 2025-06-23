import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A mixin that allows to attach a single entity of type [T] to the class.
///
/// Since in Flutter dispose and detach methods are often called after
/// initialization or attach methods, the simple approach of only allowing
/// a new entity to be attached after the previous one was detached is not
/// always sufficient.
/// Doing it anyway, would cause errors to be thrown, when moving the
/// attachment from one entity to another, because another entity is
/// already attached.
/// Omitting the checks may work in practice, but if user attaches multiple
/// entities, this will cause unexpected behavior, which is very hard to
/// debug because no assertions are thrown.
///
/// Instead it has to be allowed to attach a new entity before the previous
/// one was detached, and only at the end of the frame the requirement of
/// there only being one entity attached at a time is enforced.
///
/// Examples of classes that could have used this mixin are
/// - [LayerLink]
/// - [OverlayPortalController]
/// - [MenuController]
/// - Many more controllers that can only be attached to one widget
///   (or rather one element/state).
mixin SingleAttachmentMixin<T extends Object> {
  /// The attached [entity] or `null` if this there is no entity attached.
  @protected
  T? get entity => _entity;
  T? _entity;

  /// Attach the [entity] to the class.
  @protected
  void attach(T entity) {
    assert(
      _entity != entity,
      '$entity is already attached.',
    );
    // ignore: prefer_asserts_with_message
    assert(() {
      _debugLastAttachStackTrace = StackTrace.current;
      if (_entity != null) {
        (_debugPreviousEntities ??= {}).add(_entity!);
        _debugScheduleCleanUpCheck();
      }
      return true;
    }());
    final oldEntity = _entity;
    _entity = entity;
    onAttachmentChanged(oldEntity, entity);
  }

  /// Detach the [entity] from the class.
  @protected
  void detach(T entity) {
    if (_entity == entity) {
      final oldEntity = _entity;
      _entity = null;
      onAttachmentChanged(oldEntity, null);
    } else {
      assert(
        _debugPreviousEntities?.remove(entity) ?? false,
        '$entity is not attached.',
      );
    }
  }

  /// Called when the attached [entity] changes.
  @protected
  void onAttachmentChanged(T? oldEntity, T? newEntity) {}

  /// Stores the previous entities that were replaced by the current
  /// [_entity] in the current frame.
  ///
  /// These entities need to unregister from this class
  /// by the end of the current frame.
  Set<T>? _debugPreviousEntities;
  bool _debugCleanUpCheckScheduled = false;
  late StackTrace _debugLastAttachStackTrace;

  /// Schedules the check as post frame callback to make sure the
  /// [_debugPreviousEntities] is empty.
  void _debugScheduleCleanUpCheck() {
    assert(
      () {
        if (_debugCleanUpCheckScheduled) {
          return true;
        }
        _debugCleanUpCheckScheduled = true;
        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            _debugCleanUpCheckScheduled = false;
            if (_debugPreviousEntities!.isNotEmpty) {
              Error.throwWithStackTrace(
                AssertionError(
                  'Cannot attach multiple instances. '
                  '(The following stack trace is that of the last attach call, '
                  'which only turned out to be illegal later because the '
                  'previously attached entity was not detached by '
                  'the end of the frame.)',
                ),
                _debugLastAttachStackTrace,
              );
            }
          },
          debugLabel: 'SingleAttachmentMixin.entitiesCleanUpCheck',
        );
        return true;
      }(),
      '',
    );
  }
}
