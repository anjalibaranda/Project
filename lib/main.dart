import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// STUDENT MODEL
class Student {
  final String name;
  final String enrollment;
  final String course;
  final String semester;

  Student({
    required this.name,
    required this.enrollment,
    required this.course,
    required this.semester,
  });
}

// SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 10), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.school, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Student Management App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MAIN SCREEN WITH BOTTOM NAVIGATION
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final List<Student> students = [];

  void addStudent(Student student) {
    setState(() {
      students.add(student);
      selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      StudentFormScreen(
        students: students,
        onAdd: addStudent,
      ),
      StudentListScreen(students: students),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add),
            label: 'Student Form',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Student List',
          ),
        ],
      ),
    );
  }
}

// HOME SCREEN
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.indigo),
            SizedBox(height: 20),
            Text(
              'Welcome to Student Management App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// STUDENT FORM
class StudentFormScreen extends StatefulWidget {
  final List<Student> students;
  final Function(Student) onAdd;

  const StudentFormScreen({
    super.key,
    required this.students,
    required this.onAdd,
  });

  @override
  State<StudentFormScreen> createState() =>
      _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final enrollmentController = TextEditingController();

  String? selectedCourse;
  String? selectedSemester;

  final courses = [
    'BCA',
    'BBA',
    'B.Sc IT',
    'B.Tech',
    'MCA',
    'MBA',
  ];

  final semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8',
  ];

  @override
  void dispose() {
    nameController.dispose();
    enrollmentController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    final enrollment = enrollmentController.text.trim();

    if (widget.students.any(
          (s) => s.enrollment.toLowerCase() == enrollment.toLowerCase(),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enrollment number already exists'),
        ),
      );
      return;
    }

    final student = Student(
      name: nameController.text.trim(),
      enrollment: enrollment,
      course: selectedCourse!,
      semester: selectedSemester!,
    );

    widget.onAdd(student);

    nameController.clear();
    enrollmentController.clear();

    setState(() {
      selectedCourse = null;
      selectedSemester = null;
    });

    formKey.currentState!.reset();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter student name';
                  }
                  if (!RegExp(r'^[a-zA-Z ]+$')
                      .hasMatch(value.trim())) {
                    return 'Enter a valid name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: enrollmentController,
                decoration: const InputDecoration(
                  labelText: 'Enrollment Number',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter enrollment number';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9/-]+$')
                      .hasMatch(value.trim())) {
                    return 'Enter a valid enrollment number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCourse,
                decoration: const InputDecoration(
                  labelText: 'Select Course',
                  prefixIcon: Icon(Icons.menu_book),
                  border: OutlineInputBorder(),
                ),
                items: courses.map((course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedCourse = value);
                },
                validator: (value) =>
                value == null ? 'Please select course' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedSemester,
                decoration: const InputDecoration(
                  labelText: 'Select Semester',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                items: semesters.map((semester) {
                  return DropdownMenuItem(
                    value: semester,
                    child: Text(semester),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedSemester = value);
                },
                validator: (value) =>
                value == null ? 'Please select semester' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: const Text('Submit Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// STUDENT LIST
class StudentListScreen extends StatelessWidget {
  final List<Student> students;

  const StudentListScreen({
    super.key,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: students.isEmpty
          ? const Center(
        child: Text(
          'No students found',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(student.name[0].toUpperCase()),
              ),
              title: Text(student.name),
              subtitle: Text(
                'Enrollment: ${student.enrollment}\n'
                    'Course: ${student.course}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentDetailScreen(
                      student: student,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// STUDENT DETAIL CARD
class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  Widget detail(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 45,
                    child: Text(
                      student.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 30),
                  detail(
                    'Student Name',
                    student.name,
                    Icons.person,
                  ),
                  detail(
                    'Enrollment Number',
                    student.enrollment,
                    Icons.badge,
                  ),
                  detail(
                    'Course',
                    student.course,
                    Icons.menu_book,
                  ),
                  detail(
                    'Semester',
                    student.semester,
                    Icons.calendar_month,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}