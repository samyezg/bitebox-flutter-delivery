import 'package:flutter/foundation.dart';

class RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}
