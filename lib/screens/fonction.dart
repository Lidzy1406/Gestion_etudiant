import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marcas/screens/unit.dart';


Future<List<Unit>> getUnits(String matricule) async {
  try {
    final units = await FirebaseFirestore.instance
        .collection('students')
        .doc(matricule)
        .collection('units')
        .get();

    return units.docs
        .map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Unit(
        name: data['NameUe'],
        coefficient: data['coefficient'],
        ccNote: data['ccNote'],
        snNote: data['snNote'],
        tpNote: data.containsKey('tpNote') ? data['tpNote'] : 0,
      );
    })
        .toList();
  } catch (e) {
    print('Error loading units for $matricule: $e');
    rethrow;
  }
}



Future<Name> getName(String matricule) async {
  try {
    final document = await FirebaseFirestore.instance
        .collection('students')
        .doc(matricule)
        .get();

    final name = document.get('Name') as String;

    return Name(name: name);
  } catch (e) {
    print('Error loading name for $matricule: $e');
    rethrow;
  }
}

String calculateGrade(int ccNote, int snNote, int tpNote) {
    final total = ccNote + snNote + tpNote;

    if (total >= 80) {
      return 'A';
    } else if (total >= 75) {
      return 'A-';
    } else if (total >= 70) {
      return 'B+';
    } else if (total >= 65) {
      return 'B';
    } else if (total >= 60) {
      return 'B-';
    } else if (total >= 55) {
      return 'C+';
    } else if (total >= 50) {
      return 'C';
    } else if (total >= 45) {
      return 'C-';
    } else if (total >= 40) {
      return 'D+';
    } else if (total >= 35) {
      return 'D';
    } else if (total >= 30) {
      return 'E';
    } else {
      return 'F';
    }
  }

  String calculateAppreciation(int ccNote, int snNote, int tpNote) {
    final total = ccNote + snNote + tpNote;

    if (total >= 80) {
      return 'Excellent';
    } else if (total >= 75) {
      return 'Excellent';
    } else if (total >= 70) {
      return 'Très Bien';
    } else if (total >= 65) {
      return 'Très Bien';
    } else if (total >= 60) {
      return 'Assez Bien';
    } else if (total >= 55) {
      return 'Assez Bien';
    } else if (total >= 50) {
      return 'Bien';
    } else if (total >= 45) {
      return 'Credit capitalisé';
    } else if (total >= 40) {
      return 'Credit capitalisé';
    } else if (total >= 35) {
      return 'Credit capitalisé';
    } else if (total >= 30) {
      return 'Echec';
    } else {
      return 'Echec';
    }
  }

  double calculateMGP(List<Unit> units) {
    double totalGradePoints = 0;
    int totalCredits = 0;
    // var totalPoints = 0;
    for (Unit unit in units) {
      var grade = calculateGrade(unit.ccNote, unit.snNote, unit.tpNote);
      // if (unit.tpNote == null) {
      //   totalPoints += unit.ccNote + unit.snNote;
      // } else {
      //   totalPoints += unit.ccNote + unit.snNote + unit.tpNote;
      // }
      double point = getGradePoints(grade);
      int credits = unit.coefficient;
      totalGradePoints += point * credits;
      totalCredits += credits;
    }
    return totalCredits > 0 ? totalGradePoints / totalCredits : 0;
  }

  int totalPoint(int ccNote, int snNote, int tpNote){
    return  ccNote + snNote + tpNote;
  }

  double getGradePoints(String grade) {
    switch (grade) {
      case "A":
        return 4.00;
      case "A-":
        return 3.70;
      case "B+":
        return 3.30;
      case "B":
        return 3.00;
      case "B-":
        return 2.70;
      case "C+":
        return 2.30;
      case "C":
        return 2.00;
      case "C-":
        return 1.70;
      case "D+":
        return 1.30;
      case "D":
        return 1.00;
      default:
        return 0;
    }
  }