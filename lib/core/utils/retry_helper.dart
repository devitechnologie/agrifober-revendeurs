class RetryHelper {
  static Duration? defaultRetry(int retryCount, Object error) {
    if (retryCount >= 3) return null;

    return Duration(milliseconds: 800 * (1 << retryCount));
  }
}
