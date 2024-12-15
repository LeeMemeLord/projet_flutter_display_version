import 'package:flutter/material.dart';
import 'package:tp_final_firebase/providers/provider_classe.dart';

import '../providers/provider_search.dart';

class WidgetClassInfo extends StatefulWidget {
  final TextEditingController courseNumberController;
  final TextEditingController groupNumberController;
  final TextEditingController teacherController;
  final ProviderSearch searchProvider;
  final String teacher;
  final ProviderClasse classProvider;
  final void Function(String teacher) onTeacherChange;

  const WidgetClassInfo({
    super.key,
    required this.courseNumberController,
    required this.groupNumberController,
    required this.teacherController,
    required this.searchProvider,
    required this.teacher,
    required this.onTeacherChange,
    required this.classProvider,
  });

  @override
  State<WidgetClassInfo> createState() => _WidgetClassInfoState();
}

class _WidgetClassInfoState extends State<WidgetClassInfo> {
  @override
  Widget build(BuildContext context) {
    bool isModifying = false;
    void setModifying(bool value) {
      setState(() {
        isModifying = value;
      });
    }

    bool isTeacher = false;
    void setIsTeacher(bool value) {
      setState(() {
        isTeacher = value;
      });
    }

    return Column(
      children: [
        TextField(
          controller: widget.courseNumberController,
          decoration: const InputDecoration(
            labelText: 'Numéro du cours',
          ),
          onChanged: (value) {
            widget.classProvider.setCourseNumber(value);
          },
        ),
        TextField(
          controller: widget.groupNumberController,
          decoration: const InputDecoration(
            labelText: 'Numéro du groupe',
          ),
          onChanged: (value) {
            widget.classProvider.setGroupNumber(value);
          },
        ),
        // Conditionally display the teacher field based on the 'isTeacher' flag
        if (!isTeacher)
          TextField(
            controller: widget.teacherController,
            decoration: const InputDecoration(
              labelText: 'Enseignant',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setModifying(true);
              } else {
                setModifying(false);
              }
              widget.searchProvider.findTeacherByNomPrenom(value);
            },
            onSubmitted: (value) {
              setIsTeacher(true);
              widget.teacherController.text =
                  widget.searchProvider.currentTeacherSearch[0]['nom'] +
                      ' ' +
                      widget.searchProvider.currentTeacherSearch[0]['prenom'];
            },
          ),

        // Conditionally display search results for teachers only if 'isTeacher' is false
        if (!isTeacher &&
            widget.searchProvider.currentTeacherSearch.isNotEmpty &&
            !isModifying)
          Column(
            children: widget.searchProvider.currentTeacherSearch.map((user) {
              if (user['type_user'] == 'prof') {
                return ListTile(
                  leading: widget.teacher == user['nom'] + ' ' + user['prenom']
                      ? const Icon(Icons.check)
                      : null,
                  title: Text('${user['nom']} ${user['prenom']}'),
                  subtitle: Text(user['courriel']),
                  onTap: () {
                    widget.onTeacherChange(user['nom'] + ' ' + user['prenom']);
                    widget.classProvider.setTeacher(user['matricule']);
                  },
                );
              } else {
                return const SizedBox();
              }
            }).toList(),
          ),
        // Add other elements if needed
      ],
    );
  }
}
