// import 'package:flutter/material.dart';

// //task requirement
// class Task {
//   final String title;
//   bool isCompleted;

//   Task({required this.title, this.isCompleted = false});
// }

// //list
// class TodoList extends StatefulWidget {
//   @override
//   _TodoListState createState() => _TodoListState();
// }

// class _TodoListState extends State<TodoList> {
//   List<Task> tasks = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(tasks[index].title),
//                   leading: Checkbox(
//                     value: tasks[index].isCompleted,
//                     onChanged: (value) {
//                       setState(() {
//                         tasks[index].isCompleted = value ?? false;
//                       });
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 16.0),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 _dialog(context);
//               },
//               child: Text('Add Task'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   //add task
//   void _dialog(BuildContext context) {
//     TextEditingController taskController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Task'),
//           content: TextField(
//             controller: taskController,
//             decoration: InputDecoration(labelText: 'Task'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (taskController.text.isNotEmpty) {
//                   setState(() {
//                     tasks.add(Task(title: taskController.text));
//                   });
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }