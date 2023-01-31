import 'package:chat_app/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userMap;

  bool isLoading = false;

  final _searchController = TextEditingController();

  onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('users')
        .where('email', isEqualTo: _searchController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: logOut, icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                          label: Text('Search'), border: OutlineInputBorder()),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          onSearch();
                        },
                        child: const Text('Search')),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    userMap != null
                        ? ListTile(
                            title: Text(userMap!['name']),
                            subtitle: Text(userMap!['email']),
                            leading: const Icon(Icons.account_circle),
                            trailing: const Icon(Icons.chat),
                          )
                        : Container()
                  ],
                ),
              ));
  }
}
