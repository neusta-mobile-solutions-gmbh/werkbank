import 'package:web/web.dart';

void fixWeb() {
  window.document.body?.onContextMenu.listen((event) => event.preventDefault());
}
