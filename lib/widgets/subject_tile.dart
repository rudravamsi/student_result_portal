// lib/widgets/subject_tile.dart
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/responsive.dart';

class SubjectTile extends StatelessWidget {
  final Subject subject;
  final VoidCallback onEdit;

  const SubjectTile({Key? key, required this.subject, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mark = subject.marks;
    final pass = mark >= 40;
    return Container(
      margin: EdgeInsets.symmetric(vertical:6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        title: Text(subject.name, style: TextStyle(color: Colors.white, fontSize: R.text(context,14), fontWeight: FontWeight.w600)),
        subtitle: Text('Marks: $mark/100', style: TextStyle(color: Colors.white70, fontSize: R.text(context,12))),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal:8, vertical:4),
            decoration: BoxDecoration(
              color: pass ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(pass ? 'Pass' : 'Fail', style: TextStyle(color: pass ? Colors.greenAccent : Colors.redAccent)),
          ),
          IconButton(icon: Icon(Icons.edit, color: Colors.white70), onPressed: onEdit)
        ]),
      ),
    );
  }
}
