/// Returns the appropriate plural form based on [count].
/// * [zero]  – text for `0`
/// * [one]   – text for `1`
/// * [many]  – text for `2+`
String plural({
  required int count,
  required String zero,
  required String one,
  required String many,
}) {
  if (count == 0) return zero;
  if (count == 1) return one;
  return many;
}

/// Returns a gender-specific string.
/// * [isMale] chooses between [male] / [female]
String gender({
  required bool isMale,
  required String male,
  required String female,
}) =>
    isMale ? male : female;
