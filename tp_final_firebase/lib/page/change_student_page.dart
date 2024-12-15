import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_final_firebase/widget/create_class_manage_student_widget.dart';

import '../providers/provider_classe.dart';
import '../providers/provider_search.dart';
import '../widget/class_dropdown_widget.dart';

class AssignStudentPage extends StatefulWidget {
  const AssignStudentPage({super.key});

  @override
  State<AssignStudentPage> createState() => _AssignStudentPageState();
}

class _AssignStudentPageState extends State<AssignStudentPage> {
  String? _selectedClass;

  @override
  Widget build(BuildContext context) {
    var classProvider = Provider.of<ProviderClasse>(context);
    var searchProvider = Provider.of<ProviderSearch>(context);
    var classes = classProvider.getAllClasses();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigner un étudiant à une classe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClassDropdown(
                selectedClass: _selectedClass,
                classes: classes,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClass = newValue;
                    classProvider.setSelectedClasse(newValue);
                  });
                },
              ),
            ),
            if (_selectedClass != null)
              ManageStudentsWidget(
                  searchProvider: searchProvider, classProvider: classProvider),
            if (_selectedClass != null)
              ElevatedButton(
                  onPressed: () {
                    classProvider.updateClassStudents();
                    Navigator.pop(context);
                  },
                  child: const Text('Ajouter étudiants à la classe'))
          ],
        ),
      ),
    );
  }
}
