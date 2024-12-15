import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProviderUserinfo with ChangeNotifier {
  var userInfo = {
    "uid": "",
    "matricule": "",
    "nom": "",
    "prenom": "",
    "courriel": "",
    "type_user": "",
    "image_url":
        "https://firebasestorage.googleapis.com/v0/b/gestion-cours-tpf.appspot.com/o/user_image%2F360_F_329177878_ij7ooGdwU9EKqBFtyJQvWsDmYSfI1evZ.jpg?alt=media&token=b044625c-f4ce-40e8-9194-fc162ca9e8ab",
  };

  var isPageInfo = true;

  Future<void> fetchUserInfo() async {
    final value = await FirebaseFirestore.instance
        .collection("utilisateurs")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (value.exists) {
      userInfo["uid"] = FirebaseAuth.instance.currentUser!.uid;
      userInfo["matricule"] = value.data()!["matricule"];
      userInfo["nom"] = value.data()!["nom"];
      userInfo["prenom"] = value.data()!["prenom"];
      userInfo["courriel"] = value.data()!["courriel"];
      userInfo["type_user"] = value.data()!["type_user"];
      userInfo["image_url"] = value.data()!["image_url"];
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    return userInfo;
  }

  Future updateUserInfo(Map<String, dynamic> data) async {
    if (data.containsKey("nom") && data["nom"] == "") {
      data.remove("nom");
    }
    if (data.containsKey("prenom") && data["prenom"] == "") {
      data.remove("prenom");
    }

    await FirebaseFirestore.instance
        .collection("utilisateurs")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);

    await fetchUserInfo();
    setPageInfo(true);
  }

  void setPageInfo(bool value) {
    isPageInfo = value;
    notifyListeners();
  }

  void setImg(String img) {
    userInfo["image_url"] = img;
    notifyListeners();
  }

  void clearUserInfo() {
    userInfo = {
      "uid": "",
      "matricule": "",
      "nom": "",
      "prenom": "",
      "courriel": "",
      "type_user": "",
      "image_url":
          "https://firebasestorage.googleapis.com/v0/b/gestion-cours-tpf.appspot.com/o/user_image%2F360_F_329177878_ij7ooGdwU9EKqBFtyJQvWsDmYSfI1evZ.jpg?alt=media&token=b044625c-f4ce-40e8-9194-fc162ca9e8ab",
    };
    notifyListeners();
  }
}
