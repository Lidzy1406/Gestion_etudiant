import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  final String name;
  final int coefficient;
  final int ccNote;
  final int snNote;
  final int tpNote;

  Unit({
    required this.name,
    required this.coefficient,
    required this.ccNote,
    required this.snNote,
    required this.tpNote,
  });

}

class Name {
  final String name;

  Name({required this.name});
}

