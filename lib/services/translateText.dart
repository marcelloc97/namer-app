import 'package:english_words/english_words.dart';
import 'package:translator/translator.dart';

enum TranslateMethod {
  same,
  correct,
}

class TranslateText {
  static Future<WordPair> translate(
    WordPair text, {
    String from = 'en',
    String to = 'pt',
    TranslateMethod method = TranslateMethod.correct,
  }) async {
    final words = text.asSnakeCase.split('_');

    try {
      final translator = GoogleTranslator();

      if (method == TranslateMethod.same) {
        List<Translation> translations = [];

        for (var word in words) {
          final translation = await translator.translate(
            word,
            from: from,
            to: to,
          );

          translations.add(translation);
        }

        return WordPair(
          translations[0].text.toLowerCase(),
          translations[1].text.toLowerCase(),
        );
      }

      final translation = await translator.translate(
        words.join(' '),
        from: from,
        to: to,
      );

      return WordPair(
        translation.text.split(" ").first.toLowerCase(),
        translation.text.split(" ").last.toLowerCase(),
      );
    } catch (error) {
      print(error);
      return text;
    }
  }
}
