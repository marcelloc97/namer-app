import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:namer_app/services/translateText.dart';

class AppState extends ChangeNotifier {
  bool loading = false;

  WordPair currentWordPair = WordPair.random();

  // Translation vars
  WordPair? currentWordPairTranslated;
  TranslateMethod translateMethod = TranslateMethod.correct;
  bool canTranslate = false;

  List<WordPair> favoriteWords = [];
  final List<WordPair> history = [];

  GlobalKey? historyListKey;

  AppState() {
    _loadFavorites();
  }

  void setLoadingState(bool value) {
    loading = value;
    notifyListeners();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorites = prefs.getStringList('favorites');

    if (favorites != null) {
      favoriteWords = favorites
          .map(
            (e) => WordPair(e.split('_').first, e.split('_').last),
          )
          .toSet()
          .toList();
    } else {
      favoriteWords = [];
    }
  }

  void getNext() {
    var animatedList = historyListKey?.currentState as AnimatedListState?;

    animatedList?.insertItem(0);
    history.insert(0, currentWordPair);
    currentWordPair = WordPair.random();

    notifyListeners();
  }

  void updateTranslatedText(WordPair? wordPair) {
    currentWordPairTranslated = wordPair;
    notifyListeners();
  }

  void toggleFavorite([WordPair? wordPair]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    wordPair ??= currentWordPair;

    if (favoriteWords.contains(wordPair)) {
      favoriteWords.remove(wordPair);
    } else {
      favoriteWords.add(wordPair);
    }

    prefs.setStringList(
      'favorites',
      favoriteWords.map((e) => e.asSnakeCase).toList(),
    );

    notifyListeners();
  }

  void removeFavorite(WordPair wordPair) {
    favoriteWords.remove(wordPair);
    notifyListeners();
  }

  bool isFavoritted() {
    return favoriteWords.contains(currentWordPair);
  }

  void setCanTranslate(bool value) {
    canTranslate = value;
    notifyListeners();
  }

  void alternateTranslateMethods() {
    translateMethod = translateMethod == TranslateMethod.correct
        ? TranslateMethod.same
        : TranslateMethod.correct;

    notifyListeners();
  }

  void translate() async {
    bool isTranslated = currentWordPairTranslated != null && !canTranslate;

    if (isTranslated) {
      updateTranslatedText(null);
      return;
    }

    final translation = await TranslateText.translate(
      currentWordPair,
      method: translateMethod,
    );

    updateTranslatedText(translation);
  }

  Future<WordPair> translateFavorite(WordPair favorite) async {
    final translation = await TranslateText.translate(
      favorite,
      method: TranslateMethod.same,
    );

    return translation;
  }
}
