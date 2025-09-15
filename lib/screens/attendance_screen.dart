import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:excel/excel.dart';

class Student {
  String rollNo;
  String name;
  String batch;
  String semester;
  String committee;
  DateTime? inTime;
  DateTime? outTime;
  bool isPresent;

  Student({
    required this.rollNo,
    required this.name,
    required this.batch,
    required this.semester,
    required this.committee,
    this.inTime,
    this.outTime,
    this.isPresent = false,
  });
}

class AttendanceState extends ChangeNotifier {
  List<Student> students = [];

  void addStudent(Student s) {
    students.add(s);
    notifyListeners();
  }

  void updateAttendance(String rollNo, bool present) {
    try {
      final student = students.firstWhere((s) => s.rollNo == rollNo,
          orElse: () => throw 'not found');
      student.isPresent = present;
      final now = DateTime.now();
      if (present) {
        student.inTime = now;
      } else {
        student.outTime = now;
      }
      notifyListeners();
    } catch (e) {
      // student not found
    }
  }

  void addFromCsv(String csvContent) {
    final lines = LineSplitter.split(csvContent).toList();
    for (var line in lines.skip(1)) {
      final parts = line.split(',');
      if (parts.length >= 5) {
        students.add(Student(
          rollNo: parts[0],
          name: parts[1],
          batch: parts[2],
          semester: parts[3],
          committee: parts[4],
        ));
      }
    }
    notifyListeners();
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Controllers for adding student
  final addRollController = TextEditingController();
  final addNameController = TextEditingController();
  final addBatchController = TextEditingController();
  final addSemesterController = TextEditingController();

  String committeeValue = 'Help';

  // Controllers for attendance update
  final rollController = TextEditingController();
  String statusValue = 'Present';

  final Map<String, String> statusMap = {
    'In': 'Present',
    'Out': 'Absent',
  };

  @override
  void dispose() {
    addRollController.dispose();
    addNameController.dispose();
    addBatchController.dispose();
    addSemesterController.dispose();
    rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AttendanceState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CSV Upload ---
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                );

                if (result != null && result.files.single.path != null) {
                  final file = File(result.files.single.path!);
                  final bytes = await file.readAsBytes();
                  final excel = Excel.decodeBytes(bytes);

                  for (var sheetName in excel.tables.keys) {
                    final sheet = excel.tables[sheetName]!;
                    for (var row in sheet.rows.skip(1)) { // skip header
                      final rollNo = row[0]?.value.toString() ?? '';
                      final name = row[1]?.value.toString() ?? '';
                      final batch = row[2]?.value.toString() ?? '';
                      final semester = row[3]?.value.toString() ?? '';
                      final committee = row[4]?.value.toString() ?? '';

                      if (rollNo.isNotEmpty && name.isNotEmpty) {
                        state.addStudent(Student(
                          rollNo: rollNo,
                          name: name,
                          batch: batch,
                          semester: semester,
                          committee: committee,
                        ));
                      }
                    }
                  }
                }
              },
              child: const Text('Upload Excel'),
            ),

            const SizedBox(height: 20),

            // --- Manual Add Student ---
            Text('Add Student', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
                controller: addRollController,
                decoration: const InputDecoration(labelText: 'Roll No')),
            TextField(
                controller: addNameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: addBatchController,
                decoration: const InputDecoration(labelText: 'Batch')),
            TextField(
                controller: addSemesterController,
                decoration: const InputDecoration(labelText: 'Semester')),
            DropdownButton<String>(
              value: committeeValue,
              items: <String>[
                'Help',
                'Volunteer Care',
                'Plate Washing',
                'Venue Maintenance',
                'Special Invitees',
                'Press & Media',
                'Cultural'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newVal) {
                if (newVal != null) setState(() => committeeValue = newVal);
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (addRollController.text.isEmpty ||
                    addNameController.text.isEmpty) {
                  return;
                }
                state.addStudent(Student(
                  rollNo: addRollController.text,
                  name: addNameController.text,
                  batch: addBatchController.text,
                  semester: addSemesterController.text,
                  committee: committeeValue,
                ));
                addRollController.clear();
                addNameController.clear();
                addBatchController.clear();
                addSemesterController.clear();
              },
              child: const Text('Add Student'),
            ),
            const SizedBox(height: 20),

            // --- Update Attendance ---
            Text('Update Attendance',
                style: Theme.of(context).textTheme.titleMedium),
            TextField(
                controller: rollController,
                decoration: const InputDecoration(labelText: 'Roll No')),
            // Map between display values and actual logic value

            DropdownButton<String>(
              value: statusMap.entries
                  .firstWhere((e) => e.value == statusValue)
                  .key, // Show label based on current statusValue
              items: statusMap.keys.map((label) {
                return DropdownMenuItem<String>(
                  value: label,
                  child: Text(label), // user sees "In" / "Out"
                );
              }).toList(),
              onChanged: (selectedLabel) {
                if (selectedLabel != null) {
                  setState(() {
                    statusValue = statusMap[selectedLabel]!; 
                    // ✅ still stores "Present"/"Absent" internally
                  });
                }
              },
            ),

            ElevatedButton(
              onPressed: () {
                if (rollController.text.isEmpty) return;
                final exists =
                    state.students.any((s) => s.rollNo == rollController.text);
                if (exists) {
                  state.updateAttendance(
                      rollController.text, statusValue == 'Present');
                  rollController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Roll number not found!')),
                  );
                }
              },
              child: const Text('Update Attendance'),
            ),
            const SizedBox(height: 20),

            // --- Student List ---
            Text('Students List',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final s = state.students[index];
                return ListTile(
                  title: Text('${s.name} (${s.rollNo})'),
                  subtitle: Text(
                      'Batch: ${s.batch}, Semester: ${s.semester}, Committee: ${s.committee}'),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        s.isPresent ? 'Present' : 'Absent',
                        style: TextStyle(
                            color: s.isPresent ? Colors.green : Colors.red),
                      ),
                      if (s.inTime != null)
                        Text('In: ${DateFormat('HH:mm').format(s.inTime!)}'),
                      if (s.outTime != null)
                        Text('Out: ${DateFormat('HH:mm').format(s.outTime!)}'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
