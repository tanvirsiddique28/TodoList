import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/screens/addtask.dart';
import 'package:my_todo_app/screens/description.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? uid = '';
  @override
  void initState() {
    getUid();
    super.initState();
  }
  getUid()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final firebaseUser = await auth.currentUser;
    setState(() {
      uid = firebaseUser?.uid;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
        actions: [
          IconButton(
              onPressed:()async{
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
        backgroundColor: Theme.of(context).primaryColor ,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  );
            }else{
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                  itemBuilder: (context,index){
                  var time = (docs[index]['timestamp'] as Timestamp).toDate();
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(
                        title: docs[index]['title'],
                        description:docs[index]['description'] ,
                      )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(0xff121211),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                  child: Text(docs[index]['title'],style: GoogleFonts.roboto(fontSize: 20),),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(DateFormat.yMd().add_jm().format(time)),
                              )
                            ],
                          ),
                          Container(
                            child: IconButton(icon: Icon(Icons.delete),
                              onPressed: ()async{
                                  await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').doc(docs[index]['time']).delete();
                              },),
                          )
                        ],
                      ),
                    ),
                  );
                  }
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
