import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final bool isVertical;
  final Color color;
  final double thickness;
  final double dashLength;
  final double dashGap;
  final double length;

  const DashedDivider({
    super.key,
    this.isVertical = false,
    this.color = Colors.grey,
    this.thickness = 1.0,
    this.dashLength = 6.0,
    this.dashGap = 4.0,
    this.length = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final Axis direction = isVertical ? Axis.vertical : Axis.horizontal;

    return SizedBox(
      width: direction == Axis.horizontal ? length : thickness,
      height: direction == Axis.vertical ? length : thickness,
      child: CustomPaint(
        painter: _DashedLinePainter(
          direction: direction,
          color: color,
          strokeWidth: thickness,
          dashLength: dashLength,
          dashGap: dashGap,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Axis direction;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  _DashedLinePainter({
    required this.direction,
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double length = direction == Axis.horizontal
        ? size.width
        : size.height;
    final int dashCount = (length / (dashLength + dashGap)).ceil();
    double currentPos = 0.0;

    for (int i = 0; i < dashCount; i++) {
      if (currentPos >= length) {
        break;
      }

      if (i % 2 == 0) {
        // Draw dash
        final double endPos = (currentPos + dashLength).clamp(0.0, length);
        if (direction == Axis.horizontal) {
          canvas.drawLine(
            Offset(currentPos, size.height / 2),
            Offset(endPos, size.height / 2),
            paint,
          );
        } else {
          canvas.drawLine(
            Offset(size.width / 2, currentPos),
            Offset(size.width / 2, endPos),
            paint,
          );
        }
      }
      currentPos += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
