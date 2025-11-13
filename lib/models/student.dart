class Subject {
  final String name;
  int marks; // mutable so we can edit easily in demo

  Subject({required this.name, required this.marks});
}

class Student {
  final String id;
  final String name;
  final int roll;
  final List<Subject> subjects;

  Student({
    required this.id,
    required this.name,
    required this.roll,
    required this.subjects,
  });

  int get total => subjects.fold(0, (p, s) => p + s.marks);

  double get percentage {
    if (subjects.isEmpty) return 0.0;
    return (total / (subjects.length * 100)) * 100;
  }

  bool get pass => percentage >= 40; // simple rule
}
