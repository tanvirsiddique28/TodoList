import 'package:flutter/material.dart';
import 'package:my_todo_app/auth/authform.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: AuthForm(),
    );
  }
}
