import 'dart:convert';
import 'dart:math';
import 'package:brl_task4/screens/chatHistory.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String name;

  const ChatScreen(this.name, {super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late IO.Socket socket;
  late String myUsername;
  final Map<String, Color> userColors = {};

  @override
  void initState() {
    super.initState();
    myUsername = widget.name;
    initSocket();
    loadMessages();
  }

  void initSocket() {
    socket = IO.io('http://3.7.70.25:8006', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connected: ${socket.id}');
    });
    socket.on('message', (data) {
      setState(() {
        if (data['username'] != null) {
          _messages.add({
            'message': data['message'],
            'username': data['username'],
          });

          if (!userColors.containsKey(data['username'])) {
            userColors[data['username']] = _generateRandomColor();
          }
        }
      });
    });
  }

  Color _generateRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }

  void joinTeam(String teamId) {
    socket.emit('join', {'teamId': teamId, 'username': myUsername});
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      socket.emit(
          'message', {'message': _controller.text, 'username': myUsername});
      saveMessage({'message': _controller.text, 'username': myUsername});
      setState(() {
        _messages.add({'message': _controller.text, 'username': myUsername});
      });
      _controller.clear();
    }
  }

  void saveMessage(Map<String, dynamic> message) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('chat_messages');
    
    List<Map<String, dynamic>> messages = [];

    if (messagesJson != null) {
      messages = json.decode(messagesJson).cast<Map<String, dynamic>>();
    }

    messages.add(message);

    prefs.setString('chat_messages', json.encode(messages));
  }

  void loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('chat_messages');

    if (messagesJson != null) {
      setState(() {
        _messages
            .addAll(json.decode(messagesJson).cast<Map<String, dynamic>>());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        shadowColor: Colors.black,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 40, 8, 43),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  ChatScreenfetch()));
              }),
        ],
        
        title: Text(
          'Chat </>',
    
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index]['message'];
                final username = _messages[index]['username'];

                return Align(
                  alignment: username == myUsername
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: userColors[username] ??
                          const Color.fromARGB(255, 92, 92, 214),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '$username:\n $message',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: MyTextField3(
                        hintText: 'Enter Your Message',
                        inputType: TextInputType.name,
                        labelText2: 'Message </>',
                        secure1: false,
                        capital: TextCapitalization.none,
                        nameController1: _controller)),
                IconButton(
                  icon: const Icon(Icons.send_sharp),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}

class MyTextField3 extends StatelessWidget {
  const MyTextField3({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.labelText2,
    required this.secure1,
    required this.capital,
    required this.nameController1,
    //required this.icon
  });

  final String hintText;
  final TextInputType inputType;
  final String labelText2;
  final bool secure1;
  final TextCapitalization capital;
  final TextEditingController nameController1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: TextFormField(
        //maxLines: 5,
        maxLength: 35,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        controller: nameController1,
        keyboardType: inputType,
        obscureText: secure1,
        textInputAction: TextInputAction.next,
        textCapitalization: capital,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 37, 10, 38)),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 37, 10, 38), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 37, 10, 38), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          labelText: labelText2,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 37, 10, 38)),
        ),
      ),
    );
  }
}
