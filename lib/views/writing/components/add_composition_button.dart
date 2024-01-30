import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

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
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(defaultPadding * 1.5),
                child: Icon(
                  Icons.document_scanner,
                  size: 30,
                  color: Colors.black,
                ),
              ))
        ],
      ),
    );
  }
}
