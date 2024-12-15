import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider_classe.dart';

class TeacherClassManagementPage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const TeacherClassManagementPage({Key? key, required this.userInfo})
      : super(key: key);

  @override
  State<TeacherClassManagementPage> createState() =>
      _TeacherClassManagementPageState();
}

class _TeacherClassManagementPageState
    extends State<TeacherClassManagementPage> {
  late Future<void> _futureClasses;

  @override
  void initState() {
    super.initState();
    _futureClasses = _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    var classProvider = Provider.of<ProviderClasse>(context, listen: false);
    await classProvider.getTeacherClasses(widget.userInfo['matricule']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vos Classes'),
      ),
      body: FutureBuilder<void>(
        future: _futureClasses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Une erreur est survenue.'));
          } else {
            return Consumer<ProviderClasse>(
              builder: (context, classProvider, child) {
                var teacherClasses = classProvider.teacherClasses;
                return ListView.builder(
                  itemCount: teacherClasses.length,
                  itemBuilder: (context, index) {
                    var teacherClass = teacherClasses[index];
                    return ListTile(
                      title: Text(
                          "Nom de la classe: ${teacherClass['courseNumber']}"),
                      subtitle: Text("Groupe: ${teacherClass['groupNumber']}"),
                      trailing: const Icon(Icons.arrow_forward_ios),

                      // Customize the title as needed
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassGestionPage(
                              teacherClass: teacherClass,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ClassGestionPage extends StatelessWidget {
  final Map<String, dynamic> teacherClass;

  const ClassGestionPage({Key? key, required this.teacherClass})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion de la classe ${teacherClass['courseNumber']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text('Course Number: ${teacherClass['courseNumber']}'),
                leading: const Icon(Icons.book),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text('Group Number: ${teacherClass['groupNumber']}'),
                leading: const Icon(Icons.group),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Periods:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...teacherClass['periods'].map<Widget>((period) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                      'Day: ${period['day']}, Start: ${period['startTime']}, End: ${period['endTime']}'),
                  leading: const Icon(Icons.schedule),
                ),
              );
            }).toList(),
            const SizedBox(height: 16.0),
            const Text(
              'Students:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...teacherClass['students'].map<Widget>((student) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(student),
                  leading: const Icon(Icons.person),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
