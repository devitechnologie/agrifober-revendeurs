class Helpers {
  static DateTime? _lastBackPressTime;

  static Future<bool> handleDoubleTapExit() async {
    DateTime now = DateTime.now();

    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      return false;
    }

    _lastBackPressTime = null;
    return true;
  }

  /// `tgoGOfl` → `TgoGOfl`. Only the first letter of each word is raised; the
  /// rest is left as typed, so a name's own casing survives.
  static String capitalize(String s) {
    return s
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  /// `7.666,00 MAD` — the Moroccan French format the web app prints
  /// (`toLocaleString("fr-MA")`), so both show the same figure.
  static String formatMad(double amount) => '${formatAmount(amount)} MAD';

  /// `7.666,00` — dot thousands separator, comma decimals, always 2 decimals.
  static String formatAmount(double amount) {
    final negative = amount < 0;
    final cents = (amount.abs() * 100).round();
    final whole = (cents ~/ 100).toString();
    final decimals = (cents % 100).toString().padLeft(2, '0');

    final grouped = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) grouped.write('.');
      grouped.write(whole[i]);
    }
    return '${negative ? '-' : ''}$grouped,$decimals';
  }

  /// `0.222` → `22 %` (French spacing before the sign).
  static String formatPercent(double rate) => '${(rate * 100).round()} %';

  /// `21/09/2026`.
  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// `21/09/2026 à 14:05`, in the device's local time.
  static String formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/${local.year} à $hour:$minute';
  }

  /// `2 lignes` / `1 ligne`.
  static String plural(int count, String singular, [String? pluralForm]) =>
      '$count ${count > 1 ? (pluralForm ?? '${singular}s') : singular}';
}
