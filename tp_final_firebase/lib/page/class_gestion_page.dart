import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider_classe.dart';

class ClassManagementPage extends StatefulWidget {
  const ClassManagementPage({super.key});

  @override
  State<ClassManagementPage> createState() => _ClassManagementPageState();
}

class _ClassManagementPageState extends State<ClassManagementPage> {
  @override
  void initState() {
    super.initState();
    var classProvider = Provider.of<ProviderClasse>(context, listen: false);
    classProvider.fetchAllClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
                child: Text('Gestion des classes',
                    style: TextStyle(fontSize: 24.0))),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createClass');
              },
              child: const Text(
                'Créer une classe',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addDayPeriod');
              },
              child: const Text(
                'Ajouter jour/période à une classe',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/assignTeacher');
              },
              child: const Text(
                'Assigner un enseignant à une classe',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/assignStudent');
              },
              child: const Text(
                'Assigner un étudiant à une classe',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
