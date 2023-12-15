import 'dart:convert';
import 'package:brl_task4/ResourceM/imagecc.dart';
import 'package:brl_task4/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowTextScreen extends StatefulWidget {
  final String teamId;
  const ShowTextScreen(this.teamId, {super.key});

  @override
  _ShowTextScreenState createState() => _ShowTextScreenState();
}

class _ShowTextScreenState extends State<ShowTextScreen> {
  List<dynamic> messages = [];
  bool isLoading = true;
  List<Map<String, String>> images = [];
  bool isLoadingm = true;


 Future<void> getImage() async {
   dynamic storedValue = await secureStorage.readSecureData(key);
  String url = 'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/image/showImage/${widget.teamId}';
  String token = storedValue;

  try {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
     
      List<dynamic> responseData = json.decode(response.body);
      setState(() {
        images = responseData.map<Map<String, String>>((item) => {
          'imgURL': item['imgURL'],
          'imgName': item['imgName'],
        }).toList();
        isLoading = false;
      });
    } else {
      
      print('Failed to retrieve the image. Status code: ${response.statusCode}');
    }
  } catch (error) {
  
    print('Error: $error');
  }
}
 
  Future<void> fetchMessages() async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
          'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/text/showText/${widget.teamId}',
        ),
      );

      http.Response response = await http.get(request.url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          isLoading = false;
          
          if (responseData['data'] is List) {
            messages = responseData['data'];
          } else {
            print('Invalid data structure');
          }
        });
      } else {
        print('Failed to fetch messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
    //fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: 

      // () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ImageListScreen(),
      //     ),
          
      //   );

      // },
      // child: Icon(Icons.add),
      
      // ),
      // appBar: AppBar(
      //   title: Text('Resources'),
      // ),
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
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\nResource Manager',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),


          //  isLoading
          // ? Center(
          //     child: CircularProgressIndicator(),
          //   )
          // : GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 8.0,
          //       mainAxisSpacing: 8.0,
          //     ),
          //     itemCount: images.length,
          //     itemBuilder: (context, index) {
          //       return GestureDetector(
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => ImageDetailScreen(
          //                 imageUrl: images[index]['imgURL']!,
          //               ),
          //             ),
          //           );
          //         },
          //         child: Card(
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12.0),
          //           ),
          //           child: Image.network(
          //             images[index]['imgURL']!,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       );
          //     },
          //   ),



          // message fetch karne wala code abhi comment out kar diya hia iske uparw ala code images ke liye hai check karlo 




          isLoading
              ? const CircularProgressIndicator()
              : messages.isEmpty
                  ? const Text('No messages available.')
                  : Expanded(
                      child: ListView.builder(
                        reverse: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final email = messages[index]['email'];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '   Email: $email',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: messages[index]['texts'].length,
                                  itemBuilder: (context, index1) {
                                    final text = messages[index]['texts']
                                        [index1]['text'];
                                    return Card(
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      color: const Color.fromARGB(255, 47, 18, 59),
                                      child: ListTile(
                                        title: Text(
                                          text,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const Divider(),
                              ],
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



// class ImageDetailScreen extends StatelessWidget {
//   final String imageUrl;

//   ImageDetailScreen({required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Detail'),
//       ),
//       body: Center(
//         child: Image.network(
//           imageUrl,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }



