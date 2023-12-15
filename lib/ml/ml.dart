import 'package:brl_task4/ml/bar.dart';
import 'package:brl_task4/ml/cloud.dart';
import 'package:brl_task4/ml/line.dart';
import 'package:brl_task4/ml/pie.dart';
import 'package:brl_task4/music/music.dart';

import 'package:flutter/material.dart';

// import 'package:ml/bar.dart';
// import 'package:ml/linechart.dart';
// import 'package:ml/ml.dart';

class MLWOW extends StatelessWidget {
  const MLWOW({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => const MusicApp()));
      //   },
      //   child: const Icon(Icons.music_note),
      // ),

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
                  '\nChat Analysis',
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
                    'Bar Chart',
                    BarChartPage(),
                    Icons.bar_chart,
                    Colors.blue,
                  ),
                  _buildGridItem(
                    context,
                    'Radar Page',
                    Radarpage(),
                    Icons.radar_rounded,
                    Colors.green,
                  ),
                  _buildGridItem(
                    context,
                    'Line Chart',
                    Linechart(),
                    Icons.stacked_line_chart,
                    Colors.orange,
                  ),
                  _buildGridItem(
                    context,
                    'Pie Chart',
                    PieChartPage(),
                    Icons.pie_chart,
                    const Color.fromARGB(247, 234, 102, 102),
                  ),
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


