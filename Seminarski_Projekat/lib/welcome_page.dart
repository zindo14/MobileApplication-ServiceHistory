// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, unused_import, depend_on_referenced_packages, use_build_context_synchronously, unused_element, sort_child_properties_last, avoid_web_libraries_in_flutter

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'pretraga_stranica.dart';
import 'dart:collection';

class PocetnaStranica extends StatefulWidget {
  const PocetnaStranica({super.key});

  @override
  State<PocetnaStranica> createState() => _PocetnaStranicaState();
}

class _PocetnaStranicaState extends State<PocetnaStranica> {

  Widget customCheckboxListTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.green;
            }
            return null;
          }),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  bool _sortAscending = false;
  late Query _query;

  late CollectionReference _products;

  @override
  void initState() {
    super.initState();
    _query = FirebaseFirestore.instance.collection('korisnici').doc(trenutniKorisnik!.uid).collection('unosi').orderBy('kilometraza', descending: !_sortAscending);
  }

  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isUljeFilteriChanged = false;
  bool _isAkumulatorChanged = false;
  bool _isBrakeChanged = false;
  bool _isVService = false;
  bool _isAntifrizChanged = false;
  bool _isClutchChanged = false;

  final User? trenutniKorisnik = FirebaseAuth.instance.currentUser;

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    _kmController.text = '';
    _makeController.text = '';
    _dateController.text = '';
    _priceController.text = '';
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 15,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    controller: _kmController,
                    decoration: InputDecoration(
                      labelText: 'Kilometraza',
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Datum u formatu 'DD.MM.GGGG'",
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: "Potrosen novac",
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            customCheckboxListTile(
                              title: 'Ulje i filteri',
                              value: _isUljeFilteriChanged,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isUljeFilteriChanged = value!;
                                });
                              },
                            ),
                            customCheckboxListTile(
                              title: 'Akumulator',
                              value: _isAkumulatorChanged,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAkumulatorChanged = value!;
                                });
                              },
                            ),
                            customCheckboxListTile(
                              title: 'Antifriz',
                              value: _isAntifrizChanged,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAntifrizChanged = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8), // Razmak između kolona
                      Expanded(
                        child: Column(
                          children: [
                            customCheckboxListTile(
                              title: 'Kvacilo',
                              value: _isClutchChanged,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isClutchChanged = value!;
                                });
                              },
                            ),
                            customCheckboxListTile(
                              title: 'Kocnice',
                              value: _isBrakeChanged,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isBrakeChanged = value!;
                                });
                              },
                            ),
                            customCheckboxListTile(
                              title: 'Veliki servis',
                              value: _isVService,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isVService = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: _makeController,
                    decoration: InputDecoration(
                      labelText: 'Kratak opis urađenog rada',
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      height:50, //height of button
                      width:150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfffc571f),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 15.0,
                        ),
                        onPressed: () async {
                          final int? km = int.tryParse(_kmController.text);
                          final String make = _makeController.text;
                          final double? cena = double.tryParse(_priceController.text);
                          List searchList = [];
                          for (var i = 1; i <= make.length; i++) {
                            var nextEl = make.substring(0, i).toLowerCase();
                            searchList.add(nextEl);
                            nextEl = make.substring(0, i);
                            searchList.add(nextEl);
                          }

                          final String date = _dateController.text;
                          if (km != null) {
                            await _products.add({
                              "kilometraza": km,
                              "opis": make,
                              "date": date,
                              'makeArr': searchList,
                              "cena": cena,
                              'uljefilterChanged': _isUljeFilteriChanged,
                              'akumulatorChanged':_isAkumulatorChanged,
                              'antifrizChanged':_isAntifrizChanged,
                              'kvaciloChanged':_isClutchChanged,
                              'brakeChanged':_isBrakeChanged,
                              'vserviceChanged':_isVService,
                            });

                            // Nakon uspešnog unosa, resetujte vrednosti
                            _kmController.text = '';
                            _makeController.text = '';
                            _dateController.text = '';
                            _priceController.text = '';
                            _isUljeFilteriChanged = false;
                            _isAkumulatorChanged = false;
                            _isBrakeChanged = false;
                            _isVService = false;
                            _isAntifrizChanged = false;
                            _isClutchChanged = false;

                            setState(() {});  // Ovo će pokrenuti ponovno iscrtavanje widget-a sa novim vrednostima
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          'Unesi',
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _kmController.text = documentSnapshot['kilometraza'].toString();
      _makeController.text = documentSnapshot['opis'];
      _dateController.text = documentSnapshot['date'];
      _priceController.text = documentSnapshot['cena'].toString();

      _isUljeFilteriChanged = documentSnapshot['uljefilterChanged'];
      _isAkumulatorChanged = documentSnapshot['akumulatorChanged'];
      _isAntifrizChanged = documentSnapshot['antifrizChanged'];
      _isClutchChanged = documentSnapshot['kvaciloChanged'];
      _isBrakeChanged = documentSnapshot['brakeChanged'];
      _isVService = documentSnapshot['vserviceChanged'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 15,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    controller: _kmController,
                    decoration: InputDecoration(
                      labelText: 'Kilometraza',
                      labelStyle: TextStyle(color: Colors.black54),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:  Color(0xfffc571f), width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Datum u formatu 'DD.MM.GGGG'",
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: "Potrosen novac",
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            customCheckboxListTile(
                              title: 'Ulje i filteri',
                              value: documentSnapshot!['uljefilterChanged'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isUljeFilteriChanged = value!;
                                });
                              },
                            ),
                            customCheckboxListTile(
                              title: 'Akumulator',
                              value: documentSnapshot['akumulatorChanged'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAkumulatorChanged = value!;
                                });
                              },
                            ),
                            customCheckboxListTile(
                              title: 'Antifriz',
                              value: documentSnapshot['antifrizChanged'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAntifrizChanged = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8), // Razmak između kolona
                      Expanded(
                        child: Column(
                          children: [
                            customCheckboxListTile(
                              title: 'Kvacilo',
                              value: documentSnapshot['kvaciloChanged'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isClutchChanged = value!;
                                });
                              },
                            ),
                            customCheckboxListTile(
                              title: 'Kocnice',
                              value: documentSnapshot['brakeChanged'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isBrakeChanged = value!;
                                });
                              },
                            ),
                            customCheckboxListTile(
                              title: 'Veliki servis',
                              value: documentSnapshot['vserviceChanged'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isVService = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: _makeController,
                    decoration: InputDecoration(
                      labelText: 'Kratak opis urađenog rada',
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      height:50, //height of button
                      width:150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfffc571f),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 15.0,
                        ),
                        onPressed: () async {
                          final int? km = int.tryParse(_kmController.text);
                          final String make = _makeController.text;
                          final String date = _dateController.text;
                          final double? cena = double.tryParse(_priceController.text);
                          List searchList = [];
                          for (var i = 1; i <= make.length; i++) {
                            var nextEl = make.substring(0, i).toLowerCase();
                            searchList.add(nextEl);
                            nextEl = make.substring(0, i);
                            searchList.add(nextEl);
                          }

                          if (km != null) {
                            await _products.doc(documentSnapshot.id).update({
                              "kilometraza": km,
                              "opis": make,
                              "date": date,
                              'makeArr': searchList,
                              "cena": cena,
                              'uljefilterChanged': _isUljeFilteriChanged,
                              'akumulatorChanged':_isAkumulatorChanged,
                              'antifrizChanged':_isAntifrizChanged,
                              'kvaciloChanged':_isClutchChanged,
                              'brakeChanged':_isBrakeChanged,
                              'vserviceChanged':_isVService,
                            });

                            _kmController.text = '';
                            _makeController.text = '';
                            _dateController.text = '';
                            _priceController.text = '';

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          'Ažuriraj',
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uspešno ste obrisali!')));
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
        actions: [
          IconButton(
            icon: _sortAscending ? Icon(Icons.arrow_upward) : Icon(Icons.arrow_downward),
            onPressed: (){
              setState(() {
                _sortAscending = !_sortAscending;
                _query = FirebaseFirestore.instance.collection('korisnici').doc(trenutniKorisnik!.uid).collection('unosi').orderBy('kilometraza', descending: !_sortAscending);
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PretraziStranica(),
                ),
              );
            },
          ),
          SizedBox(width: 10), // dodajte prazan widget između akcija radi boljeg razmaka
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // postavite na center kako biste centrirali naslov
          children: [
            Image.asset(
              "img/logoauto.png",
              scale: 16,
            ),
            SizedBox(width: 10),
            Text(
              'Servisna Istorija',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.green[500]),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
      body: Container(
          color: Colors.white,
          child: StreamBuilder(
            stream: _query.snapshots(),//_products
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
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
                                      documentSnapshot['kilometraza'].toString(),
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
                                      documentSnapshot['date'].toString(),
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
                                          documentSnapshot['cena'].toString(),
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
                                      documentSnapshot['opis'].toString(),
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
                                                    value: documentSnapshot['uljefilterChanged'] ?? false,
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
                                                    value: documentSnapshot['akumulatorChanged'] ?? false,
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
                                                    value: documentSnapshot['antifrizChanged'] ?? false,
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
                                                    value: documentSnapshot['kvaciloChanged'] ?? false,
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
                                                    value: documentSnapshot['brakeChanged'] ?? false,
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
                                                    value: documentSnapshot['vserviceChanged'] ?? false,
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
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => _update(documentSnapshot),
                                          icon: Icon(Icons.edit),
                                          label: Text('Uredi'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () => _delete(documentSnapshot.id),
                                          icon: Icon(Icons.delete),
                                          label: Text('Izbriši'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
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
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },

          ),
        ),
    floatingActionButton: FloatingActionButton(
    onPressed: () => _create(),
    child: const Icon(
    Icons.add,
    color: Colors.white,
    ),
    backgroundColor: Color(0xfffc571f),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    ),
    elevation: 5,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,);
  }
}