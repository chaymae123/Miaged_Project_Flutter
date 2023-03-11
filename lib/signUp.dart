
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';

class signUp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confpasswordController = TextEditingController();
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffce77ec),Color(0xffffffff)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 50.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  'Créer un compte !',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Colors.white, size: 50),

                ),
                const SizedBox(height: 20),
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
                    controller: _emailController,
                    validator: validateTextField,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Courriel éléctronique',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _teleController,
                    validator: validateTextField,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Numéro de téléphone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: validateTextField,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _confpasswordController,
                    validator: validateTextField,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Confirmez votre Password',
                      prefixIcon: Icon(Icons.lock_clock),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text('S inscrire'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  onPressed:() async{ String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  String confirmpassword = _confpasswordController.text.trim();
                  if (password == confirmpassword) {
                    try {
                      final User? user = (await _auth.createUserWithEmailAndPassword(
                      email: email, password: password))
                        .user;
                    if (user != null) {
                    Fluttertoast.showToast(msg: "user created");
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => home()) ,

                    );
                    }
                    } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                    print(e);
                    }
                    } else {
                    Fluttertoast.showToast(msg: "Passwords don't match");
                    }}

                  ),

                SizedBox(height: 20.0),

                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Couleur du texte
                    textStyle: TextStyle(fontSize: 15.0), // Taille du texte
                  ),
                  child: Text('Vous avez déjà un compte ? Connectez vous!'),

                ),


              ],
            ),
          ),
        ),
      ),
    ));

  }
  String? validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }
  /*void signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmpassword = _confpasswordController.text.trim();
    if (password == confirmpassword) {
      try {
        final User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
            .user;
        if (user != null) {
          Fluttertoast.showToast(msg: "user created");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => home()) ,

          );
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        print(e);
      }
    } else {
      Fluttertoast.showToast(msg: "Passwords don't match");
    }
  }*/

}