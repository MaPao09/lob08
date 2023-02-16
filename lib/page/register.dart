import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab08/Page/login.dart';
import 'package:lab08/service/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailcon = TextEditingController();
  final TextEditingController _passwordcon = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surename = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Register"))),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text("Email"),
            buildEmail(),
            Text("Password"),
            buildPAssword(),
            Text("Name"),
            buildName(),
            Text("Surename"),
            buildSurename(),
            buildRegister(),
          ],
        ),
      )),
    );
  }

  TextFormField buildPAssword() {
    return TextFormField(
      controller: _passwordcon,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Password";
        }
        return null;
      },
    );
  }

  TextFormField buildName() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Name";
        }
        return null;
      },
    );
  }

  TextFormField buildSurename() {
    return TextFormField(
      controller: _surename,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Surename";
        }
        return null;
      },
    );
  }

  TextFormField buildEmail() {
    return TextFormField(
      controller: _emailcon,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Email";
        }
        return null;
      },
    );
  }

  ElevatedButton buildRegister() {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            AuthService.registerUser(_emailcon.text, _passwordcon.text)
                .then((value) {
              if (value == 1) {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                users.doc(uid).set({
                  "Firstname": _name.text,
                  "lastname": _surename.text,
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
              } else {
                print("FAILED Register");
              }
            });
          }
        },
        child: const Text("Register"));
  }
}
