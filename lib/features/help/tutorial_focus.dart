import 'package:flutter/material.dart';

class TutorialFocus extends InheritedWidget {
  const TutorialFocus({required this.target, required super.child, super.key});
  final String? target;
  @override
  bool updateShouldNotify(TutorialFocus oldWidget) =>
      oldWidget.target != target;
}

class TutorialHighlight extends StatelessWidget {
  const TutorialHighlight({
    required this.target,
    required this.child,
    super.key,
  });
  final String target;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final active =
        context.dependOnInheritedWidgetOfExactType<TutorialFocus>()?.target ==
        target;
    if (!active) return child;
    return Semantics(
      label: 'Tutorial highlighted control',
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF6C5525), width: 3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: child,
      ),
    );
  }
}
