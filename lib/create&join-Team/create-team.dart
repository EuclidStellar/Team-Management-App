import 'dart:convert';
import 'package:brl_task4/create&join-Team/Domain-team.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../screens/login.dart';


class Domain {
  final int id;
  final String name;

  Domain({required this.id, required this.name});
}



class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {

 

  TextEditingController teamNameController = TextEditingController(); 

  List<Domain> domains = [

    Domain(id: 1, name: 'Backend'),  
    Domain(id: 2, name: 'Frontend'),
    Domain(id: 3, name: 'Machine Learning'),
    Domain(id: 4, name: 'App Development'),

  ];

  
  List<Domain> selectedDomains = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      key: _scaffoldKey, 

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.98, -0.21),
            end: Alignment(-0.98, 0.21),
            colors: [Color(0xFF150218), Color(0xFF65386C)],
          ),
        ),
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

             
               Row(
                children: [

                  const SizedBox(
                    width: 10,
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  const Text(
                    '  Create Team',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 30,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),

                ],
              ),

              const SizedBox(
                height: 20,
              ),

          

              Container(
                width: 303,
                height: 395,
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.15000000596046448),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    MyTextField(
                        hintText: 'Enter Team Name',
                        inputType: TextInputType.name,
                        labelText2: 'Team Name',
                        secure1: false,
                        capital: TextCapitalization.none,
                        nameController1: teamNameController
                        ),

                    const SizedBox(height: 16),
                    
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: MultiSelectDialogField(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                        ),
                        checkColor: Colors.white,
                        barrierColor: Colors.black,
                        selectedColor: Colors.black,
                        backgroundColor: const Color.fromARGB(255, 234, 167, 235),

                      
                        items: domains
                            .map((domain) =>                                     
                                MultiSelectItem<Domain>(domain, domain.name))     
                            .toList(),                                            
                        title: const Text('Select Domains',
                            style: TextStyle(color: Colors.black)),
                        buttonText: const Text('Select Domains',
                            style: TextStyle(color: Colors.white)),
                        onConfirm: (values) {
                          selectedDomains = values;     
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    Buttonki(
                      buttonName: 'Create Team',
                      onTap: () { 
                        if (teamNameController.text.isEmpty) {
                          _showErrorSnackBar('Team name cannot be empty');
                          return;
                        }
              
                        createTeam();
                      },
                      bgColor: const Color.fromARGB(255, 225, 169, 229),
                      textColor: Colors.black,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> createTeam() async {

   
    dynamic storedValue = await secureStorage.readSecureData(key);
    var headers = <String, String>{

      'Authorization' :storedValue,
      'Content-Type': 'application/json'
    };
      print(storedValue);
    var request = http.Request(
      'POST',
      Uri.parse(
          'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/team/createTeam'),
    );



    // List<Map<String, dynamic>> domainList = selectedDomains.map((domain) {  
    //   return {
    //     "name": domain.name, 
    //     "members": [],       
    //   };
    // }).toList();

  List<Map<String, dynamic>> domainList = selectedDomains.map((domain){
      return {
        "name": domain.name,
        "members": [],
      };
  }).toList();

   

    request.body = json.encode({  
      "teamName": teamNameController.text,
      "domains": domainList,
    });

    request.headers.addAll(headers);

    try {
      print ("hii");
      http.StreamedResponse response = await request.send();   

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(await response.stream.bytesToString()); 
        final String teamId = responseData['team']['_id'];     
        print(teamId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TeamDetailsScreen(teamNameController.text, selectedDomains, teamId),   // passing team name, selected domains and team id to team details screen
          ),
        );

        _showErrorSnackBar('Team created successfully');
        print(await response.stream.bytesToString());
      } else {
        _showErrorSnackBar(response.reasonPhrase!);
        print(response.reasonPhrase);
      }
    } catch (error) {

      _showErrorSnackBar('Error creating team: $error');
      print('Error creating team: $error');
    }
  }

 
  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}



// pub.dev me  mere khud ke package me se copy kiya hai ye code

class Buttonki extends StatelessWidget {
  const Buttonki({
    Key? key,
    required this.buttonName,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  final String buttonName;
  final VoidCallback onTap;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(12),
          shadowColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 227, 152, 217)),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) => Colors.transparent,
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 15, color: textColor),
        ),
      ),
    );
  }
}


// pub.dev me  mere khud ke package me se copy kiya hai ye code

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.labelText2,
    required this.secure1,
    required this.capital,
    required this.nameController1,
  });

  final String hintText;
  final TextInputType inputType;
  final String labelText2;
  final bool secure1;
  final TextCapitalization capital;
  final TextEditingController nameController1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        controller: nameController1,
        keyboardType: inputType,
        obscureText: secure1,
        textInputAction: TextInputAction.next,
        textCapitalization: capital,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 234, 167, 235), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 234, 167, 235), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          labelText: labelText2,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}






















