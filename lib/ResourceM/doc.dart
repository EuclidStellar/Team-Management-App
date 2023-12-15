//import 'package:create_team/ui/createteam1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentationPage extends StatefulWidget {
  // const DocumentationPage({super.key});

  @override
  _DocumentationPageState createState() => _DocumentationPageState();
}

class _DocumentationPageState extends State<DocumentationPage> {
  TextEditingController updateController = TextEditingController();
  List<UpdateItem> updates = [];

  @override
  void initState() {
    super.initState();
    loadUpdates();
  }

  void loadUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String existingUpdates = prefs.getString('updates') ?? '';
    setState(() {
      updates = UpdateItem.fromStoredString(existingUpdates);
    });
  }

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
              padding: EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\nDocumentation',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField2(
                    hintText: 'Enter Your Documentation',
                    inputType: TextInputType.name,
                    labelText2: 'Write your Progress',
                    secure1: false,
                    capital: TextCapitalization.sentences,
                    nameController1: updateController,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: Buttonkii(
                        buttonName: 'Save Update',
                        onTap: () {
                          saveUpdate(updateController.text);
                        },
                        bgColor: const Color.fromARGB(255, 54, 11, 60),
                        textColor: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: updates.isEmpty
                        ? const Center(
                            child: Text(
                              'No updates available',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 37, 10, 38)),
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            reverse: true,
                            itemCount: updates.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text(
                                    updates[index].text,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    updates[index].formattedDateTime,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveUpdate(String update) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UpdateItem newUpdate = UpdateItem(text: update, dateTime: DateTime.now());
    setState(() {
      updates.insert(0, newUpdate);
    });
    prefs.setString('updates', UpdateItem.toStoredString(updates));
    updateController.clear();
  }
}

class UpdateItem {
  String text;
  DateTime dateTime;

  UpdateItem({required this.text, required this.dateTime});

  static String toStoredString(List<UpdateItem> updates) {
    return updates
        .map((update) => '${update.text}~${update.dateTime.toIso8601String()}')
        .join('\n');
  }

  static List<UpdateItem> fromStoredString(String storedString) {
    List<String> updateStrings = storedString.split('\n');
    return updateStrings
        .where((element) => element.isNotEmpty)
        .map((updateString) {
      List<String> parts = updateString.split('~');
      return UpdateItem(text: parts[0], dateTime: DateTime.parse(parts[1]));
    }).toList();
  }

  String get formattedDateTime {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
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
