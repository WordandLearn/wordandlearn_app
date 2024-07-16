import 'package:flutter/material.dart';
import 'package:word_and_learn/models/models.dart';

class SessionReportPage extends StatelessWidget {
  const SessionReportPage({super.key, required this.session});
  final Session session;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Session Report Page"),
      ),
    );
  }
}
