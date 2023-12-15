import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreenfetch extends StatefulWidget {
  @override
  _ChatScreenfetchState createState() => _ChatScreenfetchState();
}

class _ChatScreenfetchState extends State<ChatScreenfetch> {
  List<Map<String, dynamic>> _chats = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  Future<void> fetchChats() async {
    
    final apiUrl = 'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/chat/getAllChats';


    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          _chats = List<Map<String, dynamic>>.from(responseData['chats']);
        });

        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        print('Failed to load chats. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading chats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 88, 22, 101),
        foregroundColor: Colors.white,
        elevation: 12,
        hoverColor: Colors.white,
        onPressed: () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        },
        child: Icon(Icons.arrow_downward),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 49, 12, 56),
        foregroundColor: Colors.white,
        elevation: 12,
        shadowColor: Colors.black,
        title: Text('Discussion History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _chats.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      final username = chat['username'];
                      final message = chat['message'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          color: Color.fromARGB(255, 46, 17, 55),
                          shadowColor: Colors.black,
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            title: Text(
                              '$username:', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Color.fromARGB(255, 254, 254, 254),
                              ),
                            ),
                            subtitle: Text(
                              message,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 220, 228, 73),
                              ),
                            ),
                          ),
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
