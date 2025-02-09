import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

import 'package:namer_app/core/AppState.dart';

import 'package:namer_app/utils/showSnackBar.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    var favorites = appState.favoriteWords;
    Map<int, WordPair> translatedFavorites =
        favorites.asMap().map((key, value) => MapEntry(key, value));

    var textStyle = theme.textTheme.displayMedium!.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 36.0,
    );

    String showText(int index) {
      if (translatedFavorites[index] != null) {
        return translatedFavorites[index]!.asLowerCase;
      } else {
        return favorites[index].asLowerCase;
      }
    }

    if (favorites.isEmpty) {
      return Center(
        child: Text(
          'No favorites yet.',
          style: textStyle,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) => ListTile(
          leading: IconButton(
            icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
            color: theme.colorScheme.error,
            onPressed: () => appState.removeFavorite(favorites[index]),
          ),
          title: Row(
            children: [
              Text(
                showText(index),
                semanticsLabel:
                    "${favorites[index].first} ${favorites[index].second}",
              ),
              Spacer(flex: 1),
              IconButton(
                onPressed: () async {
                  translatedFavorites[index] =
                      await appState.translateFavorite(favorites[index]);
                },
                color: theme.colorScheme.secondary,
                icon: Icon(Icons.translate),
              ),
            ],
          ),
          onTap: () {
            ShowSnackBar.show("Copied to clipboard", context);

            Clipboard.setData(
              ClipboardData(text: favorites[index].asLowerCase),
            );
          },
        ),
      ),
    );
  }
}
