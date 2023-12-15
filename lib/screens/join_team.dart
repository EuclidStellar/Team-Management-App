import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import "../utils/Routes.dart";
import "../models/join_model.dart";
import "../screens/login.dart";
class join_team extends StatefulWidget {
  const join_team({super.key});

  @override
  State<join_team> createState() => _join_teamState();
}

class _join_teamState extends State<join_team> {

  Future<void> joinTeamAPI() async {
    dynamic storedValue = await secureStorage.readSecureData(key);
    // print (storedValue);
    const String apiUrl = 'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/team/joinTeam';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization' :storedValue,
        'Content-Type': 'application/json'
      },

      body: joinTeamToJson(
          JoinTeam(
            teamCode: TeamNameController.text,
            // domainName: DomainController.text,
          ),
      ),
    );

    if (response.statusCode == 200) {
      // print('API Response: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Join Team Successfully"),),);

      Navigator.pushReplacementNamed(context, MyRoutes.dashbMemRoutes);
    } else {
      print('Failed to join the team. Status Code: ${response.statusCode}');
      print('Error Message: ${response.body}');
    }
  }
  TextEditingController TeamNameController =TextEditingController();
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      const SizedBox(height: 100,),
                
                      const Text("Join Team",style:TextStyle(color: Colors.white,fontSize:40,fontWeight: FontWeight.w700),),
                      const SizedBox(height: 30,),
                
                
                      Container(
                        width: 303,
                        height: 300,
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.15000000596046448),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadiusDirectional.all(Radius.circular(30)),
                              child: Container(
                                height: 48,
                                width: 270,
                                color: Colors.white,
                                child: TextFormField(
                                  controller: TeamNameController,
                                  decoration: InputDecoration(
                                    prefixIcon:const Icon(Icons.group),
                                    // prefixIcon:Image.asset("lib/assets/icon_pass.png",height: 20,),
                                    hintText: "Team Code",
                                    contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                                    // suffixIcon: Icon(Icons.visibility),
                                    border:OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        const SizedBox(height: 25,),
                        ElevatedButton(onPressed: (){
                          joinTeamAPI();
                        },
                          style:ElevatedButton.styleFrom(
                              backgroundColor:const Color.fromARGB(255, 225, 169, 229),
                            // padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),

                          ),
                            child:Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Join Team"),
                                const SizedBox(width:5),
                                IconButton(onPressed: joinTeamAPI, icon: const Icon(Icons.arrow_circle_right_outlined))
                              ],
                            ),),
                
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

        ),
    );
  }
}
