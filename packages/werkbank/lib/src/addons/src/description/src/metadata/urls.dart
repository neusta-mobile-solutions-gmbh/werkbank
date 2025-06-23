import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class _UrlsMetadataEntry extends UseCaseMetadataEntry<_UrlsMetadataEntry> {
  const _UrlsMetadataEntry(this.urls);

  final IList<String> urls;
}

extension UrlsMetadataExtension on UseCaseMetadata {
  List<String> get urls =>
      (get<_UrlsMetadataEntry>()?.urls ?? const IList.empty()).unlockView;
}

extension UrlsComposerExtension on UseCaseComposer {
  void urls(List<String> urls) {
    final validUrls = _validUrls(urls);

    final currentUrls =
        getMetadata<_UrlsMetadataEntry>()?.urls ?? const IList.empty();
    setMetadata(
      _UrlsMetadataEntry(
        currentUrls.addAll(validUrls),
      ),
    );
  }
}

List<String> _validUrls(List<String> urls) {
  final validUrls = <String>[];
  final invalidUrls = <String>[];
  for (final url in urls) {
    if (Uri.tryParse(url) != null) {
      validUrls.add(url);
    } else {
      invalidUrls.add(url);
    }
  }
  if (invalidUrls.isNotEmpty) {
    throw Exception(
      'c.urls([...]) was used with some '
      'invalid URLs: $invalidUrls',
    );
  }

  return validUrls;
}
