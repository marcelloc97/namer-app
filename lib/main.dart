import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:namer_app/core/AppState.dart';

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
