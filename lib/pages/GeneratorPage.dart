import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:namer_app/main.dart';

import 'package:namer_app/widgets/BigCard.dart';
import 'package:namer_app/widgets/HistoryListView.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var isFavoritted = appState.isFavoritted();

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
          BigCard(currentPair: appState.currentWordPair),
          SizedBox(height: 10.0),
          //
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () => appState.toggleFavorite(),
                icon:
                    Icon(isFavoritted ? Icons.favorite : Icons.favorite_border),
                label: Text(isFavoritted ? "Dislike" : "Like"),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () => appState.getNext(),
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
