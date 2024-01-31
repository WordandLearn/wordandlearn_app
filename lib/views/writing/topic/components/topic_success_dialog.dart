import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';

Widget buildtopicSuccessDialog(BuildContext context, Topic topic) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      height: 300,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Congratulations!",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w500, fontSize: 26),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding * 4, horizontal: defaultPadding),
            child: Text(
              "You have successfully completed the topic ${topic.name}. You can try the exercises now.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w600, height: 1.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.popUntil(context, (route) {
                      return route.settings.name == "/writing";
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_left),
                      Text(
                        "To Topics",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 100,
                    height: 30,
                    child: CustomPrimaryButton(
                        text: "Do Exercise", onPressed: () {}))
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
