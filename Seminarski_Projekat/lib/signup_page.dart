// ignore_for_file: prefer_const_constructors, unused_import, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seminarski_projekat/welcome_page.dart';
import 'package:flutter/material.dart';

class RegistracijaStranica extends StatefulWidget {
  final VoidCallback prikaziLoginStranicu;
  const RegistracijaStranica({
    Key? key,
    required this.prikaziLoginStranicu,
  }) : super(key: key);

  @override
  State<RegistracijaStranica> createState() => _RegistracijaStranicaState();
}

class _RegistracijaStranicaState extends State<RegistracijaStranica> {
  final _emailKontroler = TextEditingController();
  final _lozinkaKontroler = TextEditingController();
  final _lozinkaKontroler2 = TextEditingController();
  @override
  void dispose() {
    _emailKontroler.dispose();
    _lozinkaKontroler.dispose();
    _lozinkaKontroler2.dispose();
    super.dispose();
  }

  Future<void> registrujSe() async {
    String email = _emailKontroler.text.trim();
    String password = _lozinkaKontroler.text.trim();
    String confirmPassword = _lozinkaKontroler2.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Morate uneti sve podatke!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lozinke se ne poklapaju!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('korisnici').doc(userId).set({
        // ovde dodajte podatke koje želite da sačuvate za korisnika
        // na primer: 'ime': 'Pera', 'prezime': 'Perić'
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registracija uspešna.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom registracije: $error'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }



  bool potvrdjivacLozinke() {
    if (_lozinkaKontroler.text.trim() == _lozinkaKontroler2.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                "img/logoauto.png",
                fit: BoxFit.contain,
                width: 200,
                height: 150,
              ),
              SizedBox(height: 30),
              Text(
                'Registracija',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Molimo vas unesite tačne podatke.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: Offset(1, 1),
                            color: Colors.grey.withOpacity(0.2)
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextField(
                      controller: _emailKontroler,
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email, color:new Color(0xfffc571f)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0
                              )
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                          )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: Offset(1, 1),
                            color: Colors.grey.withOpacity(0.2)
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextField(
                      controller: _lozinkaKontroler,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.password_outlined, color:new Color(0xfffc571f)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0
                              )
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                          )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: Offset(1, 1),
                            color: Colors.grey.withOpacity(0.2)
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextField(
                      controller: _lozinkaKontroler2,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Repeat Password",
                          prefixIcon: Icon(Icons.password_outlined, color:new Color(0xfffc571f)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0
                              )
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                          )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: registrujSe,
                  child: Container(
                    width: w*0.5,
                    height: h*0.072,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: new Color(0xfffc571f),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                          'Registrujte se',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Već ste se registrovali?',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 20
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.prikaziLoginStranicu,
                    child: Text(
                      ' Prijavite se',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}