import 'package:flutter/material.dart';
import 'package:Sharpshell/utils/app_drawer.dart';

class SeventhScreen extends StatefulWidget {
  static String routeName = '/seventh_screen';
  const SeventhScreen({super.key});

  @override
  State<SeventhScreen> createState() => _SeventhScreenState();
}

class _SeventhScreenState extends State<SeventhScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(title: Text('Form Implementation using Global Key')),
        drawer: AppDrawer(), // Add the persistent drawer
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login Form ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    onChanged: (value) {
                      // Enable auto-validation after user starts typing
                      if (_autovalidateMode == AutovalidateMode.disabled) {
                        setState(() {
                          _autovalidateMode =
                              AutovalidateMode.onUserInteraction;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      hintText: 'Enter your username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true, // Added for password security
                    onChanged: (value) {
                      // Enable auto-validation after user starts typing
                      if (_autovalidateMode == AutovalidateMode.disabled) {
                        setState(() {
                          _autovalidateMode =
                              AutovalidateMode.onUserInteraction;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      hintText: 'Enter your password',
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Enable validation mode for immediate feedback
                      setState(() {
                        _autovalidateMode = AutovalidateMode.always;
                      });

                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with login
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Login successful! Username: ${_usernameController.text}',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Clear the form after successful validation
                        _usernameController.clear();
                        _passwordController.clear();
                        // Reset validation mode
                        setState(() {
                          _autovalidateMode = AutovalidateMode.disabled;
                        });
                        // Dismiss keyboard
                      } else {
                        // Form is invalid, show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fix the errors above'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      FocusScope.of(context).unfocus();
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
