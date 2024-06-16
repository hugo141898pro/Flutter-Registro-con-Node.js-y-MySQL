import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class register_screen extends StatefulWidget {
  register_screen({super.key});

  @override
  State<register_screen> createState() => _register_screenState(
  );
}

class _register_screenState extends State<register_screen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
    final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
    

    Future<void> _registerUser() async{

      if(_nameController.text == "" || _emailController.text == "" || _passwordController.text == "" || _userNameController.text == ""){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Aviso'), 
              content: Text('Ingrese todos los datos completos'),
              actions: [
                TextButton(
                  child: Text('ok'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
              );
          }
        );
        return;
      }

    if(_formKey.currentState!.validate()){
        try {
          final response = await http.post(Uri.http('localhost:3000','/api/users'), 
          body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'nameUser': _userNameController.text,
          'password': _passwordController.text,
          }),
          headers: {            
            'Content-Type': 'application/json',
            'Accept': '*/*',});

          if(response.statusCode == 200){
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', _nameController.text);
          await prefs.setString('email', _emailController.text);
          await prefs.setString('userName', _userNameController.text);
          
          _nameController.clear();
          _userNameController.clear();
          _emailController.clear();
          _passwordController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error registering user: ${response.statusCode}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred while registering user: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
        
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color.fromARGB(255, 0, 247, 255),
        shadowColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            name(),
            userName(),
            email(),
            password(),
            button(),
          ],
        ),
      ),
    );
  }

  MaterialButton button() {
    return MaterialButton(
          padding: EdgeInsets.all(12),
          minWidth: 150,
          focusColor: Colors.blue,
          hoverColor: Colors.blue,
          shape: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          child: Text('Agregar'),
          color: Color.fromARGB(255, 0, 134, 134),
          textColor: Colors.white,
          onPressed: _registerUser
        );
  }

  Container name() {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
          padding: const EdgeInsets.all(15),
          child: Form(
            child: TextFormField(
              controller: _nameController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Ingresa nombre',
                hintText: "example: robert",
                prefixIcon: Icon(Icons.person_2_outlined),

                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 136, 0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.blue,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'por favor ingrese tu nombre';
                } else {
                  return null;
                }
              },
            ),
          ),
        );
  }

    Container userName() {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
          padding: const EdgeInsets.all(15),
          child: Form(
            child: TextFormField(
              controller: _userNameController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Ingresa userNombre',
                hintText: "example: robert123",
                prefixIcon: Icon(Icons.person_2_outlined),

                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 136, 0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.blue,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'porfavor ingres tu userNombre';
                } else {
                  return null;
                }
              },
            ),
          ),
        );
  }

  Container email() {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
          padding: const EdgeInsets.all(15),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: _emailController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: "ejemplo@gmail.com",
                prefixIcon: Icon(Icons.person_2_outlined),

                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 136, 0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.blue,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                return regex.hasMatch(value ?? '') ? null : 'esto no es un gmail';
                
              },
            ),
          ),
        );
  }

  Container password() {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
          padding: const EdgeInsets.all(15),
          child: Form(
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'password',
                hintText: "*******",
                prefixIcon: Icon(Icons.person_2_outlined),

                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 136, 0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.blue,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'por favor ingres tu password';
                } else {
                  return null;
                }
              },
            ),
          ),
        );
  }
}