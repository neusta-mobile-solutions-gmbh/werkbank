import 'dart:math';

// Inspired by https://stackoverflow.com/questions/22570638/merging-two-partial-jointly-overdetermined-sets-of-ordering-information
/// Creates an ordering of the union of the elements in [primary] and
/// [secondary],
/// such that the elements in [primary] are kept in the same order
/// (possibly with elements from [secondary] interspersed) and such that the
/// number of inversion with respect to [secondary] is minimized.
List<T> mergeOrderings<T>({
  required List<T> primary,
  required List<T> secondary,
}) {
  final primarySet = primary.toSet();
  final secondarySet = secondary.toSet();
  assert(
    primarySet.length == primary.length,
    'Primary list must not contain duplicates',
  );
  assert(
    secondarySet.length == secondary.length,
    'Secondary list must not contain duplicates',
  );

  final sIndexMap = {for (final (i, e) in secondary.indexed) e: i};
  bool isInverted(T e1, T e2) => sIndexMap[e1]! > sIndexMap[e2]!;

  final a = <List<T>>[];
  var trailing = <T>[];
  for (final p in primary) {
    trailing.add(p);
    if (secondarySet.contains(p)) {
      a.add(trailing);
      trailing = [];
    }
  }
  // Since dart sets are linked hash sets, the order of elements is preserved.
  final b = secondarySet.difference(primarySet).toList();
  final n = a.length;
  final m = b.length;

  final f = List.generate(n, (_) => List<int>.filled(m, 0), growable: false);
  final isANext = List.generate(
    n,
    (_) => List<bool>.filled(m, false),
    growable: false,
  );
  for (var i = 0; i < n; ++i) {
    final ai = a[i];
    for (var j = 0; j < m; ++j) {
      final bj = b[j];
      var takeAInversions = i == 0 ? 0 : f[i - 1][j];
      for (final bk in b.take(j + 1)) {
        if (isInverted(bk, ai.last)) takeAInversions++;
      }
      var takeBInversions = j == 0 ? 0 : f[i][j - 1];
      for (final ak in a.take(i + 1)) {
        if (isInverted(ak.last, bj)) takeBInversions++;
      }
      isANext[i][j] = takeAInversions < takeBInversions;
      f[i][j] = min(takeAInversions, takeBInversions);
    }
  }

  final result = <T>[];
  var i = n - 1;
  var j = m - 1;
  while (i >= 0 || j >= 0) {
    if (j < 0 || (i >= 0 && isANext[i][j])) {
      result.addAll(a[i].reversed);
      i--;
    } else {
      result.add(b[j]);
      j--;
    }
  }
  return result.reversed.toList()..addAll(trailing);
}

extension ListExtension<T> on List<T> {
  /// Moves the element at [oldIndex] to [newIndex].
  void move(int oldIndex, int newIndex) {
    RangeError.checkValidIndex(oldIndex, this, 'from', length);
    RangeError.checkValidIndex(newIndex, this, 'to', length);
    if (oldIndex == newIndex) return;
    final element = this[oldIndex];
    if (oldIndex < newIndex) {
      setRange(oldIndex, newIndex, this, oldIndex + 1);
    } else {
      setRange(newIndex + 1, oldIndex + 1, this, newIndex);
    }
    this[newIndex] = element;
  }
}
