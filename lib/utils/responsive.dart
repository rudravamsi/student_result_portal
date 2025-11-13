// lib/utils/responsive.dart
import 'package:flutter/material.dart';

class R {
  // scale factor: multiply base font sizes by this
  static double scale(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    // base width 360 -> scale relative to screen width
    final baseWidth = 360.0;
    return (mq.size.width / baseWidth).clamp(0.8, 1.4);
  }

  static double text(BuildContext ctx, double baseSize) => baseSize * scale(ctx);
}
