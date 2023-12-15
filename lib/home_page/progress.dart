import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:brl_task4/models/appbar.dart';
import 'package:brl_task4/home_page/tasks.dart';

class ProgressChart extends StatefulWidget {
  const ProgressChart({Key? key}) : super(key: key);

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  @override
  Widget build(BuildContext context) {
    double totalTasks = (completedTaskNum! + incompleteTaskNum!).toDouble();
    double completedTasks = (completedTaskNum! / totalTasks) * 100.0;
    double incompleteTasks = (incompleteTaskNum! / totalTasks) * 100.0;

    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          Expanded(
            child: incompleteTaskNum==0 && completedTaskNum==0?
            Center(child: Text("No tasks assigned yet",style: TextStyle(fontSize: 25),))
            :
            PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: completedTasks,
                    title: '${completedTasks.toStringAsFixed(2)}%',
                    radius: 80.0,
                    titleStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: incompleteTasks,
                    title: '${incompleteTasks.toStringAsFixed(2)}%',
                    radius: 80.0,
                    titleStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 60.0,
                startDegreeOffset: -90,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                color: Colors.green,
              ),
              const SizedBox(width: 5),
              Text(
                'Completed Tasks',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 20),
              Icon(
                Icons.circle,
                color: Colors.red,
              ),
              const SizedBox(width: 5),
              Text(
                'Incomplete Tasks',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
