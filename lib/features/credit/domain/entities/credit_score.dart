import 'package:equatable/equatable.dart';

/// "Score crédit": every purchase adds 100 % of its amount to [score], the
/// revendeur's credit ceiling. [available] is what he can still ask to pay on
/// credit on a new commande: the score minus what he owes ([outstanding]) and
/// what he already asked for on orders not yet delivered ([pending]).
class CreditScore extends Equatable {
  final double score;
  final double outstanding;
  final double pending;
  final double available;

  const CreditScore({
    required this.score,
    required this.outstanding,
    required this.pending,
    required this.available,
  });

  static const empty = CreditScore(
    score: 0,
    outstanding: 0,
    pending: 0,
    available: 0,
  );

  /// Part of the score already used (owed + requested).
  double get used => outstanding + pending;

  /// Share of the score already used, 0…1 (0 without a score).
  double get usedRatio => score <= 0 ? 0 : (used / score).clamp(0, 1);

  @override
  List<Object?> get props => [score, outstanding, pending, available];
}
