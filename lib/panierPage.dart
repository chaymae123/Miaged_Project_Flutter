import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class panierPage extends StatelessWidget {
  panierPage({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference = FirebaseFirestore.instance
      .collection("carts")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("items");
  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // automaticallyImplyLeading: false,
        title: Text('Panier'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Calculate total price
            num totalPrice = 0.0;
            documents.forEach((doc) {
              totalPrice += double.parse(doc['prix'][0].toString());
            });

            //Convert the documents to Maps
            List<Map> items = documents
                .map((e) => {
              'id': e.id,
              'prix': e['prix'][0].toDouble(),
              'titre': e['titre']?.toString() ?? '',
              'taille': e['taille']?.toString() ?? '',
              'image': e['image']?.toString() ?? '',
            })
                .toList();

            //Display the list
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      //Get the item at this index
                      Map thisItem = items[index];
                      //REturn the widget for the list items
                      return ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(thisItem['image']),
                        ),
                        title: Text(thisItem['titre']),
                        subtitle: Text(
                            'Taille : ${thisItem['taille']} - Prix : ${thisItem['prix'].toString()} €'),
                        trailing: GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("carts")
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .collection("items")
                                .doc(thisItem['id'])
                                .delete();
                          },
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total : ${totalPrice.toString()} €',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            );
          }

          //Show loader
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
