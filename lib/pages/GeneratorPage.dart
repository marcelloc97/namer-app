import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:namer_app/core/AppState.dart';

import 'package:namer_app/widgets/BigCard.dart';
import 'package:namer_app/widgets/HistoryListView.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var isFavoritted = appState.isFavoritted();

    WordPair getCurrentPair() {
      if (appState.canTranslate && appState.currentWordPairTranslated != null) {
        return appState.currentWordPairTranslated!;
      } else {
        return appState.currentWordPair;
      }
    }

    return Center(
      child: Column(
        // centraliza verticalmente
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10.0),
          //
          BigCard(
            currentPair: getCurrentPair(),
          ),
          SizedBox(height: 10.0),
          //
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.0,
            children: [
              // Like button
              ElevatedButton.icon(
                onPressed: () => appState.toggleFavorite(),
                icon:
                    Icon(isFavoritted ? Icons.favorite : Icons.favorite_border),
                label: Text(isFavoritted ? "Dislike" : "Like"),
              ),

              // Next button
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                  appState.translate();
                },
                child: Text("Next"),
              ),
            ],
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
