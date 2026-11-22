import 'dart:async';

import 'package:flutter/foundation.dart';

/// Lets GoRouter re-run its redirect whenever a stream (the session) emits.
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
