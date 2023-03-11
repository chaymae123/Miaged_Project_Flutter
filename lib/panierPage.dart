import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class panierPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<panierPage> {
  late User _user;
  late Stream<QuerySnapshot> _cartStream;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _cartStream = FirebaseFirestore.instance
        .collection('carts')
        .doc(_user.uid)
        .collection('items')
        .snapshots();

  }

  void _removeItem(String itemId) {
    FirebaseFirestore.instance
        .collection('carts')
        .doc(_user.uid)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _cartStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var documents = snapshot.data!.docs;
          num total = documents.fold(
              0, (previousValue, document) => previousValue + document['prix']);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var item = documents[index];
                    return ListTile(
                      leading: Image.network(item['image']),
                      title: Text(item['titre']),
                      subtitle: Text(item['taille']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => _removeItem(item.id),
                          ),
                          Text('\$${item['prix']}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total'),
                    Text('\$$total'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
