import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:namer_app/pages/HomePage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: HomePage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  WordPair currentWordPair = WordPair.random();
  List<WordPair> favoriteWords = [];

  final List<WordPair> history = [];

  GlobalKey? historyListKey;

  AppState() {
    _loadFavorites();
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
}
