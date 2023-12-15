import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Radarpage extends StatelessWidget {
  final Map<String, double> dataMap = {
    "client": 81,
    "team": 71,
    "meeting": 56,
    "let": 53,
    "max": 47,
    "ready": 31,
    "submission": 31,
    "share": 27,
    "morning": 24,
    "project": 24,
    "lunch": 24,
    "ensure": 24,
    "follow": 24,
    "feedback": 23,
    "back": 23,
    "day": 23,
    "final": 23,
    "media": 21,
    "omitted": 21,
    "review": 21,
    "break": 20,
    "demo": 20,
    "progress": 19,
    "pm": 11,
    "time": 10,
    "check": 10,
    "end": 10,
    "discuss": 10,
    "work": 10,
    "forward": 10,
    "additional": 10,
  };

  Radarpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radar Chart'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: RadarChart(
              RadarChartData(
                radarBorderData: const BorderSide(color: Colors.grey),
                radarBackgroundColor: Colors.white,
                ticksTextStyle: const TextStyle(color: Colors.black),
                dataSets: [
                  RadarDataSet(
                    borderColor: const Color.fromARGB(255, 173, 243, 33),
                    borderWidth: 2,
                    fillColor: const Color.fromARGB(255, 66, 6, 51).withOpacity(0.2),
                    dataEntries: dataMap.entries
                        .map((entry) => RadarEntry(value: entry.value))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: dataMap.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color.fromARGB(255, 47, 9, 42),
                    shadowColor: Colors.black,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        dataMap.keys.toList()[index],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text(
                        dataMap.values.toList()[index].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getRandomColor() {
    return Color.fromRGBO(
      50 + (dataMap.length * 5),
      100 + (dataMap.length * 10),
      150 + (dataMap.length * 15),
      1,
    );
  }
}
