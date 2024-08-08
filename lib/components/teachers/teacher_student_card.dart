import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';

class TeacherStudentCard extends StatelessWidget {
  const TeacherStudentCard({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/student.svg",
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Text(
              profile.name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Column(
            children: [
              Text(
                "Last Logged On:",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                "01/01/1970",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }
}
