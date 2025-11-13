import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F172A), // deep navy
                Color(0xFF172554), // darker indigo
                Color(0xFF0EA5A4), // teal highlight
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 0.6, 1],
            ),
          ),
        ),
        // Soft blobs for depth (positioned)
        Positioned(
          top: -80,
          left: -60,
          child: _Blob(size: 240, color: Colors.white24, blur: 60),
        ),
        Positioned(
          top: 60,
          right: -60,
          child: _Blob(size: 180, color: Colors.white10, blur: 40),
        ),
        Positioned(
          bottom: -90,
          left: -30,
          child: _Blob(size: 260, color: Colors.tealAccent.withOpacity(0.06), blur: 80),
        ),
        // The actual page content (safe area)
        SafeArea(child: child),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  final double blur;

  const _Blob({required this.size, required this.color, required this.blur});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.45),
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blur,
            spreadRadius: -10,
            offset: Offset(0, 8),
          ),
        ],
      ),
    );
  }
}
