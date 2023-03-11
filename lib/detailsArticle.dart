import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class detailsArticle extends StatefulWidget {
  late final DocumentSnapshot article;
  detailsArticle({required this.article});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<detailsArticle> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffffffff),Color(0xff04fcb1)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 50.0));
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Miaged Shop', style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,   foreground: Paint()..shader = linearGradient,)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              widget.article['image'],
              fit: BoxFit.cover,
              width:400,
              
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.article['titre'],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Taille: ${widget.article['taille']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Marque: ${widget.article['marque']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Prix: ${widget.article['prix']}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Retour'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                       // _addToCart();
                        ajouterElementAuPanier();
                      },
                      child: Text('Ajouter au panier'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

// Obtenir une référence à la collection "carts"
    final cartCollection = FirebaseFirestore.instance.collection('carts');
    final User? user = _auth.currentUser;
   // final String? uid = user?.uid;

    final DocumentReference cartRef = _firestore.collection('carts').doc(uid);

    cartRef.get().then((cartSnapshot) {
      if (cartSnapshot.exists) {
        cartRef.update({
          'items': FieldValue.arrayUnion([widget.article])
        });
      } else {
        cartRef.set({
          'items': [widget.article]
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Article ajouté au panier'),
        duration: Duration(seconds: 2),
      ),
    );
  }
 void ajouterElementAuPanier()
  {
    /*final uid = FirebaseAuth.instance.currentUser?.uid;

    // Obtenir une référence à la collection "carts"
    final cartCollection = FirebaseFirestore.instance.collection('carts');
    final User? user = _auth.currentUser;
    final DocumentReference cartRef = _firestore.collection('carts').doc(uid);

    // Vérifier si widget.article est de type Map<dynamic, dynamic>
    if (widget.article is Map<dynamic, dynamic>) {
      cartRef.get().then((cartSnapshot) {
        if (cartSnapshot.exists) {
          cartRef.update({
            'items': FieldValue.arrayUnion([widget.article])
          });
        } else {
          cartRef.set({
            'items': [widget.article]
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Article ajouté au panier'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Gérer l'erreur si widget.article n'est pas de type Map<dynamic, dynamic>
      print('Erreur: widget.article n\'est pas de type Map<dynamic, dynamic>');
    }*/
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Obtenir une référence à la collection "carts"
    final cartCollection = FirebaseFirestore.instance.collection('carts');
    final User? user = _auth.currentUser;
    final DocumentReference cartRef = _firestore.collection('carts').doc(uid);

    final Map<String, dynamic> articleData = widget.article.data() as Map<String, dynamic>;

    // Vérifier que les données sont valides
    if (articleData['titre'] == null ||
        articleData['taille'] == null ||
        articleData['marque'] == null ||
        articleData['prix'] == null) {
      Fluttertoast.showToast(
          msg: "Article invalide",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    cartRef.get().then((cartSnapshot) {
      if (cartSnapshot.exists) {
        cartRef.update({
          'items': FieldValue.arrayUnion([articleData])
        });
      } else {
        cartRef.set({
          'items': [articleData]
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Article ajouté au panier'),
        duration: Duration(seconds: 2),
      ),
    );


  }

  }

