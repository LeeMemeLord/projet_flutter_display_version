import 'package:flutter/material.dart';
import 'package:tp_final_firebase/providers/provider_classe.dart';
import '../providers/provider_search.dart';

class ManageStudentsWidget extends StatefulWidget {
  final ProviderSearch searchProvider;
  final ProviderClasse classProvider;

  const ManageStudentsWidget(
      {super.key, required this.searchProvider, required this.classProvider});

  @override
  // ignore: library_private_types_in_public_api
  _ManageStudentsWidgetState createState() => _ManageStudentsWidgetState();
}

class _ManageStudentsWidgetState extends State<ManageStudentsWidget> {
  final List<String> _students = [];
  bool _modifying = false;
  // ignore: prefer_final_fields
  TextEditingController _searchController = TextEditingController();

  void _addStudent(String studentName) {
    if (!_students.contains(studentName)) {
      setState(() {
        _students.add(studentName);
      });
    } else {
      _removeStudent(_students.indexOf(studentName));
    }
  }

  void _removeStudent(int index) {
    setState(() {
      _students.removeAt(index);
    });
  }

  void setModifying(bool value) {
    setState(() {
      _modifying = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Inscrire des étudiants',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Liste des étudiants'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _students.map((student) {
                          return ListTile(
                            title: Text(student),
                          );
                        }).toList(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Voir la liste'),
            ),
          ],
        ),
        TextField(
          controller: _searchController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setModifying(true);
              widget.searchProvider.findUserByNomPrenom(value);
            } else {
              setModifying(false);
            }
          },
          decoration: const InputDecoration(
            labelText: 'Rechercher un étudiant',
          ),
          onSubmitted: (value) {
            _searchController.clear();
            widget.searchProvider.currentStudentSearch.clear();
          },
        ),
        if (_modifying)
          Column(
            children: widget.searchProvider.currentStudentSearch.map((user) {
              if (user['type_user'] != 'prof' && user['type_user'] != 'Admin') {
                return ListTile(
                  leading:
                      _students.contains(user['nom'] + ' ' + user['prenom'])
                          ? const Icon(Icons.check)
                          : null,
                  title: Text('${user['nom']} ${user['prenom']}'),
                  subtitle: Text(user['courriel']),
                  onTap: () {
                    _addStudent(user['nom'] + ' ' + user['prenom']);
                    widget.classProvider
                        .addStudent(user['nom'] + ' ' + user['prenom']);
                  },
                );
              } else {
                return const SizedBox();
              }
            }).toList(),
          ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
