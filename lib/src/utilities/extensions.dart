extension MatchString on String {
  bool didMatch(String other) => toLowerCase().contains(other.toLowerCase());
}
