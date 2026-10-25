/// API dates are `YYYY-MM-DD` (documents) or ISO 8601 (orders). A missing or
/// malformed value becomes the epoch rather than a null, so entities never
/// carry a nullable date the UI would have to guard.
DateTime parseApiDate(String value) =>
    DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);

/// For dates that are legitimately optional (an échéance, an end date).
DateTime? parseOptionalApiDate(String value) =>
    value.isEmpty ? null : DateTime.tryParse(value);
