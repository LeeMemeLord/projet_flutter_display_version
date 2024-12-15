import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_final_firebase/widget/class_dropdown_widget.dart';

import '../providers/provider_classe.dart';
import '../providers/provider_search.dart';

class AssignTeacherPage extends StatefulWidget {
  const AssignTeacherPage({super.key});

  @override
  State<AssignTeacherPage> createState() => _AssignTeacherPageState();
}

class _AssignTeacherPageState extends State<AssignTeacherPage> {
  final _teacherController = TextEditingController();

  String? _selectedClass;

  @override
  Widget build(BuildContext context) {
    var classProvider = Provider.of<ProviderClasse>(context);
    var searchProvider = Provider.of<ProviderSearch>(context);
    var classes = classProvider.getAllClasses();

    void assignTeacher() {
      classProvider.updateClassTeacher(_teacherController.text);
      Navigator.pop(context);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Assigner un enseignant à une classe'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                TextField(
                  controller: _teacherController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'enseignant',
                  ),
                  onChanged: (value) {
                    searchProvider.findTeacherByNomPrenom(value);
                  },
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: assignTeacher, child: const Text('Assigner')),
              if (searchProvider.currentTeacherSearch.isNotEmpty)
                Column(
                  children: [
                    for (var teacher in searchProvider.currentTeacherSearch)
                      if (teacher['type_user'] == 'prof' &&
                          classProvider.currentClass['teacher'] !=
                              teacher['nom'] + ' ' + teacher['prenom'])
                        ListTile(
                          title: Text(teacher['nom']),
                          subtitle: Text(teacher['prenom']),
                          onTap: () {
                            setState(() {
                              _teacherController.text =
                                  '${teacher['nom']} ${teacher['prenom']}';
                              searchProvider.currentTeacherSearch.clear();
                            });
                          },
                        ),
                  ],
                ),
            ],
          ),
        ));
  }
}
