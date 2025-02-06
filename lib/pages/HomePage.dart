import 'package:flutter/material.dart';

import 'package:namer_app/pages/GeneratorPage.dart';
import 'package:namer_app/pages/FavoritesPage.dart';

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
    var colorScheme = Theme.of(context).colorScheme;

    Widget? page = pagesMap[currentPageIndex];

    var mainArea = ColoredBox(
      color: colorScheme.primaryContainer,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
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
