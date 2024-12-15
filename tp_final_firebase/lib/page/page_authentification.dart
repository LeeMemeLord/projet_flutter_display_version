import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widget/widget_authentification.dart';

class PageAuthentification extends StatefulWidget {
  const PageAuthentification({super.key});

  @override
  State<PageAuthentification> createState() => _PageAuthentificationState();
}

class _PageAuthentificationState extends State<PageAuthentification> {
  final auth = FirebaseAuth.instance;

  

  Future<void> _submitAuthentification(
    String matricule,
    String nom,
    String prenom,
    String courriel,
    String motDePasse,
    String typeUser,
    bool estConnecte,
    XFile? image,
  ) async {
    UserCredential resultat;
    try {
      if (estConnecte) {
        resultat = await auth.signInWithEmailAndPassword(
          email: courriel,
          password: motDePasse,
        );
      } else {
        resultat = await auth.createUserWithEmailAndPassword(
          email: courriel,
          password: motDePasse,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child('${resultat.user!.uid}.jpg');

        await ref.putFile(File(image!.path)).whenComplete((() => true));

        final myUserImageLink = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("utilisateurs")
            .doc(resultat.user!.uid)
            .set({
          "matricule": matricule,
          "nom": nom,
          "prenom": prenom,
          "courriel": courriel,
          "type_user": typeUser,
          "image_url": myUserImageLink,
        });
      }
    } on FirebaseAuthException catch (e) {
      var message = "Une erreur s'est produite.";

      if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (err) {
      print("Erreur non géré $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthentificationWidget(_submitAuthentification),
    );
  }
}
