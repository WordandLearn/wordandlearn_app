import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/views/writing/lessons/session_qr_page.dart';

class AddCompositionButton extends StatelessWidget {
  const AddCompositionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Add a new composition",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Icon(Icons.arrow_right_alt),
          ),
          RoundIconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SessionQRPage(),
                  ));
            },
            icon: const Icon(
              Icons.document_scanner,
              size: 30,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
