import 'package:flutter/foundation.dart';

class PlatformUtils {
  /// True only on a native iOS build. The [kIsWeb] guard is required because
  /// [defaultTargetPlatform] also reports iOS for Safari on iPhone/iPad.
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
}
