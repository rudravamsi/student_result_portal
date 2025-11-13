import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/result_card.dart';
import '../widgets/background.dart';
import '../widgets/glass_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

List<Student> _sampleStudents() {
  return [
    Student(
      id: 's1',
      name: 'Asha Kumar',
      roll: 11,
      subjects: [
        Subject(name: 'Maths', marks: 84),
        Subject(name: 'Physics', marks: 76),
        Subject(name: 'Chemistry', marks: 80),
        Subject(name: 'English', marks: 88),
        Subject(name: 'Biology', marks: 72),
        Subject(name: 'Computer Science', marks: 95),
        Subject(name: 'History', marks: 66),
        Subject(name: 'Geography', marks: 74),
      ],
    ),
    Student(
      id: 's2',
      name: 'Rahul Sharma',
      roll: 12,
      subjects: [
        Subject(name: 'Maths', marks: 70),
        Subject(name: 'Physics', marks: 65),
        Subject(name: 'Chemistry', marks: 68),
        Subject(name: 'English', marks: 74),
        Subject(name: 'Biology', marks: 62),
        Subject(name: 'Computer Science', marks: 85),
        Subject(name: 'History', marks: 59),
        Subject(name: 'Geography', marks: 63),
      ],
    ),
    Student(
      id: 's3',
      name: 'Sneha Patel',
      roll: 13,
      subjects: [
        Subject(name: 'Maths', marks: 91),
        Subject(name: 'Physics', marks: 88),
        Subject(name: 'Chemistry', marks: 85),
        Subject(name: 'English', marks: 94),
        Subject(name: 'Biology', marks: 86),
        Subject(name: 'Computer Science', marks: 96),
        Subject(name: 'History', marks: 79),
        Subject(name: 'Geography', marks: 83),
      ],
    ),
  ];
}


class _HomePageState extends State<HomePage> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    students = _sampleStudents();
  }

  void _openResult(Student s) async {
    final result = await Navigator.pushNamed(context, '/result', arguments: s);
    if (result != null && result is Student) {
      setState(() {
        final idx = students.indexWhere((st) => st.id == result.id);
        if (idx >= 0) students[idx] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Student Result Portal', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(onPressed: () => Navigator.pushNamed(context, '/contact'), icon: Icon(Icons.contact_mail)),
            IconButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), icon: Icon(Icons.logout)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            children: [
              // Top summary glass card
              GlassCard(
                padding: EdgeInsets.all(16),
                radius: 18,
                child: Row(
                  children: [
                    CircleAvatar(radius: 28, backgroundColor: Colors.white.withOpacity(0.12), child: Icon(Icons.school, color: Colors.white)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Class Summary', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('${students.length} students • Average: ${_classAverage().toStringAsFixed(1)}%', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/contact'),
                      icon: Icon(Icons.add),
                      label: Text('Contact'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: students.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final s = students[i];
                    return ResultCard(student: s, onTap: () => _openResult(s));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _classAverage() {
    if (students.isEmpty) return 0.0;
    return students.map((s) => s.percentage).reduce((a, b) => a + b) / students.length;
  }
}
