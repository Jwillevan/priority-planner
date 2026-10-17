import 'package:flutter/material.dart';

import '../../app/paper_theme.dart';

/// Original ruled-paper rendering. No branded artwork or third-party assets.
class PaperPage extends StatelessWidget {
  const PaperPage({super.key, required this.child, this.ruled = false});

  final Widget child;
  final bool ruled;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PaperPalette>()!;
    final spacing = 32.0 * MediaQuery.textScalerOf(context).scale(1);
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: palette.paper,
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [
          BoxShadow(color: Color(0x18000000), blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: ruled ? _PaperLines(palette, spacing) : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 20, 24),
          child: child,
        ),
      ),
    );
  }
}

class _PaperLines extends CustomPainter {
  _PaperLines(this.palette, this.spacing);

  final PaperPalette palette;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = palette.rule
      ..strokeWidth = 0.6;
    for (var y = 68.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(16, y), Offset(size.width - 16, y), line);
    }
    canvas.drawLine(
      const Offset(16, 16),
      Offset(16, size.height - 16),
      Paint()
        ..color = palette.margin
        ..strokeWidth = 0.7,
    );
  }

  @override
  bool shouldRepaint(_PaperLines oldDelegate) =>
      oldDelegate.palette != palette || oldDelegate.spacing != spacing;
}
