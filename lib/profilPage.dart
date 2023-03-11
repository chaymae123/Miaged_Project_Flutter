import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'login.dart';

class profilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<profilPage> {
  final _formKey = GlobalKey<FormState>();

  // Définissez des variables pour stocker les informations de l'utilisateur
  late String _login;
  late String _password;
  late DateTime _anniversaire;
  late TextEditingController _anniversaireController;
  late String _adresse;
  late int _codePostal;
  late String _ville;
  bool _isLoading = true;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xff2281ec),Color(0xff181818)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 50.0));

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  // Utilisez Firebase pour récupérer les informations de l'utilisateur
  Future<void> getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        _login = data['login'] ?? '';
        _password = data['password'] ?? '';
        _anniversaire = data['anniversaire']?.toDate() ?? DateTime.now();
        _anniversaireController =
            TextEditingController(text: _anniversaire.toString());
        _adresse = data['adresse'] ?? '';
        _codePostal = data['codePostal'] ?? 0;
        _ville = data['ville'] ?? '';
        _isLoading = false;
      });
    } else {
      print('Document does not exist on the database');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Modifiez Votre profil!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient,

                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Colors.black, size: 120),

                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Login'),
                  initialValue: _login,
                  readOnly: true,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  initialValue: _password,
                  obscureText: true,
                  onChanged: (val) => _password = val,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Anniversaire'),
                  controller: _anniversaireController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _anniversaire,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        _anniversaire = date;
                        _anniversaireController.text =
                            _anniversaire.toString();
                      });
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Adresse'),
                  initialValue: _adresse,
                  onChanged: (val) => _adresse = val,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Code Postal'),
                  keyboardType: TextInputType.number,
                  initialValue: _codePostal != null ? '$_codePostal' : '',
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (val) =>
                  _codePostal = (val.isNotEmpty ? int.parse(val) : null)!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Ville'),
                  initialValue: _ville,
                  onChanged: (val) => _ville = val,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Valider'),
                  onPressed: () async {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      User? user = FirebaseAuth.instance.currentUser;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .update({
                        'password': _password,
                        'anniversaire': _anniversaire,
                        'adresse': _adresse,
                        'codePostal': _codePostal,
                        'ville': _ville,
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Se déconnecter'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}