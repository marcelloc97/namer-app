import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:namer_app/main.dart';

import 'package:namer_app/utils/showSnackBar.dart';

import 'package:namer_app/services/translateText.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.currentPair,
  });

  final WordPair currentPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 42.0,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MergeSemantics(
                child: Wrap(
                  children: [
                    Text(
                      currentPair.first,
                      style: style.copyWith(fontWeight: FontWeight.w200),
                    ),
                    Text(
                      currentPair.second,
                      style: style.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                spacing: 10.0,
                children: [
                  // Copy button
                  IconButton(
                    onPressed: () {
                      var text = appState.currentWordPairTranslated != null
                          ? appState.currentWordPairTranslated!.asLowerCase
                          : appState.currentWordPair.asLowerCase;

                      ShowSnackBar.show("Copied to clipboard", context);

                      Clipboard.setData(
                        ClipboardData(
                          text: text,
                        ),
                      );
                    },
                    color: theme.colorScheme.surfaceDim,
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
                        appState.translate();
                      }
                    },
                    child: IconButton(
                      onPressed: () {
                        appState.setCanTranslate(!appState.canTranslate);
                        appState.translate();
                      },
                      color: appState.canTranslate
                          ? theme.colorScheme.inversePrimary
                          : theme.colorScheme.surfaceDim,
                      icon: Icon(Icons.translate),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
