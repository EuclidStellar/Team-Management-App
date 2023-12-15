import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Utils/Routes.dart';
import 'login.dart';
class Mresign extends StatefulWidget {
   Mresign({super.key, required this.teamId,required this.emailId});
   String? teamId;
   String? emailId;

  @override
  State<Mresign> createState() => _MresignState();
}

class _MresignState extends State<Mresign> {
  Future<void> MresignApi(String? teamId, String? email) async {
    dynamic storedValue = await secureStorage.readSecureData(key);
    // print(teamId);
    // print (storedValue);
    final String apiUrl = 'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/user/sendMessage/$teamId';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization' :storedValue,
        // 'Content-Type': 'application/json'
      },

      body: ({
        "Email": email,
        "message":MessageController.text,
      }),
    );

    if (response.statusCode == 200) {
      // print('API Response: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email Send"),),);
      Navigator.pushReplacementNamed(context, MyRoutes.BottomNavBar);
    } else {
      print( ' ${response.statusCode}');
      print('Error Message: ${response.body}');
    }
  }
  TextEditingController MessageController=TextEditingController();
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

                  const Text("Resign",style:TextStyle(color: Colors.white,fontSize:40,fontWeight: FontWeight.w700),),
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
                          // borderRadius: BorderRadiusDirectional.all(Radius.circular(30)),
                          child: Container(
                            height: 200,
                            width: 270,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLines: 10,
                                controller: MessageController,
                                decoration: InputDecoration(
                                  // prefixIcon:Icon(Icons.group),
                                  // prefixIcon:Image.asset("lib/assets/icon_pass.png",height: 20,),
                                  hintText: "Message to leader",
                                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                                  // suffixIcon: Icon(Icons.visibility),
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25,),
                        ElevatedButton(onPressed: (){
                          MresignApi(widget.teamId, widget.emailId);
                          // joinTeamAPI();
                        },
                          style:ElevatedButton.styleFrom(
                            backgroundColor:const Color.fromARGB(255, 225, 169, 229),
                            // padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),

                          ),
                          child:const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Send Resign"),
                              SizedBox(width:5),
// /                              IconButton(onPressed: joinTeamAPI, icon: Icon(Icons.arrow_circle_right_outlined))
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
