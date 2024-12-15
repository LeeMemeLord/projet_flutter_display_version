import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProviderSearch with ChangeNotifier {
  var search = [];
  var currentStudentSearch = [];
  var currentTeacherSearch = [];

  Future<void> fetchSearchAllUsers() async {
    search = [];
    var allUsers =
        await FirebaseFirestore.instance.collection("utilisateurs").get();
    for (var user in allUsers.docs) {
      search.add(user.data());
    }

    notifyListeners();
  }

  void findUserByMatricule(String matricule) {
    if (matricule.isNotEmpty) {
      currentStudentSearch = search
          .where((element) => element["matricule"].contains(matricule))
          .toList();
      notifyListeners();
    }
  }

  void findUserByEmail(String email) {
    if (email.isNotEmpty) {
      currentStudentSearch = search
          .where((element) => element["courriel"].contains(email))
          .toList();
      notifyListeners();
    }
  }

  void findUserByNomPrenom(String nomPrenom) {
    if (nomPrenom.isNotEmpty) {
      currentStudentSearch = search
          .where((element) =>
              element["nom"].contains(nomPrenom) ||
              element["prenom"].contains(nomPrenom))
          .toList();

      notifyListeners();
    } else {
      currentStudentSearch = [];
      notifyListeners();
    }
  }

  void findTeacherByNomPrenom(String nomPrenom) {
    if (nomPrenom.isNotEmpty) {
      currentTeacherSearch = search
          .where((element) =>
              element["nom"].contains(nomPrenom) ||
              element["prenom"].contains(nomPrenom))
          .toList();

      notifyListeners();
    } else {
      currentTeacherSearch = [];
      notifyListeners();
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    var userDoc = await FirebaseFirestore.instance
        .collection("utilisateurs")
        .where("matricule", isEqualTo: user["matricule"])
        .get();
    if (userDoc.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("utilisateurs")
          .doc(userDoc.docs.first.id)
          .update(user);
    }
    await fetchSearchAllUsers();
  }

  void clearStudentSearch() {
    currentStudentSearch = [];
    notifyListeners();
  }

  void clearTeacherSearch() {
    currentTeacherSearch = [];
    notifyListeners();
  }
}
