import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';

class SessionReportPage extends StatelessWidget {
  const SessionReportPage({super.key, required this.session});
  final Session session;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        )
                      ]),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.chevron_left,
                      size: 30,
                    ),
                  ),
                ),
                // Text(
                //   "Session Report",
                //   style: Theme.of(context).textTheme.titleLarge,
                // )
              ],
            ),
          ),
          Expanded(child: SfPdfViewer.network(session.reportUrl!))
        ],
      ),
    ));
  }
}
