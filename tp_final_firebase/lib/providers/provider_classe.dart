import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProviderClasse with ChangeNotifier {
  var allCurentClasses = [];
  var teacherClasses = [];
  var currentClass;
  var selectedClasse = "";

  Map<String, dynamic> classe = {
    'courseNumber': '',
    'groupNumber': '',
    'teacher': '',
    'periods': [],
    'students': [],
  };

  // Ajoute une période de cours à la liste des périodes
  void addPeriod({
    required String day,
    required String startTime,
    required String endTime,
  }) {
    classe['periods'].add({
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    });
    notifyListeners();
  }

  void addAPeriod() {
    classe['periods'].add({
      'day': '',
      'startTime': '',
      'endTime': '',
    });
    notifyListeners();
  }

  void setSelectedClasse(String? classe) {
    selectedClasse = classe ?? "";

    currentClass = allCurentClasses
        .firstWhere((element) => element['courseNumber'] == selectedClasse);
    notifyListeners();
  }

  // Supprime une période de cours à partir de son index dans la liste
  void removePeriod(int index) {
    if (index >= 0 && index < classe['periods'].length) {
      classe['periods'].removeAt(index);
      notifyListeners();
    }
    notifyListeners();
  }

  // Définit l'enseignant pour la classe
  void setTeacher(String teacher) {
    classe['teacher'] = teacher;
    notifyListeners();
  }

  // Définit le numéro de cours
  void setCourseNumber(String courseNumber) {
    classe['courseNumber'] = courseNumber;
    notifyListeners();
  }

  // Définit le numéro de groupe
  void setGroupNumber(String groupNumber) {
    classe['groupNumber'] = groupNumber;
    notifyListeners();
  }

  // Définit le jour de la semaine pour une période de cours spécifique
  void setDayForPeriod(int periodIndex, String day) {
    if (periodIndex >= 0 && periodIndex < classe['periods'].length) {
      classe['periods'][periodIndex]['day'] = day;
      notifyListeners();
    }
  }

  // Définit l'heure de début pour une période de cours spécifique
  void setStartTimeForPeriod(int periodIndex, String startTime) {
    if (periodIndex >= 0 && periodIndex < classe['periods'].length) {
      classe['periods'][periodIndex]['startTime'] = startTime;
      notifyListeners();
    }
  }

  // Définit l'heure de fin pour une période de cours spécifique
  void setEndTimeForPeriod(int periodIndex, String endTime) {
    if (periodIndex >= 0 && periodIndex < classe['periods'].length) {
      classe['periods'][periodIndex]['endTime'] = endTime;
      notifyListeners();
    }
  }

  // Supprime un étudiant de la liste des étudiants inscrits
  void removeStudent(int index) {
    classe['students'].removeAt(index);
    notifyListeners();
  }

  // Ajoute un étudiant à la liste des étudiants inscrits
  void addStudent(String studentName) {
    if (!classe['students'].contains(studentName)) {
      classe['students'].add(studentName);
      notifyListeners();
    } else {
      removeStudent(classe['students'].indexOf(studentName));
    }
    print(classe['students']);
  }

  // Réinitialise toutes les données de la classe
  void clear() {
    classe = {
      'courseNumber': '',
      'groupNumber': '',
      'teacher': '',
      'periods': [],
      'students': [],
    };
    notifyListeners();
  }

  // Obtient les données de la classe
  Map<String, dynamic> getClasse() {
    return classe;
  }

  // Crée une classe dans la base de données Firestore
  Future<void> createClass() async {
    if (classe['courseNumber'] == '' ||
        classe['groupNumber'] == '' ||
        classe['teacher'] == '' ||
        classe['periods'].isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection("classes")
        .doc(classe['courseNumber'])
        .set(classe);
    clear();
  }

  Future<void> updateClassPeriod() async {
    if (classe['periods'].isEmpty) {
      return;
    }

    if (currentClass['periods'] is List) {
      var existingPeriods =
          List<Map<String, dynamic>>.from(currentClass['periods']);
      var newPeriods = List<Map<String, dynamic>>.from(classe['periods']);

      var updatedPeriods = existingPeriods..addAll(newPeriods);

      currentClass['periods'] = updatedPeriods;

      await FirebaseFirestore.instance
          .collection("classes")
          .doc(currentClass['courseNumber'])
          .update({'periods': updatedPeriods});

      clear();

      notifyListeners();
    }
  }

  Future<void> fetchAllClasses() async {
    final classes =
        await FirebaseFirestore.instance.collection("classes").get();
    allCurentClasses = classes.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  List<dynamic> getAllClasses() {
    return allCurentClasses;
  }

  Future<void> updateClassTeacher(String text) async {
    if (currentClass['teacher'] != text) {
      await FirebaseFirestore.instance
          .collection("classes")
          .doc(currentClass['courseNumber'])
          .update({'teacher': text});
      clear();
      fetchAllClasses();
      notifyListeners();
    }
  }

  Future<void> updateClassStudents() async {
    currentClass['students'].addAll(classe['students']);
    await FirebaseFirestore.instance
        .collection("classes")
        .doc(currentClass['courseNumber'])
        .update({'students': currentClass['students']});
    clear();
    fetchAllClasses();
    notifyListeners();
  }

  Future<void> getTeacherClasses(String matricule) async {
    teacherClasses = allCurentClasses
        .where((element) => element['teacher'] == matricule)
        .toList();
  }

  get getTeacherClassesList {
    return teacherClasses;
  }
}
