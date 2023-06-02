class LocalMention {
  const LocalMention({required this.text, required this.isMentioned});
  final String text;
  final bool isMentioned;

  @override
  String toString() => 'LocalMention(text: $text, isMentioned: $isMentioned)';
}
