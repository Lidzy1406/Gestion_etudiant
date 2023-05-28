import 'package:flutter/material.dart';
import 'package:marcas/screens/unit.dart';

import 'fonction.dart';

class HomePage extends StatelessWidget {
  final String matricule;

  const HomePage({Key? key, required this.matricule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:FutureBuilder<Name>(
            future: getName(matricule),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Text('Chargement...');
              } else if(snapshot.hasData) {
                final name = snapshot.data!.name;
                return Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              } else {
                return Text('Erreur de chargement');
              }
            }
        )
      ),
      body: FutureBuilder<List<Unit>>(
        future: getUnits(matricule),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final units = snapshot.data!;
            final mgp = calculateMGP(units).toStringAsFixed(2);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Notes',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListView.builder(
                      itemCount: units.length,
                      itemBuilder: (context, index) {
                        final unit = units[index];
                        final grade = calculateGrade(unit.ccNote, unit.snNote, unit.tpNote ?? 0);
                        final appreciation = calculateAppreciation(unit.ccNote, unit.snNote, unit.tpNote ?? 0);
                        final total = totalPoint(unit.ccNote, unit.snNote, unit.tpNote ?? 0);

                        return Card(
                          child: ListTile(
                            title: Text(unit.name),
                            subtitle: Text('Coefficient: ${unit.coefficient}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('CC: ${unit.ccNote}'),
                                    SizedBox(width: 8),
                                    Text('SN: ${unit.snNote}'),
                                    if (unit.tpNote != null) ...[
                                      if (unit.tpNote != 0) ...[
                                      SizedBox(width: 8),
                                      Text('TP: ${unit.tpNote}'),
                                    ],
                                    ],
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Total: $total'),
                                    SizedBox(width: 8),
                                    Text('Grade: $grade'),
                                  ],
                                ),
                                SizedBox(height:4 ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Text('App: $appreciation'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'MGP: $mgp',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur de chargement des données'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
