import 'package:flutter/material.dart';
import 'package:tp_final_firebase/providers/provider_classe.dart';

class Period {
  TextEditingController dayController;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Period({
    required String day,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  })  : dayController = TextEditingController(text: day),
        startTime = startTime,
        endTime = endTime;
}

class PeriodWidget extends StatefulWidget {
  final int index;
  final void Function(int) onRemove;
  final ProviderClasse classProvider;

  const PeriodWidget({
    super.key,
    required this.index,
    required this.onRemove,
    required this.classProvider,
  });

  @override
  _PeriodWidgetState createState() => _PeriodWidgetState();
}

class _PeriodWidgetState extends State<PeriodWidget> {
  late Period period;
  final List<String> days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'];

  @override
  void initState() {
    super.initState();
    final periodData = widget.classProvider.classe['periods'][widget.index];
    period = Period(
      day: periodData['day'] ?? days[0],
      startTime: TimeOfDay(
        hour: int.parse(periodData['startTime'].split(":")[0]),
        minute: int.parse(periodData['startTime'].split(":")[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(periodData['endTime'].split(":")[0]),
        minute: int.parse(periodData['endTime'].split(":")[1]),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      ValueChanged<TimeOfDay> onTimeChanged) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != initialTime) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Période ${widget.index + 1}: '),
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: period.dayController.text,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      period.dayController.text = newValue;
                      widget.classProvider
                          .setDayForPeriod(widget.index, newValue);
                    });
                  }
                },
                items: days.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(width: 8), // Add spacing between elements
            Expanded(
              child: TextButton(
                onPressed: () {
                  _selectTime(context, period.startTime, (picked) {
                    setState(() {
                      period.startTime = picked;
                      widget.classProvider.setStartTimeForPeriod(
                          widget.index, picked.format(context));
                    });
                  });
                },
                child: Text('Début: ${period.startTime.format(context)}'),
              ),
            ),
            SizedBox(width: 8), // Add spacing between elements
            Expanded(
              child: TextButton(
                onPressed: () {
                  _selectTime(context, period.endTime, (picked) {
                    setState(() {
                      period.endTime = picked;
                      widget.classProvider.setEndTimeForPeriod(
                          widget.index, picked.format(context));
                    });
                  });
                },
                child: Text('Fin: ${period.endTime.format(context)}'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                widget.onRemove(widget.index);
                widget.classProvider.removePeriod(widget.index);
              },
            ),
          ],
        ),
      ],
    );
  }
}
