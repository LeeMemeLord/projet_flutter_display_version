import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProviderCalendar with ChangeNotifier {
  Map<String, dynamic> calender = {};
  // URL de l'API pour récupérer les informations du calendrier
  static const String _calendarUrl =
      'https://us-central1-cegep-al.cloudfunctions.net/calendrier';

  // Méthode pour récupérer les informations du calendrier depuis l'API
  Future<void> fetchCalendarInfo() async {
    try {
      // Appel GET à l'URL de l'API
      final response = await http.get(Uri.parse(_calendarUrl));

      // Vérification du statut de la réponse
      if (response.statusCode == 200) {
        // Conversion de la réponse JSON en map
        calender = json.decode(response.body);
        notifyListeners();
      } else {
        // Gestion des erreurs en cas de réponse invalide
        throw Exception('Failed to load calendar data');
      }
    } catch (e) {
      // Gestion des erreurs génériques
      throw Exception('Error: $e');
    }
  }

  // Exemple de méthode pour accéder aux informations du calendrier
}
