import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  //----------------variables-----------------------------------------------
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool _isLoginPage = false;
  //----------------functions-----------------------------------------------
  startSignUp(){
    final validity = _formkey.currentState?.validate();
    //Focus.of(context).unfocus();
    if(validity!){
      _formkey.currentState?.save();
      submitForm(_email, _password, _username);
    }
  }
  submitForm(String email,String password,String username)async{
    final auth = FirebaseAuth.instance;

   try{
     if(_isLoginPage){
       final authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
     }else {
       final authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
       String? uniqueId = authResult.user?.uid;
       await FirebaseFirestore.instance.collection('users').doc(uniqueId).set(
         {
           'username':username,
           'email':email,
         }
       );
     }
   }catch(e){
print(e);
   }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            height: 200,
            child: Image.asset('assets/todo.png'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('username'),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Incorrect Username';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: new BorderSide(),
                        ),
                        labelText: "Enter Username",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (String? value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Incorrect Email';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('password'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Incorrect Password';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Enter Password",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 70,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ElevatedButton(
                      onPressed: () {
                        startSignUp();
                      },
                      child: _isLoginPage
                          ? Text(
                              'LogIn',
                              style: GoogleFonts.roboto(fontSize: 16),
                            )
                          : Text('SignUp',
                              style: GoogleFonts.roboto(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(

                    child: TextButton(onPressed: (){
                      setState(() {
                        _isLoginPage = !_isLoginPage;
                      });
                    },child: _isLoginPage?Text('Not a member?',style: GoogleFonts.roboto(fontSize: 16,color: Colors.white),):Text('Already a member?',style: GoogleFonts.roboto(fontSize: 16,color: Colors.white)),),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
