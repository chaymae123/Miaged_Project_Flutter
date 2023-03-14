import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'panierPage.dart';
import 'profilPage.dart';
import 'detailsArticle.dart';



class home extends StatefulWidget {
  static List<Map> panier = [];
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<home> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _currentIndex = 0;
  int _selectedCategoryIndex = 0;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffffffff),Color(0xff04fcb1)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 50.0));
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _categories = [
    'Tous',
    'hommes',
    'femmes',
    'enfants'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _categories.length,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Miaged Shop', style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,   foreground: Paint()..shader = linearGradient,)),
              bottom: TabBar(
                controller: _tabController, // <-- fournir le TabController
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: _categories.map<Widget>((String category) {
                  return Tab(
                    text: category,
                  );
                }).toList(),
                onTap: (index) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
              ),
            ),
            body:
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('vetements').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  List<DocumentSnapshot<Object?>>? filteredArticles = (_selectedCategoryIndex == 0 ?
                  snapshot.data?.docs.toList() :
                  snapshot.data?.docs.where((article) => article['categorie'] == _categories[_selectedCategoryIndex]).toList())?.cast<DocumentSnapshot<Object?>>();
                  //print(snapshot.data?.docs.map((e) => e.data()).toList());
                  return ListView.builder(
                    itemCount: filteredArticles?.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot article = filteredArticles![index] as DocumentSnapshot<Object?>;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detailsArticle(article: article),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(article['image']),
                            ),
                            title: Text(article['titre']),
                            subtitle: Text('Taille: ${article['taille']} | Prix: ${article['prix']}'),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  if (_currentIndex == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => panierPage()),


                    );
                  } else if (_currentIndex == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => profilPage()),
                    );
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag),
                    label: "Acheter",
                    backgroundColor: Colors.blue,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: "Panier",
                    backgroundColor: Colors.green,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profil",
                    backgroundColor: Colors.orange,

                  ),
                ]
            )
        ));
  }




}