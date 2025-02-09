import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:namer_app/core/AppState.dart';

import 'package:namer_app/utils/showSnackBar.dart';

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

    return GestureDetector(
      onTap: () {
        var text = appState.currentWordPairTranslated != null
            ? appState.currentWordPairTranslated!.asLowerCase
            : appState.currentWordPair.asLowerCase;

        Clipboard.setData(ClipboardData(text: text));
        ShowSnackBar.show("Copied to clipboard", context);
      },
      child: Card(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
