import 'package:flutter/material.dart';

import '../providers/provider_user_acftif.dart';

class WidgetInfo extends StatelessWidget {
  const WidgetInfo({
    super.key,
    required this.userInfo,
    required this.snapshot,
  });

  final ProviderUserinfo userInfo;
  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return const Center(child: Text("Erreur"));
    }
    var data = snapshot.data;

    // if (data == null) {
    //   return const Center(
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.white,
    //     ),
    //   );
    // }

    return Center(
      child: Column(
        children: [
          // inserer l image de l utilisateur
          const Text(
            "Profil",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    if (data != null && data.containsKey("image_url"))
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(data["image_url"]!),
                      ),
                    const SizedBox(height: 20),
                    if (data != null &&
                        data.containsKey("nom") &&
                        data.containsKey("prenom"))
                      Text(
                        "${data["nom"]} ${data["prenom"]}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (data != null && data.containsKey("courriel"))
                      Text(
                        "${data["courriel"]}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 10),
                    if (data != null && data.containsKey("matricule"))
                      Text(
                        "${data["matricule"]}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetModify extends StatelessWidget {
  final ProviderUserinfo userInfo;
  final AsyncSnapshot<dynamic> snapshot;
  final TextEditingController nomController;
  final TextEditingController prenomController;
  final TextEditingController matriculeController;

  const WidgetModify({
    super.key,
    required this.userInfo,
    required this.snapshot,
    required this.nomController,
    required this.prenomController,
    required this.matriculeController,
  });

  @override
  Widget build(BuildContext context) {
    var data = snapshot.data;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (data != null && data.containsKey("image_url"))
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(data["image_url"]!),
              ),
            const Text(
              "Modification du profil",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text("${data["nom"]}"),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Nom",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: nomController,
                    ),
                    const SizedBox(height: 20),
                    Text("${data["prenom"]}"),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Prénom",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: prenomController,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        userInfo.updateUserInfo({
                          "nom": nomController.text,
                          "prenom": prenomController.text,
                        });
                        userInfo.setPageInfo(!userInfo.isPageInfo);
                      },
                      child: const Text("Enregistrer"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
