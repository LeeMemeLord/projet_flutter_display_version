import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider_search.dart';

enum SearchType {
  // ignore: constant_identifier_names
  Email,
  // ignore: constant_identifier_names
  Matricule,
  // ignore: constant_identifier_names
  NomPrenom,
}

class SearchWidget extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  const SearchWidget({super.key, required this.userInfo});

  @override
  // ignore: library_private_types_in_public_api
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  SearchType _searchType = SearchType.NomPrenom;

  @override
  void initState() {
    super.initState();
    var searchProvider = Provider.of<ProviderSearch>(context, listen: false);
    searchProvider.fetchSearchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    var searchProvider = Provider.of<ProviderSearch>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          DropdownButton<SearchType>(
            value: _searchType,
            onChanged: (newValue) {
              setState(() {
                _searchType = newValue!;
              });
            },
            items: SearchType.values.map((type) {
              return DropdownMenuItem<SearchType>(
                value: type,
                child: Text(_typeToString(type)),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Recherche",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                searchProvider.clearStudentSearch();
              } else {
                if (_searchType == SearchType.Email) {
                  searchProvider.findUserByEmail(value);
                } else if (_searchType == SearchType.Matricule) {
                  searchProvider.findUserByMatricule(value);
                } else if (_searchType == SearchType.NomPrenom) {
                  searchProvider.findUserByNomPrenom(value);
                }
              }
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: searchProvider.currentStudentSearch.length,
              itemBuilder: (context, index) {
                var user = searchProvider.currentStudentSearch[index];
                if (user['type_user'] != 'Admin') {
                  return ListTile(
                    leading: Text(user['matricule']),
                    title: Text('${user['nom']} ${user['prenom']}'),
                    subtitle: Text(user['courriel']),
                    trailing: Text(user['type_user']),
                    onTap: () {
                      _showUserInfoDialog(context, user, widget.userInfo);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUserInfoDialog(BuildContext context, Map<String, dynamic> user,
      Map<String, dynamic> userInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${user['nom']} ${user['prenom']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(user['image_url']),
                  ),
                ),
                const SizedBox(height: 20),
                _buildUserInfoRow('Matricule', user['matricule']),
                _buildUserInfoRow('Nom', user['nom']),
                _buildUserInfoRow('Prénom', user['prenom']),
                _buildUserInfoRow('Courriel', user['courriel']),
                if (widget.userInfo['type_user'] == 'Admin')
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          _modifyUserInfoDialog(context, user);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Modifier'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _modifyUserInfoDialog(BuildContext context, Map<String, dynamic> user) {
    final nomController = TextEditingController(text: user['nom']);
    final prenomController = TextEditingController(text: user['prenom']);
    final courrielController = TextEditingController(text: user['courriel']);
    var searchProvider = Provider.of<ProviderSearch>(context, listen: false);

    List<String> userTypes = ['prof', 'etudiant'];
    String selectedUserType = user['type_user'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Column(
              children: [
                const Text('Modifier'),
                Text('${user['nom']} ${user['prenom']}'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(user['image_url']),
                  ),
                ),
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                  ),
                ),
                TextField(
                  controller: prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                  ),
                ),
                TextField(
                  controller: courrielController,
                  decoration: const InputDecoration(
                    labelText: 'Courriel',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedUserType,
                  items: userTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUserType = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Type user',
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  searchProvider.updateUser({
                    'nom': nomController.text,
                    'prenom': prenomController.text,
                    'courriel': courrielController.text,
                    'type_user':
                        selectedUserType, // Update type_user with the selected value
                    'matricule': user['matricule'],
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _typeToString(SearchType type) {
    switch (type) {
      case SearchType.Email:
        return "Email";
      case SearchType.Matricule:
        return "Matricule";
      case SearchType.NomPrenom:
        return "Nom/Prénom";
      default:
        return "";
    }
  }
}
