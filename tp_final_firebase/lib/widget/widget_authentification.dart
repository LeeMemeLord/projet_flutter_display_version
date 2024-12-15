import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tp_final_firebase/generated/l10n.dart';
import 'package:tp_final_firebase/widget/image_picker_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthentificationWidget extends StatefulWidget {
  final void Function(
    String matricule,
    String nom,
    String prenom,
    String courriel,
    String motDePasse,
    String typeUser,
    bool estConnecte,
    XFile? image,
  ) _submitAuthentification;
  const AuthentificationWidget(this._submitAuthentification, {super.key});

  @override
  State<AuthentificationWidget> createState() => _AuthentificationWidgetState();
}

class _AuthentificationWidgetState extends State<AuthentificationWidget> {
  final _key = GlobalKey<FormState>();
  String _matricule = '';
  String _nom = '';
  String _prenom = '';
  String _courriel = '';
  String _motDePasse = '';
  final String _typeUser = 'etudiant';
  bool _estConnecte = true;
  // ignore: prefer_typing_uninitialized_variables
  var _myUserImageFile;

  void _myPickImage(XFile pickedImage) {
    _myUserImageFile = pickedImage;
  }

  void _submit() {
    final estValid = _key.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (!_estConnecte && _myUserImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Add an Image"),
        ),
      );
      return;
    }

    if (estValid ?? false) {
      _key.currentState?.save();

      widget._submitAuthentification(
        _matricule,
        _nom,
        _prenom,
        _courriel,
        _motDePasse,
        _typeUser,
        _estConnecte,
        _myUserImageFile,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_estConnecte) UserImagePicker(_myPickImage),
                  if (!_estConnecte)
                    TextFormField(
                      key: const ValueKey('matricule'),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.matriculeLabel),
                      validator: (valeur) {
                        if (valeur!.isEmpty || valeur.length != 7) {
                          return AppLocalizations.of(context)!
                              .matriculeErrorText;
                        }
                        return null;
                      },
                      onSaved: (valeur) {
                        _matricule = valeur!;
                      },
                    ),
                  if (!_estConnecte)
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.nomLabel),
                      key: const ValueKey('nom'),
                      validator: (valeur) {
                        if (valeur!.isEmpty) {
                          return AppLocalizations.of(context)!.nomErrorText;
                        }
                        return null;
                      },
                      onSaved: (valeur) {
                        _nom = valeur!;
                      },
                    ),
                  if (!_estConnecte)
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.prenomLabel),
                      key: const ValueKey('prenom'),
                      validator: (valeur) {
                        if (valeur!.isEmpty) {
                          return AppLocalizations.of(context)!.prenomErrorText;
                        }
                        return null;
                      },
                      onSaved: (valeur) {
                        _prenom = valeur!;
                      },
                    ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.courrielLabel),
                    key: const ValueKey('courriel'),
                    validator: (valeur) {
                      if (valeur!.isEmpty ||
                          !valeur.contains('@') ||
                          !valeur.contains('.')) {
                        return AppLocalizations.of(context)!.courrielErrorText;
                      }
                      return null;
                    },
                    onSaved: (valeur) {
                      _courriel = valeur!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.motDePasseLabel),
                    key: const ValueKey('motDePasse'),
                    obscureText: true,
                    validator: (valeur) {
                      if (valeur!.isEmpty || valeur.length < 6) {
                        return AppLocalizations.of(context)!
                            .motDePasseErrorText;
                      }
                      return null;
                    },
                    onSaved: (valeur) {
                      _motDePasse = valeur!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: (() {
                      _submit();
                    }),
                    child: Text(_estConnecte
                        ? AppLocalizations.of(context)!.connectButtonLabel
                        : AppLocalizations.of(context)!.inscriptionButtonLabel),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _estConnecte = !_estConnecte;
                      });
                    },
                    child: Text(
                      _estConnecte
                          ? AppLocalizations.of(context)!.createAccountLabel
                          : AppLocalizations.of(context)!
                              .alreadyHaveAccountLabel,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
