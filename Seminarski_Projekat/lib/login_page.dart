// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, annotate_overrides, unused_import, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seminarski_projekat/welcome_page.dart';
import 'package:flutter/material.dart';

class LoginStranica extends StatefulWidget {
  final VoidCallback prikaziStranicuZaRegistraciju;
  const LoginStranica({Key? key, required this.prikaziStranicuZaRegistraciju})
      : super(key: key);

  @override
  State<LoginStranica> createState() => _LoginStranicaState();
}

class _LoginStranicaState extends State<LoginStranica> {
  final _emailKontroler = TextEditingController();
  final _lozinkaKontroler = TextEditingController();
  String _errorMessage = '';

  Future prijava() async {
    String email = _emailKontroler.text.trim();
    String password = _lozinkaKontroler.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Morate uneti sve podatke!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailKontroler.text.trim(),
        password: _lozinkaKontroler.text.trim(),
      );

      String userId = userCredential.user!.uid;

      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('korisnici').doc(userId).get();

      // ovde možete koristiti documentSnapshot da prikažete podatke korisnika

      // Resetujemo poruku o grešci
      setState(() {
        _errorMessage = '';
      });
    } catch (error) {
      setState(() {
        // Postavljamo poruku o grešci na osnovu greške koja se dogodila
        _errorMessage = 'Greška prilikom prijave: $error';
      });

      // Prikazujemo SnackBar sa porukom o grešci
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }


  @override
  void dispose() {
    _emailKontroler.dispose();
    _lozinkaKontroler.dispose();
    super.dispose();
  }

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
                'Dobrodošli!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Pratite vašu servisnu istoriju',
                style: TextStyle(
                  fontSize: 22,
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
                          prefixIcon: Icon(Icons.email, color: new Color(0xfffc571f)),
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
              SizedBox(height: 10,),
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
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: prijava,
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
                          'Prijavite se',
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
                    'Niste registrovani?',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 20
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.prikaziStranicuZaRegistraciju,
                    child: Text(
                      ' Registrujte se',
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
