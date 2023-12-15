import 'package:brl_task4/ResourceM/Leaderassist.dart';
import 'package:brl_task4/ResourceM/doc.dart';
import 'package:brl_task4/ResourceM/fetchR.dart';
import 'package:brl_task4/ResourceM/getR.dart';
import 'package:brl_task4/ResourceM/imagecc.dart';
// import 'package:create_team/bench-employee.dart';
// import 'package:create_team/calendar.dart';
// import 'package:create_team/doc.dart';
import 'package:flutter/material.dart';

class ResourceM extends StatelessWidget {
  final String teamId;
  ResourceM(this.teamId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 420,
            height: 150,
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
            child: const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\nResource Manager',
                  style: TextStyle(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGridItem(
                    context,
                    'Documentation',
                    DocumentationPage(),
                    Icons.book,
                    Colors.blue,
                  ),
                  _buildGridItem(
                    context,
                    'Fetch Resources',
                    ShowTextScreen(teamId),
                    Icons.get_app,
                    Colors.green,
                  ),
                  _buildGridItem(
                    context,
                    'Post Resources',
                    PostTextScreen(teamId),
                    Icons.post_add,
                    Colors.orange,
                  ),
                  _buildGridItem(
                    context,
                    'Leader assistance ',
                    LeaderResource(teamId),
                    Icons.assistant,
                    const Color.fromARGB(247, 234, 102, 102),
                  ),
                  _buildGridItem(
                    context,
                    'Image Resources',
                    ImageListScreen(teamId),
                    Icons.image,
                    Color.fromARGB(247, 49, 55, 12)              ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildGridItem(
  BuildContext context,
  String text,
  Widget destination,
  IconData icon,
  Color color,
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => destination));
    },
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
















// code before decoration
// Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: GridView.count(
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 16,
          //       mainAxisSpacing: 16,
          //       children: [
          //         ElevatedButton(
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => DocumentationPage()),
          //             );
          //           },
          //           child: Text('Documentation'),
          //         ),
          //         ElevatedButton(
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => AvailabilityCalendarPage()),
          //             );
          //           },
          //           child: Text('Fetch Resources'),
          //         ),
          //         ElevatedButton(
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => BenchEmployeePage()),
          //             );
          //           },
          //           child: Text('Post Resources'),
          //         ),
          //       ],
          //     ),
          //   ),
          // )



            // appBar: AppBar(
      //   title: Text('Resource Manager'),
      // ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => DocumentationPage()),
      //           );
      //         },
      //         child: Text('Documentation'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => AvailabilityCalendarPage()),
      //           );
      //         },
      //         child: Text('Availability Calendar'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => BenchEmployeePage()),
      //           );
      //         },
      //         child: Text('Bench Employee'),
      //       ),
      //     ],
      //   ),
      // ),


// code before decoration

// Widget _buildGridItem(
//   BuildContext context,
//   String text,
//   Widget destination,
//   IconData icon,
//   Color color,
// ) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
//     },
//     child: Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       color: color,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 40,
//             color: Colors.white,
//           ),
//           SizedBox(height: 8),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
