import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dine_easy/client/client_signin/loginpg.dart';
import 'package:dine_easy/restaurant/signin/loginpg.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class client_signup extends StatefulWidget {
  const client_signup({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return signupstate();
  }
}

// ignore: camel_case_types
class signupstate extends State<client_signup> {
  //function
  login(BuildContext context) async {
    final String name = username.text;
    final String email = useremail.text.trim();
    if (kDebugMode) {
      print("Email before sending: $email");
    }
    final String password=userpassword.text;
    if (_formKey.currentState!.validate()) {
      final Map<String, String> data = {
        "name":name,
        "email":email, // Replace with your email
        "password":password // Replace with your password
      };

      final response = await http.post(
        Uri.parse("https://sparkling-sarong-bass.cyclic.app/customer/signup"), // Replace with your signin endpoint URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final token = jsonResponse['token'];
        if (kDebugMode) {
          print(token);
        }
        // Use the token or store it for future requests
        Fluttertoast.showToast(
          msg: "Signed up successfully!Please verify your email",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const MyHomePage()
            ));
      } else {
        Fluttertoast.showToast(
          msg: "Invalid email or password.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      return 'please fill all fields';
    }
  }


  final _formKey = GlobalKey<FormState>();
  final TextEditingController useremail=TextEditingController();
  final TextEditingController username=TextEditingController();
  final TextEditingController userpassword=TextEditingController();
  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed to prevent memory leaks
    useremail.dispose();
    userpassword.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Start color (#F5F5DC)
            Color(0xFF2b1b17),
            Color(0xFF0c0908),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topCenter,
          stops: [0.1, 0.5],
          tileMode: TileMode.clamp,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text("Customer signup"),
          backgroundColor: const Color(0xFF020403),),
        body: Stack(
          children: [
            Center(
              child: BlurryContainer(
                blur: 8,
                borderRadius: const BorderRadius.all(Radius.circular(60)),
                child: Container(
                  height: height * 0.45,
                  width: width * 0.80,
                  color: Colors.white.withOpacity(0.2),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          TextFormField(
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'please enter password';
                              }
                              return null;
                            },
                            controller: username,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person,color: Colors.white,),
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(color: Colors.white),
                              label: Text('name'),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          TextFormField(
                            controller: useremail,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email_outlined,color: Colors.white,),
                              labelText: 'email',
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'please enter email';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                          ),
                          TextFormField(
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'please enter password';
                              }
                              return null;
                            },
                            controller: userpassword,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.password,color: Colors.white,),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.white),
                              label: Text('Password'),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 60,
                              ),

                              ElevatedButton(
                                onPressed:()=> login(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black26,
                                  padding: const EdgeInsets.only(left: 7),
                                ),
                                child: const Text("Signup"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}