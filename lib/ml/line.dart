import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Linechart extends StatelessWidget {
  Linechart({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Line Chart'),
        ),
        body: Column(children: [
          const SizedBox(height: 50),
          Expanded(
            child: LineChart(LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: dataMap.entries
                      .map((entry) => FlSpot(
                          dataMap.keys.toList().indexOf(entry.key).toDouble(),
                          entry.value))
                      .toList(),
                  isCurved: true,
                  color: Colors.amber, // Line color
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
              ],
            )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: dataMap.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.amber,
                    shadowColor: Colors.black,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        dataMap.keys.toList()[index],
                        style: const TextStyle(
                          color: Color.fromARGB(255, 93, 96, 111),
                        ),
                      ),
                      trailing: Text(
                        dataMap.values.toList()[index].toString(),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 93, 96, 111),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ]));
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
