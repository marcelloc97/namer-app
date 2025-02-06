import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    var favorites = appState.favoriteWords;

    var textStyle = theme.textTheme.displayMedium!.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 36.0,
    );

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
          title: Text(
            favorites[index].asLowerCase,
            semanticsLabel:
                "${favorites[index].first} ${favorites[index].second}",
          ),
          onTap: () {
            Clipboard.setData(
              ClipboardData(text: favorites[index].asLowerCase),
            );
          },
        ),
      ),
    );
  }
}
