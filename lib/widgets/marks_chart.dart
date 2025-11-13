import 'package:flutter/material.dart';
import 'dart:math' as math;

/// MarksChart: dependency-free, grouped bars (previous vs current),
/// gradient current bars, neat spacing, value labels optional, responsive.
class MarksChart extends StatelessWidget {
  final List<String> subjects;
  final List<int> marks; // current exam marks (0-100)
  final List<int>? previousMarks; // optional previous exam marks (same length)
  final bool showValues; // show numeric labels above bars

  const MarksChart({
    Key? key,
    required this.subjects,
    required this.marks,
    this.previousMarks,
    this.showValues = true,
  })  : assert(subjects.length == marks.length,
  'subjects and marks must have same length'),
        assert(previousMarks == null || previousMarks.length == marks.length,
        'previousMarks must be same length as marks if provided'),
        super(key: key);

  Color _currentBarColor(int mark) {
    if (mark >= 90) return Color(0xFF16A085); // teal
    if (mark >= 75) return Color(0xFF2ECC71); // green
    if (mark >= 60) return Color(0xFFF39C12); // amber
    return Color(0xFFE74C3C); // red
  }

  Color _prevBarColor(int mark) {
    // desaturated / muted color for previous exam
    return Colors.white24;
  }

  double _maxBarHeight(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    if (h > 900) return 260;
    if (h > 700) return 200;
    return 140;
  }

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty || marks.isEmpty) {
      return Center(child: Text('No data', style: TextStyle(color: Colors.white70)));
    }

    final int n = subjects.length;
    final double maxMark = 100.0;
    final double chartHeight = _maxBarHeight(context);
    // We will draw grouped bars: each group contains up to 2 bars (prev, current).
    // Compute available width per group later via LayoutBuilder.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row + simple sparkline (small) on right
        Row(
          children: [
            Text('Marks by Subject', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Spacer(),
            SizedBox(
              width: 120,
              height: 44,
              child: CustomPaint(
                painter: _SparklinePainter(marks: marks),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Legend
        Row(
          children: [
            if (previousMarks != null) ...[
              _legendItem(Colors.white24, 'Previous'),
              SizedBox(width: 12),
            ],
            _legendItem(Colors.tealAccent.shade400, 'Current'),
          ],
        ),
        SizedBox(height: 10),

        // Chart area
        LayoutBuilder(builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          // spacing: groupSpacing is space between groups; innerSpacing is between two bars
          final groupSpacing = math.max(12.0, totalWidth * 0.02);
          final innerSpacing = 8.0;
          // width available for all groups
          final usable = totalWidth - groupSpacing * (n + 1);
          final groupWidth = math.max(40.0, usable / n); // ensure not too narrow
          // each bar width inside a group:
          final barWidth = previousMarks != null ? (groupWidth - innerSpacing) / 2 : groupWidth * 0.6;

          return SizedBox(
            height: chartHeight + 64,
            child: Column(
              children: [
                // Bars
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: totalWidth),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: groupSpacing),
                          for (int i = 0; i < n; i++) ...[
                            // group container
                            Container(
                              width: groupWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // value labels row
                                  if (showValues)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (previousMarks != null) ...[
                                          _valueLabel(previousMarks![i]),
                                          SizedBox(width: innerSpacing),
                                        ],
                                        _valueLabel(marks[i]),
                                      ],
                                    ),
                                  SizedBox(height: showValues ? 8 : 0),
                                  // bars row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (previousMarks != null) ...[
                                        // previous bar (muted)
                                        _buildBar(
                                          height: (previousMarks![i] / maxMark) * chartHeight,
                                          width: barWidth,
                                          color: _prevBarColor(previousMarks![i]),
                                          label: 'Prev',
                                          onTap: () => _showSnack(context, subjects[i], previousMarks![i], true),
                                        ),
                                        SizedBox(width: innerSpacing),
                                      ],
                                      // current bar (gradient)
                                      _buildBar(
                                        height: (marks[i] / maxMark) * chartHeight,
                                        width: barWidth,
                                        color: _currentBarColor(marks[i]),
                                        label: 'Curr',
                                        onTap: () => _showSnack(context, subjects[i], marks[i], false),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  // subject label
                                  SizedBox(
                                    width: groupWidth,
                                    child: Text(
                                      subjects[i].length > 12 ? subjects[i].substring(0, 12) + '…' : subjects[i],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: groupSpacing),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),
                // X-axis numbers (0..100)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('0', style: TextStyle(color: Colors.white54, fontSize: 11)),
                      Text('25', style: TextStyle(color: Colors.white54, fontSize: 11)),
                      Text('50', style: TextStyle(color: Colors.white54, fontSize: 11)),
                      Text('75', style: TextStyle(color: Colors.white54, fontSize: 11)),
                      Text('100', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 18, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _valueLabel(int value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(6)),
      child: Text('$value', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildBar({
    required double height,
    required double width,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    // gradient for current bars; for previous bar 'color' will be white24
    final gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [color.withOpacity(0.95), color.withOpacity(0.55)],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
          border: Border.all(color: Colors.white10),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String subject, int mark, bool isPrev) {
    final label = isPrev ? 'Previous' : 'Current';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$subject — $label: $mark / 100'),
      duration: Duration(seconds: 1),
    ));
  }
}

/// Small sparkline painter used in header
class _SparklinePainter extends CustomPainter {
  final List<int> marks;
  _SparklinePainter({required this.marks});

  @override
  void paint(Canvas canvas, Size size) {
    if (marks.isEmpty) return;
    final paintLine = Paint()..color = Colors.white70..strokeWidth = 2..style = PaintingStyle.stroke..isAntiAlias = true;
    final paintFill = Paint()..color = Colors.white12..style = PaintingStyle.fill..isAntiAlias = true;

    final maxMark = 100.0;
    final step = size.width / (marks.length - 1 == 0 ? 1 : marks.length - 1);
    final points = <Offset>[];
    for (int i = 0; i < marks.length; i++) {
      final x = i * step;
      final y = size.height - (marks[i] / maxMark) * size.height;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var p in points) path.lineTo(p.dx, p.dy);
    path.lineTo(points.last.dx, size.height);
    path.lineTo(points.first.dx, size.height);
    path.close();
    canvas.drawPath(path, paintFill);

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var p in points) linePath.lineTo(p.dx, p.dy);
    canvas.drawPath(linePath, paintLine);

    final dotPaint = Paint()..color = Colors.white;
    for (var p in points) canvas.drawCircle(p, 2.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => oldDelegate.marks != marks;
}
