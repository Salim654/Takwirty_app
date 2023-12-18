import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_simple_page/Utils/size_config.dart';
import 'package:flutter_simple_page/Views/login.dart';
import 'package:http/http.dart' as http;

import '../Services/ApiClient.dart';


class PageRegister extends StatefulWidget {
  const PageRegister({Key? key}) : super(key: key);

  @override
  State<PageRegister> createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _password = "";

  void _submitForm() async {

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (_name != "" && _email != "" && _password != "")
        {
          final response = await ApiClient.RegisterUser(_name,_email, _password);


        if (response.statusCode == 201) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PageLogin(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User Added succefully"),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error Something is wrong"),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

        else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Fill Credientiels"),
            duration: Duration(seconds: 3),
        ),
      );
        }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight *0.04),
              Center(
              child: Image.asset(
                'assets/register.gif',  // Replace with the actual path to your image
                width: getProportionateScreenWidth(200),  // Adjust the width as needed
                height: getProportionateScreenHeight(200),  // Adjust the height as needed
              ),
            ),
              Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Complete your details",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight *0.08,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "Enter your Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Icon(Icons.account_box),
                        ),
                      ),
                      onSaved: (value) {if (value != null) {_name = value;}}
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Icon(Icons.email),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {if (value != null) {_email = value;}}
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your Password",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Icon(Icons.key),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                        onSaved: (value) {if (value != null) {_password = value;}}
                    )
                  ],
                ),
              ),

              SizedBox(height: getProportionateScreenHeight(20)),
              SizedBox(
                width: double.infinity,
                height: getProportionateScreenHeight(56),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                      _submitForm();
                    }
                 ,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageLogin(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16,color: Colors.green),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}