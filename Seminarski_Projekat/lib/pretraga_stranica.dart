// ignore_for_file: unused_import, depend_on_referenced_packages, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';
import 'package:seminarski_projekat/welcome_page.dart';

class PretragaStranica extends StatelessWidget {
  const PretragaStranica({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pretraga',
      theme: ThemeData(
          primarySwatch: Colors.grey,
          // ignore: deprecated_member_use
          accentColor: Colors.grey),
      debugShowCheckedModeBanner: false,
      home: const PretraziStranica(),
    );
  }
}

class PretraziStranica extends StatefulWidget {
  const PretraziStranica({Key? key}) : super(key: key);

  @override
  State<PretraziStranica> createState() => _PretraziStranicaState();
}

class _PretraziStranicaState extends State<PretraziStranica> {

  final trenutniKorisnik = FirebaseAuth.instance.currentUser;

  List searchResult = [];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('korisnici')
        .doc(trenutniKorisnik!.uid)
        .collection('unosi')
        .where('makeArr', arrayContains: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  void filter(String value) async {
    final int? number = int.tryParse(value);
    final result = await FirebaseFirestore.instance
        .collection('korisnici')
        .doc(trenutniKorisnik!.uid)
        .collection('unosi')
        .where('kilometraza', isGreaterThan: number)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: kToolbarHeight + 30, // povećajte visinu trake
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // smanjite krivulju granice
            ),
          ),
          centerTitle: true, // postavite na true kako biste postavili naslov na sredinu
          backgroundColor: Colors.white, // promijenite boju pozadine u bijelu
          foregroundColor: Colors.black, // promijenite boju teksta u crnu
          elevation: 2, // dodajte sjenčanje
          title: const Text(
            "Pretraga",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
                  TextField(
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Pretrazi',
                      labelStyle: TextStyle(color: Colors.black54),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xfffc571f), width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onChanged: (query) {
                      searchFromFirebase(query);
                    },
                  ),
              const SizedBox(
                height: 20,
              ),
                  TextField(
                      decoration: InputDecoration(
                        labelText: 'Filtriraj po kilometrazi vecoj od:',
                        labelStyle: TextStyle(color: Colors.black54),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xfffc571f), width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    onChanged: (value) {
                      filter(value);
                    },
                  ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ExpansionTile(
                            leading: Icon(Icons.build, color: Color(0xfffc571f)), // Dodaje ikonu na početak
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kilometraža',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      searchResult[index]['kilometraza'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Datum',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      searchResult[index]['date'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Potrošeni novac: ',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 3), // Dodaje razmak između tekstualnih widgeta
                                        Text(
                                          searchResult[index]['cena'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          ' din',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Dodatni opis:',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      searchResult[index]['opis'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: searchResult[index]['uljefilterChanged'] ?? false,
                                                    onChanged: null,
                                                  ),
                                                  Text(
                                                    'Ulje i filteri',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: searchResult[index]['akumulatorChanged'] ?? false,
                                                    onChanged: null,
                                                  ),
                                                  Text(
                                                    'Akumulator',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: searchResult[index]['antifrizChanged'] ?? false,
                                                    onChanged: null,
                                                  ),
                                                  Text(
                                                    'Antifriz',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8), // Razmak između kolona
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: searchResult[index]['kvaciloChanged'] ?? false,
                                                    onChanged: null,
                                                  ),
                                                  Text(
                                                    'Kvacilo',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: searchResult[index]['brakeChanged'] ?? false,
                                                    onChanged: null,
                                                  ),
                                                  Text(
                                                    'Kocnice',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    value: searchResult[index]['vserviceChanged'] ?? false,
                                                    onChanged: null,
                                                  ),
                                                  Text(
                                                    'Veliki servis',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}