import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool isLogin = true;

  String email = '';
  String password = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Form(
                key: _formKey,

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      isLogin
                          ? "Welcome Back"
                          : "Create Account",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      isLogin
                          ? "Login to continue"
                          : "Register a new account",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 30),

                    if (!isLogin)
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return "Enter a valid username";
                          }
                          return null;
                        },
                        onSaved: (value) => username = value!,
                      ),

                    if (!isLogin)
                      const SizedBox(height: 15),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains("@")) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      onSaved: (value) => email = value!,
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      onSaved: (value) => password = value!,
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            try {
                              if (isLogin) {
                                await _authService.signIn(
                                  email,
                                  password,
                                );
                              } else {
                                await _authService.signUp(
                                  email,
                                  password,
                                );
                              }

                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          }
                        },

                        child: Text(
                          isLogin
                              ? "Login"
                              : "Create Account",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? "Don't have an account? Register"
                            : "Already have an account? Login",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}