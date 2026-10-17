import 'package:flutter/material.dart';

import 'paper_page.dart';

class FoundationSection extends StatelessWidget {
  const FoundationSection({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => PaperPage(
        child: ListView(
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(description),
            const SizedBox(height: 24),
            const Text('This section is a navigation shell in the foundation build.'),
          ],
        ),
      );
}
