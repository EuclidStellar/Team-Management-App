import 'package:brl_task4/models/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brl_task4/home_page/teams.dart';
import 'package:brl_task4/home_page/tasks.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _selectedIndex = 0;
  final List _pages = [
    const Center(child: TaskContainer()),
    const Center(child: TeamPage()),
  ];

  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.of(context).size.height;
    double buttonWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: buttonWidth,
              height: buttonHeight*0.075,
              child: CupertinoSegmentedControl<int>(
                children: const {
                  0: Text('To-Do List'),
                  1: Text('Teams'),
                },
                onValueChanged: (index) {
                  _onNavItemTapped(index);
                },
                groupValue: _selectedIndex,
                // borderColor: Theme.of(context).primaryColor,
                selectedColor: const Color.fromARGB(255, 101, 56, 108),
                unselectedColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:brl_task4/home_page/teams.dart';
// import 'package:brl_task4/home_page/tasks.dart';
// // ignore_for_file: prefer_const_constructors

// class HomeNav extends StatefulWidget {
//   @override
//   _HomeNavState createState() => _HomeNavState();
// }

// class _HomeNavState extends State<HomeNav> {
//   int _selectedIndex = 0;
//   List _pages = [
//     // Center(child: Container(
//     //   child: Row(children: [
//     //     Text('Create Team'),
//     //     Column(
//     //       children: [
//     //       IconButton(onPressed: () {}, icon: Icon(Icons.add)),],
//     //     )
//     //   ],),
//     // )),
//     Center(child: TeamPage()),
//     Center(child: TaskContainer()),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //   body: _pages[_selectedIndex],
//     //   bottomNavigationBar: BottomNavigationBar(
//     //     items: [
//     //       BottomNavigationBarItem(
//     //         icon: Icon(Icons.group),
//     //         label: 'Teams',
//     //       ),
//     //       BottomNavigationBarItem(
//     //         icon: Icon(Icons.list),
//     //         label: 'To-Do List',
//     //       ),
//     //     ],
//     //     currentIndex: _selectedIndex,
//     //     onTap: (index) {
//     //       setState(() {
//     //         _selectedIndex = index;
//     //       });
//     //     },
//     //   ),
//     // );
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.group),
//             onPressed: () {
//               _onNavItemTapped(0);
//             },
//           ),
//           Text('Teams',),
//           IconButton(
//             icon: Icon(Icons.list),
//             onPressed: () {
//               _onNavItemTapped(1);
//             },
//           ),
//           Text('To-Do List'),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//     );
//   }

//   void _onNavItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
// }

