// ignore_for_file: unused_import, duplicate_import, depend_on_referenced_packages

import 'package:seminarski_projekat/login_page.dart';
import 'package:flutter/material.dart';
import 'package:seminarski_projekat/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seminarski_projekat/welcome_page.dart';
import 'package:flutter/material.dart';

class AutentifikacionaStranica extends StatefulWidget {
  const AutentifikacionaStranica({super.key});

  @override
  State<AutentifikacionaStranica> createState() =>
      _AutentifikacionaStranicaState();
}

class _AutentifikacionaStranicaState extends State<AutentifikacionaStranica> {
  bool prikaziLoginStranicu = true;

  void biracEkrana() {
    setState(() {
      prikaziLoginStranicu = !prikaziLoginStranicu;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (prikaziLoginStranicu) {
      return LoginStranica(
        prikaziStranicuZaRegistraciju: biracEkrana,
      );
    } else {
      return RegistracijaStranica(
        prikaziLoginStranicu: biracEkrana,
      );
    }
  }
}