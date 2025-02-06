import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namer_app/services/translateText.dart';
import 'package:provider/provider.dart';

import 'package:namer_app/main.dart';

import 'package:namer_app/widgets/BigCard.dart';
import 'package:namer_app/widgets/HistoryListView.dart';

import 'package:namer_app/utils/showSnackBar.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var isFavoritted = appState.isFavoritted();

    final theme = Theme.of(context);

    void translate() async {
      bool isTranslated =
          appState.currentWordPairTranslated != null && !appState.canTranslate;

      if (isTranslated) {
        appState.updateTranslatedText(null);
        return;
      }

      final translation = await TranslateText.translate(
        appState.currentWordPair,
        method: appState.translateMethod,
      );

      appState.updateTranslatedText(translation);
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
            currentPair:
                appState.currentWordPairTranslated ?? appState.currentWordPair,
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
                  translate();
                },
                child: Text("Next"),
              ),

              // Copy button
              IconButton(
                onPressed: () {
                  ShowSnackBar.show("Copied to clipboard", context);

                  Clipboard.setData(
                    ClipboardData(
                      text: appState.currentWordPair.asLowerCase,
                    ),
                  );
                },
                color: theme.colorScheme.secondary,
                icon: Icon(Icons.copy),
              ),

              // Translate button
              GestureDetector(
                onLongPress: () {
                  var methodNames = {
                    TranslateMethod.same: "Same",
                    TranslateMethod.correct: "Correct",
                  };

                  appState.alternateTranslateMethods();

                  ShowSnackBar.show(
                    "Changed translate method to ${methodNames[appState.translateMethod]}",
                    context,
                  );

                  if (appState.canTranslate) {
                    translate();
                  }
                },
                child: IconButton(
                  onPressed: () {
                    appState.setCanTranslate(!appState.canTranslate);
                    translate();
                  },
                  color: appState.canTranslate
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondary,
                  icon: Icon(Icons.translate),
                ),
              ),
            ],
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
