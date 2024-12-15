import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider_user_acftif.dart';
import 'info_modification.dart';

class InfoUserWidget extends StatefulWidget {
  const InfoUserWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InfoUserWidgetState createState() => _InfoUserWidgetState();
}

class _InfoUserWidgetState extends State<InfoUserWidget> {
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController courrielController = TextEditingController();
  TextEditingController matriculeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var userInfo = Provider.of<ProviderUserinfo>(context, listen: false);
    nomController.text = userInfo.userInfo["nom"] ?? '';
    prenomController.text = userInfo.userInfo["prenom"] ?? '';
    courrielController.text = userInfo.userInfo["courriel"] ?? '';
    matriculeController.text = userInfo.userInfo["matricule"] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<ProviderUserinfo>(context, listen: true);
    

    return FutureBuilder(
      future: userInfo.getUserInfo(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return Scaffold(
          body: userInfo.isPageInfo
              ? WidgetInfo(userInfo: userInfo, snapshot: snapshot)
              : WidgetModify(
                  userInfo: userInfo,
                  snapshot: snapshot,
                  nomController: nomController,
                  prenomController: prenomController,
                  matriculeController: matriculeController,
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                userInfo.setPageInfo(!userInfo.isPageInfo);
              });
            },
            child: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
