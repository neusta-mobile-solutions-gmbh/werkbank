import 'package:flutter/material.dart';

abstract class PersistentController extends ChangeNotifier {
  void tryLoadFromJson(Object? json);

  Object? toJson();
}
