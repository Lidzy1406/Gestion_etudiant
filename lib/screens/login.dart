import 'package:flutter/material.dart';
import 'package:marcas/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final matriculeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _matricule = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final enteredMatricule = matriculeController.text;
      final docSnapshot =
      await FirebaseFirestore.instance.collection('students').doc(enteredMatricule).get();
      if (!docSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Désolé ce matricule n\'est pas présent dans Firestore'),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(matricule: enteredMatricule),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Matricule'),
                controller: matriculeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre matricule';
                  }
                  return null;
                },
                onSaved: (value) {
                  _matricule = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
