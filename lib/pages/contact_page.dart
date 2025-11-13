// lib/pages/contact_page.dart
import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../widgets/glass_card.dart';
import '../widgets/feedback_form.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  void _handleSubmit(BuildContext context, String name, String email, String message) {
    // TODO: Replace this with a real send-to-server or email integration if needed.
    // For now we log to console and show a confirmation snackbar.
    debugPrint('Feedback submitted by $name <$email>: $message');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thanks, $name — your message has been sent.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).size.height * 0.02;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Contact / Feedback')),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12, topPadding, 12, 12),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 820),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    padding: EdgeInsets.all(18),
                    radius: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Teacher or Send Feedback',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Use the form below to send remarks, questions, or corrections about student results.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 12),
                        FeedbackForm(
                          onSubmit: (name, email, message) {
                            _handleSubmit(context, name, email, message);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14),

                  // Optional contact info card
                  GlassCard(
                    padding: EdgeInsets.all(14),
                    radius: 14,
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.white70),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'If you prefer direct contact, email the teacher at teacher@example.edu or call the school office.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Pretend emailing teacher@example.edu (demo)')),
                            );
                          },
                          child: Text('Contact', style: TextStyle(color: Colors.tealAccent)),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Small note / instructions
                  Text(
                    'Tip: Provide student name, roll number and clear message for faster help.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
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
