import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:namer_app/core/Types.dart';
import 'package:namer_app/core/AppState.dart';

import 'package:namer_app/pages/GeneratorPage.dart';
import 'package:namer_app/pages/FavoritesPage.dart';
import 'package:namer_app/pages/InformationsPage.dart';

import 'package:namer_app/services/translateText.dart';

import 'package:namer_app/utils/showSnackBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPageIndex = 0;

  final PageMap pagesMap = {
    0: {
      "widget": GeneratorPage(),
      "label": "Home",
      "icon": Icons.home,
    },
    1: {
      "widget": FavoritesPage(),
      "label": "Favorites",
      "icon": Icons.favorite,
    },
    2: {
      "widget": InformationsPage(),
      "label": "Informations",
      "icon": Icons.info,
    },
  };

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var colorScheme = Theme.of(context).colorScheme;

    Map<String, dynamic> currentPage =
        pagesMap[currentPageIndex] as Map<String, dynamic>;

    var mainArea = ColoredBox(
      color: colorScheme.primaryContainer,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: currentPage["widget"],
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
                items: pagesMap.entries
                    .map(
                      (entry) => BottomNavigationBarItem(
                        icon: Icon(entry.value["icon"] as IconData),
                        label: entry.value["label"] as String,
                      ),
                    )
                    .toList(),

                ///
                currentIndex: currentPageIndex,
                onTap: (value) => setState(() {
                  currentPageIndex = value;
                }),
              ),
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
                  destinations: pagesMap.entries
                      .map(
                        (entry) => NavigationRailDestination(
                          icon: Icon(entry.value["icon"] as IconData),
                          label: Text(entry.value["label"] as String),
                        ),
                      )
                      .toList(),

                  ///
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
