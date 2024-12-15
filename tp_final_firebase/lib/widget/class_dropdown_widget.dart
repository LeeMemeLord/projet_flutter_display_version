import 'package:flutter/material.dart';

class ClassDropdown extends StatelessWidget {
  final String? selectedClass;
  final List<dynamic> classes;
  final Function(String?) onChanged;

  const ClassDropdown({
    super.key,
    required this.selectedClass,
    required this.classes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedClass,
      hint: const Text('Sélectionnez une classe'),
      onChanged: onChanged,
      items: classes.map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value['courseNumber'],
          // ignore: prefer_interpolation_to_compose_strings
          child: Text('${"Num groupe: " + value['groupNumber']} - Matricule:' +
              value['teacher']),
        );
      }).toList(),
    );
  }
}
