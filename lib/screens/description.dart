import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Description extends StatelessWidget {
  final String? title,description;
  const Description({Key? key,this.title,this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(title!,style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(description!,style: GoogleFonts.roboto(fontSize: 18,),),
            ),
          ],
        ),
      ),
    );
  }
}
