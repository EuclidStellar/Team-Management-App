import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Utils/Routes.dart';
import 'login.dart';

class Resign extends StatefulWidget {
  Resign({super.key, required this.teamId});
  String? teamId;
// print(teamID);
  @override
  State<Resign> createState() => _ResignState();
}

class _ResignState extends State<Resign> {
  TextEditingController MEmailController =TextEditingController();
  TextEditingController EmailController =TextEditingController();
  Future<void> removeApi(String? teamId) async {
    dynamic storedValue = await secureStorage.readSecureData(key);
    print(teamId);
    print (storedValue);
    final String apiUrl = 'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/team/deleteMember/$teamId';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization' :storedValue,
        // 'Content-Type': 'application/json'
      },

      body: ({
        "memberEmail": MEmailController.text,
      }),
    );

    if (response.statusCode == 200) {
      // print('API Response: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed"),),);
      Navigator.pushReplacementNamed(context, MyRoutes.BottomNavBar);
    } else {
      print( ' ${response.statusCode}');
      print('Error Message: ${response.body}');
    }
  }

  Future<void> resignApi(String? teamId) async {
    dynamic storedValue = await secureStorage.readSecureData(key);
    print(teamId);
    // print (storedValue);
    final String apiUrl = 'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/team/leaderResign/$teamId';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization' :storedValue,
        // 'Content-Type': 'application/json'
      },

      body: ({
        "Email": EmailController.text,
        }),
    );

    if (response.statusCode == 200) {
      // print('API Response: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Assigned"),),);
      Navigator.pushReplacementNamed(context, MyRoutes.BottomNavBar);
    } else {
      print( ' ${response.statusCode}');
      print('Error Message: ${response.body}');
    }
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
            end: Alignment(0.4, 0.31),
            colors: [Color(0xFF150218), Color(0xFF65386C)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  //
                  // SizedBox(height: 30,),
                  //
                  // // Text("Remove",style:TextStyle(color: Colors.white,fontSize:40,fontWeight: FontWeight.w700),),
                  const SizedBox(height: 70,),
                  Container(
                    width: 303,
                    height: 200,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.15000000596046448),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Remove Member",style:TextStyle(color: Colors.white,fontSize:30,fontWeight: FontWeight.w700),),
                        const SizedBox(height: 10,),
                        ClipRRect(
                          borderRadius: const BorderRadiusDirectional.all(Radius.circular(30)),
                          child: Container(
                            height: 48,
                            width: 270,
                            color: Colors.white,
                            child: TextFormField(
                              controller: MEmailController,
                              decoration: InputDecoration(
                                prefixIcon:const Icon(Icons.email),
                                // prefixIcon:Image.asset("lib/assets/icon_pass.png",height: 20,),
                                hintText: "Email",
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
                          removeApi(widget.teamId);
                        },
                          style:ElevatedButton.styleFrom(
                            backgroundColor:const Color.fromARGB(255, 225, 169, 229),
                            // padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),

                          ),
                          child:const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Remove"),
                              SizedBox(width:5),
                              // IconButton(onPressed: joinTeamAPI, icon: Icon(Icons.arrow_circle_right_outlined))
                            ],
                          ),),

                      ],
                    ),
                  ),
                  const SizedBox(height: 40,),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(height: 2, width: 138,color: Colors.white,),
                        const Text(" OR ",style:TextStyle(color: Colors.white,fontSize:20,fontWeight: FontWeight.w700),),
                      Container(height: 2,width:138,color: Colors.white,),
                    ],
                  ),

                  // Text("Resign",style:TextStyle(color: Colors.white,fontSize:40,fontWeight: FontWeight.w700),),
                  const SizedBox(height: 40,),


                  Container(
                    width: 303,
                    height: 200,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.15000000596046448),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Assign New Leader",style:TextStyle(color: Colors.white,fontSize:30,fontWeight: FontWeight.w700),),
                        const SizedBox(height: 10,),
                        ClipRRect(
                          borderRadius: const BorderRadiusDirectional.all(Radius.circular(30)),
                          child: Container(
                            height: 48,
                            width: 270,
                            color: Colors.white,
                            child: TextFormField(
                              controller: EmailController,
                              decoration: InputDecoration(
                                prefixIcon:const Icon(Icons.email),
                                // prefixIcon:Image.asset("lib/assets/icon_pass.png",height: 20,),
                                hintText: "Email",
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
                          resignApi(widget.teamId);
                        },
                          style:ElevatedButton.styleFrom(
                            backgroundColor:const Color.fromARGB(255, 225, 169, 229),
                            // padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),

                          ),
                          child:const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Assign"),
                              SizedBox(width:5),
                              // IconButton(onPressed: joinTeamAPI, icon: Icon(Icons.arrow_circle_right_outlined))
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

