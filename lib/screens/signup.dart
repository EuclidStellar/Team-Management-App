import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Utils/Routes.dart';
import 'package:brl_task4/screens/recaptcha.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  Future <void> google() async{
    var request = http.Request('GET', Uri.parse('http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/googleOAuth'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      // Navigator.pushReplacementNamed(context, MyRoutes.BottomNavBar);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future <void> SignApi() async {
    const String apiUrl = 'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/user/signup';
    final response = await http.post(
        Uri.parse(apiUrl),
        body:({
             'name':nameController.text,
            'email':emailController.text,
            'password':passController.text,
          })
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.body),),);
    if (response.statusCode == 200) {
      print('API Response: ${response.body}');
      await Navigator.pushNamed(context, MyRoutes.LoginRoutes);

    } else {
      print('Failed to join the team. Status Code: ${response.statusCode}');
      print('Error Message: ${response.body}');
    }
    }
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController =TextEditingController();
  TextEditingController nameController =TextEditingController();
  TextEditingController passController =TextEditingController();
  TextEditingController comfpassController =TextEditingController();

  bool obscureText= true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        height: MediaQuery.of(context).size.height,
        decoration:BoxDecoration(
          color: Colors.purple.shade50.withOpacity(0.1),
          // image: DecorationImage(
            // image:AssetImage('lib/assets/BgAuth.png'),
            // fit: BoxFit.cover,),
        ),
        child:SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              // child: Form(
              //   key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "lib/assets/signup.png",
                        fit: BoxFit.fitWidth,
                        height: 250,
                      ),
                      const Text("Sign Up",style:TextStyle(fontSize: 40,fontWeight: FontWeight.w500)),
                      const Text("Agree to terms and conditions",style:TextStyle(fontSize: 14)),
                    ],),
                  const SizedBox(height: 20,),
                  Form(
                    key: _formKey,
                    child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          ClipRRect(
                            borderRadius: const BorderRadiusDirectional.all(Radius.circular(30)),
                            child: Container(
                              height: 45,
                              width: 290,
                              color: Colors.grey,
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  hintText: "Username",
                                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height:10),
                          ClipRRect(
                            borderRadius: const BorderRadiusDirectional.all(Radius.circular(30)),
                            child: Container(
                              height: 45,
                              width: 290,
                              color: Colors.grey,
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  hintText: "Email",
                                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height:10),
                          ClipRRect(
                            borderRadius: const BorderRadiusDirectional.all(Radius.circular(30)),
                            child: Container(
                              height: 45,
                              width: 290,
                              color: Colors.grey,
                              child: TextFormField(
                                controller: passController,
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  // prefixIcon:Icon(Icons.looks),
                                  prefixIcon:Image.asset("lib/assets/icon_pass.png",height: 20,),
                                  hintText: "Password",
                                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                                  suffixIcon:  IconButton(
                                    icon: Icon(obscureText? Icons.visibility_off : Icons.visibility),
                                    onPressed:(){
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                  ),
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height:10),
                          ClipRRect(
                            borderRadius: const BorderRadiusDirectional.all(Radius.circular(30)),
                            child: Container(
                              height: 45,
                              width: 290,
                              color: Colors.grey,
                              child: TextFormField(
                                controller: comfpassController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  // prefixIcon:Icon(Icons.looks),
                                  prefixIcon:Image.asset("lib/assets/icon_pass.png",height: 20,),
                                  hintText: "Confirm Password",
                                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                                  suffixIcon:  const Icon(Icons.visibility_off),
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                // validator: (value){
                                //   if(passController.text==comfpassController.text){
                                //     return null;
                                //   }
                                //   else{
                                //     return "Password mismatch";
                                //   }
                                // },
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Text("Signup via",style: TextStyle(color: Colors.black)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(height: 2, width: 138,color: Colors.purple,),
                              IconButton(onPressed: (){
                                google();
                              },
                                  padding: const EdgeInsets.all(1.0),
                                  icon:(Image.asset("lib/assets/google.png",height: 30,)) ),
                              Container(height: 2,width:138,color: Colors.purple,),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(
                            height: 45,
                            width: 290,
                            child: ElevatedButton(onPressed: (){
                                if (_formKey.currentState!.validate()) {
                                  if (passController.text == comfpassController.text) {
                                            SignApi();
                                  }}
                              else {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Password mismatch"),
                                  ),
                                );
                              }
                            },
                              style:ElevatedButton.styleFrom(backgroundColor: Colors.black,
                                // padding: const EdgeInsets.symmetric(horizontal: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                              ),

                              child: const Text("Sign up",style:TextStyle(color: Colors.white)),),
                          ),
                          // Recaptcha(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              const SizedBox(width: 3,),
                              TextButton(onPressed: (){
                                Navigator.pushReplacementNamed(context, MyRoutes.LoginRoutes);
                              }, child: const Text("Login",style:TextStyle(fontWeight: FontWeight.w500,color: Colors.black)))
                            ],
                          )
                        ]
                    ),),],
              ),
            ),
          ),
      ),

    );
  }
}