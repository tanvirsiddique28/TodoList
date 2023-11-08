import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  //-------------------------Functions-----------------------
  addTaskToFirebase()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    final firebaseUser = await _auth.currentUser;
    String? uniqueId = firebaseUser?.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance.collection('tasks').doc(uniqueId).collection('mytasks').doc(time.toString()).set({
      "title":titleController.text,
      "description":descriptionController.text,
      "time":time.toString(),
      "timestamp":time,
    });
    Fluttertoast.showToast(msg: 'Data Added');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
        backgroundColor: Theme.of(context).primaryColor ,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(5),
              height: 70,
              width: double.infinity,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ElevatedButton(
                onPressed: () {
                  addTaskToFirebase();
                },
                child: Text(
                  'Add Task',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState>states){
                      if(states.contains(MaterialState.pressed))
                        return Colors.purple.shade100;
                      return Theme.of(context).primaryColor;
    })))
                  ),
                  ],
              ),
            ),

        );

  }
}
