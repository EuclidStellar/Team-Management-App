

import 'dart:convert';
import 'package:brl_task4/create&join-Team/create-team.dart';
import 'package:brl_task4/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamDetailsScreen extends StatelessWidget {
  final List<Domain> selectedDomains; 
  final String teamname;
  final String teamId;
  TeamDetailsScreen(this.teamname, this.selectedDomains, this.teamId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(

       

        children: [
          Container(
            width: 361,
            height: 146,
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment(1, 0),
                image: AssetImage('lib/assets/test1.png'),
                fit: BoxFit.scaleDown,
              ),
              gradient: LinearGradient(
                begin: Alignment(0.98, -0.21),
                end: Alignment(-0.98, 0.21),
                colors: [Color(0xFF150218), Color(0xFF65386C)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x4C000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$teamname',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

         

          Expanded(
            child: ListView.builder(

              // using listview builder to show the list of domains selected taaki agar zyada domains select kiye toh scroll kar sake 
              // halaki aisa hai nhi ki zyada domains select kar paoge kyunki 4 hi domains hai but agar zyada domains hote toh scroll kar paate

              itemCount: selectedDomains.length,  
              itemBuilder: (context, index) {     

              
                List<IconData> icons = [
                  Icons.code_rounded,
                  Icons.monitor,
                  Icons.model_training_rounded,
                  Icons.developer_board_rounded,
                ];

                return Card(
                  shadowColor: Colors.black,
                  surfaceTintColor: Colors.white,
                  color: const Color.fromARGB(255, 48, 12, 56),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    iconColor: Colors.white,
                    leading: Icon(
                      icons[index],
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tileColor: const Color.fromARGB(255, 48, 12, 56),
                    title: Text(
                      selectedDomains[index].name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InviteMembersScreen(  
                            selectedDomains[index],                   
                            teamId: teamId,                           
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InviteMembersScreen extends StatelessWidget {
  final Domain domain;    
  final String teamId;    

  // InviteMembersScreen(this.domain, {super.key, required this.teamId});
  
  InviteMembersScreen(this.domain, {required this.teamId});

  TextEditingController emailController = TextEditingController();

  Future<void> _sendInvitation() async {

    // wahi create team wala code copy karke chote mote changes kiye hai bas 

    dynamic storedValue = await secureStorage.readSecureData(key);
    var headers = <String, String>{
      'Authorization': storedValue,
      'Content-Type': 'application/json',
    };

    var request = http.Request(
      'POST',
      Uri.parse(
          'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/team/sendTeamcode/$teamId/${domain.name}'),
    );

    request.body = json.encode({
      "recipients": [emailController.text],
    });

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(await response.stream.bytesToString());
        if (responseData['success'] == true) {
          print(responseData['message']);
        } else {
          print('Error sending invitation: ${responseData['message']}');
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error sending invitation: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Container(
            width: 361,
            height: 146,
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment(1, 0),
                image: AssetImage('lib/assets/amico.png'),
                fit: BoxFit.scaleDown,
              ),
              gradient: LinearGradient(
                begin: Alignment(0.98, -0.21),
                end: Alignment(-0.98, 0.21),
                colors: [Color(0xFF150218), Color(0xFF65386C)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x4C000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${domain.name}\nTeam',  // domain name
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 120),
          MyTextField(
              hintText: 'Enter Email to Invite',
              inputType: TextInputType.name,
              labelText2: 'Invite Email',
              secure1: false,
              capital: TextCapitalization.none,
              nameController1: emailController),
          const SizedBox(height: 20),
          Buttonki(
            buttonName: 'Send Invite',
            onTap: () {
              _sendInvitation();
            },
            bgColor: const Color.fromARGB(255, 54, 11, 60),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}


// fir wahi code uthaya hai create team se lekin chote mote changes kiye hai


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
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(12),
          shadowColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 64, 12, 57)),
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
        style: const TextStyle(color: Color.fromARGB(255, 42, 10, 42)),
        controller: nameController1,
        keyboardType: inputType,
        obscureText: secure1,
        textInputAction: TextInputAction.next,
        textCapitalization: capital,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 42, 10, 42)),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 51, 12, 52), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 55, 13, 56), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          labelText: labelText2,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 42, 10, 42)),
        ),
      ),
    );
  }
}













// Invite wale ka test code 


/*


class InviteMembersScreen extends StatelessWidget {
  final Domain domain;

  InviteMembersScreen(this.domain);

  TextEditingController emailController = TextEditingController();

  Future<void> _sendInvitation() async {
    dynamic storedValue = await secureStorage.readSecureData(key);
    var headers = <String, String>{
      'Authorization' :storedValue,
      'Content-Type': 'application/json',
    };

    var request = http.Request(
      'POST',
      Uri.parse('http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/team/sendTeamcode/:teamId/${domain.name}'),
    );

    request.body = json.encode({
      "recipients": [emailController.text],
    });

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(await response.stream.bytesToString());
        if (responseData['success'] == true) {
         
          print(responseData['message']);
        } else {
         
          print('Error sending invitation: ${responseData['message']}');
        }
      } else {
      
        print(response.reasonPhrase);
      }
    } catch (error) {
    
      print('Error sending invitation: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Members - ${domain.name} Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter email of team member for ${domain.name} team:',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {

                _sendInvitation();
              },
              child: Text('Send Invitation Code'),
            ),
          ],
        ),
      ),
    );
  }
}


*/