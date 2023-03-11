import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miaged_project/signUp.dart';

import 'home.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffce77ec),Color(0xffffffff)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 50.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.red,
                  ],
                )),
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Bienvenue dans Miaged Application !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient,

                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Colors.white, size: 120),

                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    validator: validateTextField,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_2_sharp),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: validateTextField,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
    try {
    final User? user = (await _firebaseAuth.signInWithEmailAndPassword(
    email: _usernameController.text.trim(),
    password: _passwordController.text.trim()))
        .user;
    if (user != null) {
    Fluttertoast.showToast(msg: "Signed In Sucessfully");
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => home()),
    );
    };
    } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    }
    },

                  child: Text('Se connecter'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => signUp()));
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Couleur du texte
                    textStyle: TextStyle(fontSize: 15.0), // Taille du texte
                  ),
                  child: Text('Vous n\'avez pas encore un compte ? Créez-le maintenant !'),

                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
  String? validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }

}