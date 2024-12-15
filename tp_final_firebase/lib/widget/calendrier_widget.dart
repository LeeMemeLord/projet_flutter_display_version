import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final Map<String, dynamic> calendar;

  const CalendarWidget({
    required this.calendar,
    super.key,
  });

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: calendar.length,
      itemBuilder: (context, index) {
        String date = calendar.keys.toList()[index];
        Map<String, dynamic> dayInfo = calendar[date] ?? {};

        int week = dayInfo['semaine'] ?? 0;
        int weekOfSession = dayInfo['jour_semaine'] ?? 0;
        String special = dayInfo['special'] ?? '';

        String joursdeSemaine = [
          'Dimanche',
          'Lundi',
          'Mardi',
          'Mercredi',
          'Jeudi',
          'Vendredi',
          'Samedi'
        ][weekOfSession];

        Color? colorForSpecial;
        switch (special) {
          case 'C':
            colorForSpecial = Colors.blueAccent.withOpacity(0.5);
            break;
          case 'TP':
            colorForSpecial = Colors.green.withOpacity(0.5);
            break;
          case 'A':
            colorForSpecial = Colors.red.withOpacity(0.5);
            break;
          case 'EUF':
            colorForSpecial = Colors.orange.withOpacity(0.5);
            break;
          case 'EC':
            colorForSpecial = Colors.purple.withOpacity(0.5);
            break;
          case 'PO':
            colorForSpecial = Colors.yellow.withOpacity(0.5);
            break;
          case 'JM':
            colorForSpecial = Colors.pink.withOpacity(0.5);
            break;
          default:
            colorForSpecial = null;
            break;
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: colorForSpecial,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                'Date: $date',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (week != 0) Text('Semaine: $week'),
                  if (week == 0) const Text('Semaine de examen'),
                  Text('Jour de la semaine: $joursdeSemaine'),
                  if (special.isNotEmpty)
                    Center(
                      child: Text(
                        special,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildList(context),
      ),
    );
  }
}
