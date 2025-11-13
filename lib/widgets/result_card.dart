// lib/widgets/result_card.dart
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/responsive.dart';

class ResultCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const ResultCard({Key? key, required this.student, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avg = student.percentage;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0,4))],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white12,
                child: Text(student.name.isNotEmpty ? student.name[0] : '?', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: TextStyle(fontSize: R.text(context,16), color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height:6),
                    Text('Roll: ${student.roll}', style: TextStyle(fontSize: R.text(context,12), color: Colors.white70)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${avg.toStringAsFixed(1)}%', style: TextStyle(fontSize: R.text(context,16), color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height:6),
                  Container(
                    width: 64, height: 34,
                    child: Stack(
                      children: [
                        Center(child: CircularProgressIndicator(value: avg/100, color: Colors.tealAccent, strokeWidth: 4)),
                        Center(child: Text('${avg.toInt()}%', style: TextStyle(fontSize: R.text(context,12), color: Colors.white))),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
