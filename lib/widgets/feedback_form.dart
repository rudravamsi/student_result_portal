// lib/widgets/feedback_form.dart
import 'package:flutter/material.dart';
import '../utils/responsive.dart';

typedef FeedbackSubmit = void Function(String name, String email, String message);

class FeedbackForm extends StatefulWidget {
  final FeedbackSubmit onSubmit;
  const FeedbackForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  String name='', email='', message='';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white70), filled: true, fillColor: Colors.white10),
            validator: (v)=> (v==null || v.trim().isEmpty) ? 'Enter name' : null,
            onSaved: (v)=> name = v!.trim(),
          ),
          SizedBox(height:8),
          TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white70), filled: true, fillColor: Colors.white10),
            validator: (v)=> (v==null || !v.contains('@')) ? 'Enter a valid email' : null,
            onSaved: (v)=> email = v!.trim(),
          ),
          SizedBox(height:8),
          TextFormField(
            maxLines: 5,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Message', labelStyle: TextStyle(color: Colors.white70), filled: true, fillColor: Colors.white10),
            validator: (v)=> (v==null || v.trim().length<5) ? 'Enter message (min 5 chars)' : null,
            onSaved: (v)=> message = v!.trim(),
          ),
          SizedBox(height:12),
          Row(
            children: [
              Expanded(child: ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    widget.onSubmit(name,email,message);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Feedback submitted')));
                    _formKey.currentState!.reset();
                  }
                },
                child: Text('Send'),
              )),
            ],
          )
        ],
      ),
    );
  }
}
