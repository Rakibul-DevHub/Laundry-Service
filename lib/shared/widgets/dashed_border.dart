import 'dart:ui';

import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  final Widget? child;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const DashedBorder({
    super.key,
    this.child,
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.dashLength = 6.0,
    this.dashGap = 4.0,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        dashGap: dashGap,
        borderRadius: borderRadius,
      ),
      child: child == null
          ? null
          : Padding(
              padding: padding,
              child: child,
            ),
    );
  }
}



class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;
  final BorderRadius? borderRadius;

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashGap,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Rect rect = Offset.zero & size;

    if (borderRadius != null) {
      final RRect rRect = RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius!.topLeft,
        topRight: borderRadius!.topRight,
        bottomLeft: borderRadius!.bottomLeft,
        bottomRight: borderRadius!.bottomRight,
      );
      _drawDashedRRect(canvas, rRect, paint);
    } else {
      _drawDashedRect(canvas, rect, paint);
    }
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint) {
    final double totalLength = 2 * (rect.width + rect.height);
    final int dashCount = (totalLength / (dashLength + dashGap)).ceil();
    double currentLength = 0.0;

    for (int i = 0; i < dashCount; i++) {
      if (currentLength >= totalLength) {
        break;
      }

      final bool isDash = i % 2 == 0;
      final double segmentLength = isDash ? dashLength : dashGap;

      // Determine which edge we're on
      if (currentLength < rect.width) {
        // Top edge
        final double startX = currentLength;
        final double endX = (currentLength + segmentLength).clamp(
          0.0,
          rect.width,
        );
        if (isDash) {
          canvas.drawLine(
            Offset(startX, 0),
            Offset(endX, 0),
            paint,
          );
        }
        currentLength += segmentLength;
      } else if (currentLength < rect.width + rect.height) {
        // Right edge
        final double progress = currentLength - rect.width;
        final double startY = progress;
        final double endY = (progress + segmentLength).clamp(0.0, rect.height);
        if (isDash) {
          canvas.drawLine(
            Offset(rect.width, startY),
            Offset(rect.width, endY),
            paint,
          );
        }
        currentLength += segmentLength;
      } else if (currentLength < 2 * rect.width + rect.height) {
        // Bottom edge (right to left)
        final double progress = currentLength - (rect.width + rect.height);
        final double endX = rect.width - progress;
        final double startX = (endX - segmentLength).clamp(0.0, rect.width);
        if (isDash) {
          canvas.drawLine(
            Offset(endX, rect.height),
            Offset(startX, rect.height),
            paint,
          );
        }
        currentLength += segmentLength;
      } else {
        // Left edge (bottom to top)
        final double progress = currentLength - (2 * rect.width + rect.height);
        final double endY = rect.height - progress;
        final double startY = (endY - segmentLength).clamp(0.0, rect.height);
        if (isDash) {
          canvas.drawLine(
            Offset(0, endY),
            Offset(0, startY),
            paint,
          );
        }
        currentLength += segmentLength;
      }
    }
  }

  void _drawDashedRRect(Canvas canvas, RRect rRect, Paint paint) {
    // For simplicity, we'll approximate with path (not perfect dashes on curves,
    // but works well for most cases)
    final Path path = Path()..addRRect(rRect);
    canvas.drawPath(
      _dashedPath(path, dashLength, dashGap),
      paint,
    );
  }

  Path _dashedPath(Path source, double dashLength, double dashGap) {
    final PathMetrics pathMetrics = source.computeMetrics();
    final Path outputPath = Path();

    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < pathMetric.length) {
        final double endDistance = (distance + (draw ? dashLength : dashGap))
            .clamp(0.0, pathMetric.length);
        if (draw) {
          outputPath.addPath(
            pathMetric.extractPath(distance, endDistance),
            Offset.zero,
          );
        }
        distance = endDistance;
        draw = !draw;
      }
    }

    return outputPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
