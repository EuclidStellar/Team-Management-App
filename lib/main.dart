// app dev starts here
// only push here in dev branch 
// do not merge in main branch

import 'package:brl_task4/screens/MarkTaskDone.dart';
import 'package:brl_task4/screens/dashboard.dart';
import 'package:brl_task4/screens/join_team.dart';
import 'package:brl_task4/screens/signup.dart';
import 'package:brl_task4/screens/login.dart';
import 'package:brl_task4/utils/Routes.dart';
import'package:flutter/material.dart';
import 'create&join-Team/create-team.dart';
import 'home_page/bottomnavbar.dart';
import 'package:brl_task4/screens/forgot%20password/forgot_pass.dart';
import 'package:brl_task4/leave approval/leave.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  dynamic storedValue = await secureStorage.readSecureData(key);
    if(storedValue==null){
      runApp(const MyApp());
    }
    else{
      runApp(const MyApp2());
    }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)  {
    dynamic storedValue = secureStorage.readSecureData(key);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: BottomNavBar(),

        initialRoute: '/',
        routes: {
          '/':(context)=>const SignUp(),

          // '/': (context) => (storedValue==null)?SignUp():BottomNavBar(),
        MyRoutes.SignUpRoutes: (context) => const SignUp(),
        MyRoutes.LoginRoutes: (context) => const Login(),
        MyRoutes.dashbMemRoutes: (context) => const dashb_mem(),
        MyRoutes.jointeamRoutes: (context) => const join_team(),
        MyRoutes.CreateTeamScreen: (context) => const CreateTeamScreen(),
        MyRoutes.BottomNavBar:(context) => const BottomNavBar(),
        MyRoutes.DoneTask:(context) => const doneTask(),
        // MyRoutes.Todo:(context) => TodoList(),
        MyRoutes.Reset:(context) => const ResetPass(),
          }
        );
  }
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context)  {
    dynamic storedValue = secureStorage.readSecureData(key);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: BottomNavBar(),

        initialRoute: '/',
        routes: {
          '/':(context)=>const BottomNavBar(),

          // '/': (context) => (storedValue==null)?SignUp():BottomNavBar(),
          MyRoutes.SignUpRoutes: (context) => const SignUp(),
          MyRoutes.LoginRoutes: (context) => const Login(),
          MyRoutes.dashbMemRoutes: (context) => const dashb_mem(),
          MyRoutes.jointeamRoutes: (context) => const join_team(),
          MyRoutes.CreateTeamScreen: (context) => const CreateTeamScreen(),
          MyRoutes.BottomNavBar:(context) => const BottomNavBar(),
          MyRoutes.DoneTask:(context) => const doneTask(),
          // MyRoutes.Todo:(context) => TodoList(),
        }
    );
  }
}
