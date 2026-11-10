import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Gráfica de trayectoria de flujo de efectivo en curva bezier editorial
class VelocityTrajectoryChart extends StatelessWidget {
  final List<double> points;

  const VelocityTrajectoryChart({
    super.key,
    this.points = const [0.3, 0.6, 0.4, 0.85, 0.5, 0.95, 0.7],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 140,
      width: double.infinity,
      child: CustomPaint(
        painter: _TrajectoryPainter(
          points: points,
          lineColor: isDark ? Colors.white : AppTheme.primaryObsidian,
          gridColor:
              isDark ? const Color(0xFF2C2D32) : AppTheme.outlineHairline,
        ),
      ),
    );
  }
}

class _TrajectoryPainter extends CustomPainter {
  final List<double> points;
  final Color lineColor;
  final Color gridColor;

  _TrajectoryPainter({
    required this.points,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Líneas guía horizontales punteadas
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4.0);
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (points.isEmpty) return;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (points.length - 1);
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      // Invertimos y porque 1.0 es arriba
      final y = size.height - (points[i] * (size.height - 30) + 15);
      offsets.add(Offset(x, y));
    }

    path.moveTo(offsets[0].dx, offsets[0].dy);
    fillPath.moveTo(offsets[0].dx, size.height);
    fillPath.lineTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final current = offsets[i];
      final next = offsets[i + 1];
      final controlPoint1 = Offset(current.dx + stepX / 2, current.dy);
      final controlPoint2 = Offset(next.dx - stepX / 2, next.dy);

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );

      fillPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Degradado sutil de área
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.08),
          lineColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Línea continua de tinta
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    // Marcadores de ancla destacados (como en diseño: punto en el pico)
    if (offsets.length > 5) {
      final peakPoint = offsets[offsets.length - 2];
      final circleBorderPaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;
      final circleCenterPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(peakPoint, 4.5, circleBorderPaint);
      canvas.drawCircle(peakPoint, 2.0, circleCenterPaint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = p1.dx;
    while (startX < p2.dx) {
      canvas.drawLine(
        Offset(startX, p1.dy),
        Offset(startX + dashWidth, p1.dy),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _TrajectoryPainter oldDelegate) => false;
}

/// Gráfica de cadencia semanal de barras discretas
class CadenceBarChart extends StatelessWidget {
  final List<double> weeklyAverages;

  const CadenceBarChart({
    super.key,
    this.weeklyAverages = const [0.60, 0.85, 0.45, 0.72],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(weeklyAverages.length, (index) {
        final val = weeklyAverages[index];
        final isCurrent = index == weeklyAverages.length - 1;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 60 * val,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? (isDark ? Colors.white : AppTheme.primaryObsidian)
                        : (isDark
                            ? const Color(0xFF33353A)
                            : AppTheme.surfaceContainerHigh),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'W${index + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isCurrent
                        ? (isDark ? Colors.white : AppTheme.primaryObsidian)
                        : AppTheme.tertiaryCashmere,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Barra segmentada de distribución proporcional
class CategorySegmentedBar extends StatelessWidget {
  final List<double> percentages;
  final List<Color> colors;

  const CategorySegmentedBar({
    super.key,
    required this.percentages,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 10,
        color: AppTheme.surfaceContainer,
        child: Row(
          children: List.generate(percentages.length, (i) {
            final pct = percentages[i];
            if (pct <= 0) return const SizedBox.shrink();
            return Expanded(
              flex: (pct * 1000).toInt(),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                color: colors[i % colors.length],
              ),
            );
          }),
        ),
      ),
    );
  }
}
