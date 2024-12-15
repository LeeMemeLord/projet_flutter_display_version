import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider_classe.dart';
import '../widget/class_dropdown_widget.dart';
import '../widget/create_class_period_widget.dart';

class AddDayPeriodPage extends StatefulWidget {
  const AddDayPeriodPage({Key? key}) : super(key: key);

  @override
  _AddDayPeriodPageState createState() => _AddDayPeriodPageState();
}

class _AddDayPeriodPageState extends State<AddDayPeriodPage> {
  final _periods = <Period>[];
  String? _selectedClass;

  @override
  Widget build(BuildContext context) {
    var classProvider = Provider.of<ProviderClasse>(context);
    var classes = classProvider.getAllClasses();

    void _addPeriod() {
      setState(() {
        _periods.add(Period(
          day: 'Lundi',
          startTime: TimeOfDay(hour: 8, minute: 0),
          endTime: TimeOfDay(hour: 10, minute: 0),
        ));
      });
      classProvider.addPeriod(
          day: 'Lundi', startTime: '08:00', endTime: '10:00');
    }

    void _removePeriod(int index) {
      setState(() {
        _periods.removeAt(index);
      });
      classProvider.removePeriod(index);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter période à une classe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClassDropdown(
              selectedClass: _selectedClass,
              classes: classes,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClass = newValue;
                  classProvider.setSelectedClasse(newValue);
                });
              },
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
            if (_selectedClass != null)
              Center(
                child: ElevatedButton(
                  onPressed: _addPeriod,
                  child: const Icon(
                    Icons.add,
                    color: Colors.amber,
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            if (_selectedClass != null)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    classProvider.updateClassPeriod();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ajouter période de cours',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
