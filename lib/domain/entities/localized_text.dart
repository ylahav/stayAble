class LocalizedText {
  const LocalizedText({required this.en, required this.he});

  final String en;
  final String he;

  String resolve(String languageCode) =>
      languageCode == 'he' ? he : en;
}
