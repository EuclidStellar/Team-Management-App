import 'dart:convert';
import 'package:brl_task4/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApplyLeave extends StatefulWidget {
  final String teamid;

  ApplyLeave({required this.teamid});

  @override
  _ApplyLeaveState createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<String?> applyLeaveAPI(
      String startDate, String endDate, String reason) async {

    String StoreLeaveId;
    dynamic storedValue = await secureStorage.readSecureData(key);
    final String apiUrl =
        'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/leave/applyLeave/${widget.teamid}';

    var body = jsonEncode({"leaves": [   
      {
        "startDate": startDate,
        "endDate": endDate,
        "reason": reason,
      }]
    });

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': storedValue,
    };

    try {
      var response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Leave applied successfully');
        StoreLeaveId = jsonDecode(response.body)['_id'];
        print(jsonDecode(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Leave applied successfully!'),
          ),
        );
        LeaveID(StoreLeaveId);
        return null;
      } else {
        print('Error: ${response.statusCode}');
        print(jsonDecode(response.body));
        String error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
          ),
        );
        return jsonDecode(response.body)['error'];
        
      }
    } catch (e) {
      print('Error: $e');
      // return 'An error occurred';
    }
  }

  Future<void> LeaveID(String StoreLeaveID) async {
    dynamic storedValue = await secureStorage.readSecureData(key);
    final String apiUrl =
        'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/leave/leaveResult/$StoreLeaveID';

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': storedValue,
      'leaveId' : StoreLeaveID,
    };
    http.post(Uri.parse(apiUrl), headers: headers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.6, 0.8),
            end: Alignment(0.6, 0.21),
            colors: [Color(0xFF150218), Color(0xFF65386C)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Apply for Leave",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Provide the start date, end date, and reason for leave",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: startDateController,
                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                      decoration: InputDecoration(
                        labelText: 'Start Date: 02-12-2023',
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the start date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: endDateController,
                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                      decoration: InputDecoration(
                        labelText: 'End Date: 23-12-2023',
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the end date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        labelText: 'Reason for Leave',
                        prefixIcon: Icon(Icons.description, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the reason for leave';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _applyLeave(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 225, 169, 229),
                      ),
                      child: Text('Apply for Leave'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _applyLeave(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String startDate = startDateController.text;
      String endDate = endDateController.text;
      String reason = reasonController.text;

      await applyLeaveAPI(startDate, endDate, reason);

      // if (result == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Leave applied successfully!'),
      //     ),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Error: $result'),
      //     ),
      //   );
      // }
    }
  }
}
