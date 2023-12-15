import 'dart:convert';
import 'package:brl_task4/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageListScreen extends StatefulWidget {
  final String teamId;
  ImageListScreen(this.teamId);

  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  List<Map<String, String>> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImage();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Resources'),
      ),
      body: isLoading
          ? Center(
            
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                          imageUrl: images[index]['imgURL']!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image.network(
                      images[index]['imgURL']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  ImageDetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('</>'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

