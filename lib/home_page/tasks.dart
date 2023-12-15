import 'dart:convert';
import 'package:brl_task4/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:brl_task4/home_page/progress.dart';

class TaskContainer extends StatefulWidget {
  const TaskContainer({Key? key}) : super(key: key);

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

int? completedTaskNum;
int? incompleteTaskNum;

class _TaskContainerState extends State<TaskContainer> {
  Future<void>? _futureData;
  Future<void>? _futureData2;
  List<dynamic>? compTasks;
  List<dynamic>? incompTasks;
  String? task;

  @override
  void initState() {
    super.initState();
    _futureData = incompTaskAPI();
    _futureData2 = compTaskAPI();
  }

  Future<void> incompTaskAPI() async {
    dynamic storedValue = await secureStorage.readSecureData(key);

    const String apiUrl =
        'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/team/incompleteTasks';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': storedValue,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        incompTasks = jsonDecode(response.body)['incompleteTasks'];
        print(incompTasks);
        incompleteTaskNum = incompTasks!.length;
      });
    } else {
      print(' ${response.statusCode}');
      print('Error Message: ${response.body}');
    }
  }

  Future<void> compTaskAPI() async {
    dynamic storedValue = await secureStorage.readSecureData(key);
    const String apiUrl =
        'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/team/completedTasks';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': storedValue,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        compTasks = jsonDecode(response.body)['completedTasks'];
        print(compTasks);
        completedTaskNum = compTasks!.length;
      });
    } else {
      print(' ${response.statusCode}');
      print('Error Message: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        thickness: 8,
        trackVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/task.png',
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20,),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Incomplete Tasks:-\n',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              showIncompletetask(),
              const SizedBox(height: 20,),
              const Text('Completed Tasks:-\n',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              showCompletedtask(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showIncompletetask() {
    return FutureBuilder<void>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (incompTasks == null || incompTasks!.isEmpty) {
            return const Text("No incomplete tasks");
          }
          return Container(
            color: Color.fromARGB(255, 143, 218, 217),
            height: 300,
            child: ListView.builder(
              itemCount: incompTasks!.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    _showAlert(incompTasks![index]['description'],
                        incompTasks![index]['assignedTo'],
                        incompTasks![index]['deadline']);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    color: const Color.fromARGB(255, 147, 78, 158),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          incompTasks![index]['description'] ?? "No tasks",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget showCompletedtask() {
    return FutureBuilder<void>(
      future: _futureData2,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (compTasks == null || compTasks!.isEmpty) {
            return const Text("No tasks");
          }
          return Container(
            color: Color.fromARGB(255, 143, 218, 217),
            height: 300,
            child: ListView.builder(
              itemCount: compTasks!.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    _showAlert(compTasks![index]['description'],
                        compTasks![index]['assignedTo'],
                        compTasks![index]['deadline']);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    color: const Color.fromARGB(255, 147, 78, 158),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          compTasks![index]['description'] ?? "No tasks",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  void _showAlert(String message, String assignedTo, String deadline) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Task Details"),
          content: Text(
              "Task: $message\nDeadline: $deadline\n\nAssigned To: $assignedTo"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
