import 'dart:convert';
import 'dart:io';
import 'package:brl_task4/ResourceM/Leaderassist.dart';
import 'package:brl_task4/create&join-Team/create-team.dart';
import 'package:brl_task4/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PostTextScreen extends StatefulWidget {
  final String teamId;
  PostTextScreen(this.teamId);

  @override
  _PostTextScreenState createState() => _PostTextScreenState();
}

class _PostTextScreenState extends State<PostTextScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  String _responseMessage = '';
  final picker = ImagePicker();
  File? _image;

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future<void> postImage() async {
    String storedValue = await secureStorage.readSecureData(key);
    try {
      var apiUrl =
          'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/image/addImage';

      var headers = {
        'Authorization': storedValue,
      };

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.headers.addAll(headers);

      request.fields.addAll({
        'imgName': _imageController.text,
        'teamId': '${widget.teamId}',
        
      });
      print('${widget.teamId}');

      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo', _image!.path));
      } else {
        print('Image is null');
        return;
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        print(await response.stream.bytesToString());
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      setState(() {
        _image = null;
        _imageController.clear();
      });
     }
  }

  Future<void> postText() async {
    try {
      String storedValue = await secureStorage.readSecureData(key);

      var headers = {
        'Authorization': storedValue,
        'Content-Type': 'application/json',
      };

      var request = http.Request(
          'POST',
          Uri.parse(
              'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/text/addText/${widget.teamId}'));
      request.body = json.encode({"text": _textController.text});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        setState(() {
          _responseMessage = responseData['message'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Failed to post text. Status code: ${response.statusCode}'),
        
        ));
      }
    } catch (e) {
      print('Error posting text: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred while posting text.'),
       
      ));
    } finally {
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                padding: EdgeInsets.all(18.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\n\nPost resources',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField2(
                    hintText: 'Post Your Resources',
                    inputType: TextInputType.name,
                    labelText2: 'Resources </>',
                    secure1: false,
                    capital: TextCapitalization.sentences,
                    nameController1: _textController,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: Buttonkii(
                      buttonName: 'Post Data',
                      onTap: () {
                        postText();
                      },
                      bgColor: const Color.fromARGB(255, 54, 11, 60),
                      textColor: Colors.white,
                    ),
                  ),
                  Text(
                    _responseMessage,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 43, 16, 53),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyTextField12(
                            hintText: 'Name of your Image',
                            inputType: TextInputType.name,
                            labelText2: 'Image </>',
                            secure1: false,
                            capital: TextCapitalization.none,
                            nameController1: _imageController),
                        const SizedBox(height: 16),
                        _image != null
                            ? Image.file(
                                _image!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x4C000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                  color: Colors.grey[200],
                                ),
                              ),
                        SizedBox(height: 20),
                        // ElevatedButton(
                        //   onPressed: getImageGallery,
                        //   child: Text('Pick Image from Gallery'),
                        // ),
                        Buttonkii(
                            buttonName: 'Select Image',
                            onTap: getImageGallery,
                            bgColor: Colors.black,
                            textColor: Colors.white),
                        SizedBox(height: 20),
                        Buttonkii(
                            buttonName: 'Post Image',
                            onTap: postImage,
                            bgColor: Colors.black,
                            textColor: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Buttonkii extends StatelessWidget {
  const Buttonkii({
    Key? key,
    required this.buttonName,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  final String buttonName;
  final VoidCallback onTap;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(12),
          shadowColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 64, 12, 57)),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) => Colors.transparent,
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 15, color: textColor),
        ),
      ),
    );
  }
}

class MyTextField2 extends StatelessWidget {
  const MyTextField2({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.labelText2,
    required this.secure1,
    required this.capital,
    required this.nameController1,
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        maxLines: 5,
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
