import 'package:flutter/material.dart';
import 'package:namer_app/services/faqData.dart';

class InformationsPage extends StatefulWidget {
  const InformationsPage({super.key});

  @override
  State<InformationsPage> createState() => _InformationsPageState();
}

class _InformationsPageState extends State<InformationsPage> {
  final isExpansionPanelExpanded = ValueNotifier<List<bool>>([]);

  List<ExpansionPanel> getExpansionPanels() {
    return FAQData.questions.map(
      (faq) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (context, isOpen) => ListTile(
            title: Text(faq["question"] as String),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            dense: true,
          ),
          body: ListTile(
            dense: true,
            title: Text(faq["answer"] as String),
          ),
          isExpanded:
              isExpansionPanelExpanded.value[FAQData.questions.indexOf(faq)],
        );
      },
    ).toList();
  }

  @override
  initState() {
    super.initState();

    isExpansionPanelExpanded.value = List.generate(
      FAQData.questions.length,
      (index) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
        controller: ScrollController(
          keepScrollOffset: true,
          initialScrollOffset: 0.0,
        ),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "FAQ",
                style: theme.textTheme.displayMedium,
              ),
            ),
          ),

          ///
          SizedBox(height: 10.0),

          // Add some ExpansionPanels below with common questions and answers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ExpansionPanelList(
              children: getExpansionPanels(),
              expandedHeaderPadding: const EdgeInsets.all(0),
              materialGapSize: 8.0,
              expansionCallback: (index, isOpen) {
                setState(() {
                  isExpansionPanelExpanded.value[index] = isOpen;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
