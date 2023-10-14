import 'package:flutter/material.dart';
import 'package:restaraunt_app/AdminPanel.dart';
import 'package:restaraunt_app/home.dart';
import 'package:restaraunt_app/register.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class LoginApp extends StatelessWidget {
  static const String id = "login_screen";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email == "ravi1974@gmail.com" && password == "Ravi24**") {
      // Admin login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPanel()),
      );
    } else {
      try {
        final newUser = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (newUser.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please check your credentials.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login19.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Food Truck',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            controller: _emailController,
                            validator: emailValidator,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email, color: Colors.black),
                              labelStyle: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                color:Colors.black,
                              ),
                              hintStyle: TextStyle(color: Colors.black),
                              focusedBorder:OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                               enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10), 
                            ),
                          ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: passwordValidator,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
                               labelStyle: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                 color:Colors.black,
                              ),
                              hintStyle: TextStyle(color: Colors.black),
                              focusedBorder:OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                               enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10), 
      
                            ),
                           
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 0, 3, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, fontFamily: 'Quicksand'),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterApp(),
                            ),
                          );
                        },
                        child: const Text(
                          'Create New Account',
                          style: TextStyle(
                            color: Color.fromARGB(255, 18, 47, 209),
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

