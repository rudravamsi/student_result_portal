import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/background.dart';
import '../widgets/glass_card.dart';
import '../widgets/marks_chart.dart';
import '../widgets/animated_entry.dart';
import '../widgets/subject_tile.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Student student;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg != null && arg is Student) {
      // Create a defensive copy so edits on this page don't mutate the original list until saved
      student = Student(
        id: arg.id,
        name: arg.name,
        roll: arg.roll,
        subjects: arg.subjects
            .map((s) => Subject(name: s.name, marks: s.marks))
            .toList(),
      );
    } else {
      student = Student(id: 'x', name: 'Unknown', roll: 0, subjects: []);
    }
  }

  void _editMarks(int index) async {
    final current = student.subjects[index].marks;
    int? newMarks = await showDialog<int>(
      context: context,
      builder: (context) {
        int temp = current;
        return AlertDialog(
          title: Text('Edit ${student.subjects[index].name} marks'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: current.toString()),
            decoration: InputDecoration(labelText: 'Marks (0-100)'),
            onChanged: (v) => temp = int.tryParse(v) ?? temp,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, temp), child: Text('Save')),
          ],
        );
      },
    );

    if (newMarks != null) {
      setState(() {
        student.subjects[index].marks = newMarks.clamp(0, 100);
      });
    }
  }

  double _average() {
    if (student.subjects.isEmpty) return 0.0;
    return student.subjects.map((s) => s.marks).reduce((a, b) => a + b) / student.subjects.length;
  }

  String _grade() {
    final avg = _average();
    if (avg >= 90) return 'A+';
    if (avg >= 80) return 'A';
    if (avg >= 70) return 'B+';
    if (avg >= 60) return 'B';
    if (avg >= 50) return 'C';
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    final pct = student.percentage;
    final subjects = student.subjects.map((s) => s.name).toList();
    final marks = student.subjects.map((s) => s.marks).toList();

    // simple previousMarks dataset for comparison (adjust or supply real historical data)
    final prev = marks.map((m) => (m - 6) < 0 ? 0 : (m - 6)).toList();

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Result - ${student.name}')),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              // Summary card (top)
              GlassCard(
                padding: EdgeInsets.all(12),
                radius: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(student.name.isNotEmpty ? student.name[0] : '?'),
                      radius: 28,
                      backgroundColor: Colors.white24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Roll: ${student.roll}', style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(label: Text('Avg: ${_average().toStringAsFixed(1)}', style: TextStyle(color: Colors.black)), backgroundColor: Colors.tealAccent.shade100),
                              SizedBox(width: 8),
                              Chip(label: Text('Grade: ${_grade()}', style: TextStyle(color: Colors.black)), backgroundColor: Colors.amberAccent.shade100),
                              SizedBox(width: 8),
                              Chip(label: Text('Percent: ${pct.toStringAsFixed(1)}%', style: TextStyle(color: Colors.black)), backgroundColor: Colors.greenAccent.shade100),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text('${pct.toStringAsFixed(1)}%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 6),
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: Stack(
                            children: [
                              Center(child: CircularProgressIndicator(value: pct / 100, color: Colors.tealAccent, strokeWidth: 6)),
                              Center(child: Text('${pct.toInt()}%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Chart card — wrapped with AnimatedEntry for slide+fade animation
              GlassCard(
                padding: EdgeInsets.all(14),
                radius: 14,
                child: AnimatedEntry(
                  child: MarksChart(
                    subjects: subjects,
                    marks: marks,
                    previousMarks: prev,
                    showValues: true,
                  ),
                ),
              ),

              SizedBox(height: 12),

              // Detailed list of subjects using SubjectTile (responsive row layout inside each tile)
              Expanded(
                child: ListView.separated(
                  itemCount: student.subjects.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final sub = student.subjects[i];
                    return SubjectTile(
                      subject: sub,
                      onEdit: () => _editMarks(i),
                    );
                  },
                ),
              ),

              SizedBox(height: 10),

              // Save and return to Home — return updated student to previous page
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, student);
                },
                icon: Icon(Icons.save),
                label: Text('Save and Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
