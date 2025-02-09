import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:namer_app/main.dart';

import 'package:namer_app/pages/GeneratorPage.dart';
import 'package:namer_app/pages/FavoritesPage.dart';

import 'package:namer_app/services/translateText.dart';

import 'package:namer_app/utils/showSnackBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPageIndex = 0;

  final Map<int, Widget> pagesMap = {
    0: GeneratorPage(),
    1: FavoritesPage(),
  };

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var colorScheme = Theme.of(context).colorScheme;

    Widget? page = pagesMap[currentPageIndex];

    var mainArea = ColoredBox(
      color: colorScheme.primaryContainer,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    Color getFabIconColor() {
      if (appState.canTranslate) {
        return colorScheme.onPrimary;
      } else {
        return colorScheme.secondary;
      }
    }

    Color getFabColor() {
      if (appState.canTranslate) {
        return colorScheme.primary;
      } else {
        return colorScheme.onPrimary;
      }
    }

    return Scaffold(
      floatingActionButton: GestureDetector(
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
        child: FloatingActionButton(
          onPressed: () {
            appState.setCanTranslate(!appState.canTranslate);
            appState.translate();
          },
          backgroundColor: getFabColor(),
          child: Icon(Icons.translate, color: getFabIconColor()),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        // Mobile Layout
        if (constraints.maxWidth < 480) {
          return Column(
            children: [
              Expanded(child: mainArea),
              BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: "Favorites",
                  ),
                ],
                currentIndex: currentPageIndex,
                onTap: (value) => setState(() {
                  currentPageIndex = value;
                }),
              ),
              // SafeArea(
              //   child:
              // ),
            ],
          );
        }
        // Default Layout
        else {
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text("Favorites"),
                    ),
                  ],
                  selectedIndex: currentPageIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      currentPageIndex = value;
                    });
                  },
                ),
              ),
              Expanded(child: mainArea),
            ],
          );
        }
      }),
    );
  }
}
