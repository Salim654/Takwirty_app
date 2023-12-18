import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_simple_page/Services/ApiClient.dart';
import 'package:flutter_simple_page/Utils/size_config.dart';
import 'package:flutter_simple_page/Views/TerrainListScreen.dart';
import 'package:flutter_simple_page/Views/register.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {

  bool remember = false;
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";


  _submitlog() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_email != "" && _password != "") {
        final response = await ApiClient.loginUser(_email, _password);
        if (response.statusCode == 201) {
          final jsonResponse = json.decode(response.body);
          final token = jsonResponse['token'];
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TerrainListScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid credentials"),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
        title: Text("Sign In"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Center(
              child: Image.asset(
                'assets/register.gif',  // Replace with the actual path to your image
                width: getProportionateScreenWidth(200),  // Adjust the width as needed
                height: getProportionateScreenHeight(200),  // Adjust the height as needed
              ),
            ),
              Text(
                "Sign In \nTo Takwira",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Sign in with your email and password",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                      onSaved: (value) {
                        if (value != null) {
                          _email = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
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
                      onSaved: (value) {
                        if (value != null) {
                          _password = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: remember,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              remember = value!;
                            });
                          },
                        ),
                        Text("Remember me"),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: getProportionateScreenHeight(56),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    _submitlog();
                  },
                  child: Text(
                    "Sign In",
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
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageRegister(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16,color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField formEmail(){
    return TextFormField(
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
    );
  }

  TextFormField formPassword(){
    return TextFormField(
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
    );
  }
}



