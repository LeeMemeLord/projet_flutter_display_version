import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_final_firebase/providers/provider_classe.dart';
import 'package:tp_final_firebase/providers/provider_search.dart';
import 'package:tp_final_firebase/widget/create_class_manage_student_widget.dart';
import 'package:tp_final_firebase/widget/create_class_period_widget.dart';
import 'package:tp_final_firebase/widget/widget_class_info.dart';

class CreateClassPage extends StatefulWidget {
  const CreateClassPage({super.key});

  @override
  _CreateClassPageState createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  final _courseNumberController = TextEditingController();
  final _groupNumberController = TextEditingController();
  final _teacherController = TextEditingController();
  final _periods = <Period>[];
  String _teacher = '';

  void _setTeacher(String teacher) {
    setState(() {
      _teacher = _teacher != teacher ? teacher : '';
    });
  }

  void _removePeriod(int index) {
    setState(() {
      _periods.removeAt(index);
    });
  }

  void _addPeriod() {
    setState(() {
      _periods.add(Period(
        day: 'Lundi',
        startTime: TimeOfDay(hour: 8, minute: 0),
        endTime: TimeOfDay(hour: 10, minute: 0),
      ));
    });
    Provider.of<ProviderClasse>(context, listen: false).addPeriod(
      day: 'Lundi',
      startTime: '08:00',
      endTime: '10:00',
    );
  }

  @override
  Widget build(BuildContext context) {
    var searchProvider = Provider.of<ProviderSearch>(context);
    var classProvider = Provider.of<ProviderClasse>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une classe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetClassInfo(
                courseNumberController: _courseNumberController,
                groupNumberController: _groupNumberController,
                teacherController: _teacherController,
                searchProvider: searchProvider,
                classProvider: classProvider,
                teacher: _teacher,
                onTeacherChange: _setTeacher,
              ),
              Column(
                children: _periods.asMap().entries.map((entry) {
                  final index = entry.key;
                  return PeriodWidget(
                    key: ValueKey(index),
                    index: index,
                    classProvider: classProvider,
                    onRemove: _removePeriod,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _addPeriod,
                  child: const Text('Ajouter une période de cours'),
                ),
              ),
              const SizedBox(height: 16.0),
              ManageStudentsWidget(
                searchProvider: searchProvider,
                classProvider: classProvider,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    classProvider.createClass();
                  },
                  child: const Text('Créer une classe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
