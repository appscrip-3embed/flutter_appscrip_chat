extension MatchString on String {
  bool didMatch(String other) => toLowerCase() == other.toLowerCase();
}
