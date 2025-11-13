import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../widgets/glass_card.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '', _password = '';
  bool _obscure = true;

  void _tryLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_username == 'admin' && _password == 'admin') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials. Use admin/admin')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 520),
              child: GlassCard(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                radius: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.school_rounded, size: 36, color: Colors.white),
                    ),
                    SizedBox(height: 14),
                    Text('Student Result Portal', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Login to continue', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 18),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.02),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Enter username' : null,
                            onSaved: (v) => _username = v!.trim(),
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.02),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
                            onSaved: (v) => _password = v!,
                          ),
                          SizedBox(height: 18),
                          Row(children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _tryLogin,
                                child: Text('Login', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('Use username: admin, password: admin (demo)', style: TextStyle(color: Colors.white60)),
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
