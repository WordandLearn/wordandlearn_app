import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:word_and_learn/constants/constants.dart';

class TeacherBottomNavigationBar extends StatefulWidget {
  const TeacherBottomNavigationBar({super.key, required this.onIndexChanged});
  final void Function(int index) onIndexChanged;

  @override
  State<TeacherBottomNavigationBar> createState() =>
      _TeacherBottomNavigationBarState();
}

class _TeacherBottomNavigationBarState
    extends State<TeacherBottomNavigationBar> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: defaultPadding / 2, horizontal: size.width * 0.02),
      height: kBottomNavigationBarHeight,
      decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 7,
                spreadRadius: 2)
          ],
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TeacherBottomNavigationItem(
            assetUrl: "assets/icons/class.svg",
            text: "Classes",
            isActive: activeIndex == 0,
            onPressed: () {
              setState(() {
                activeIndex = 0;
              });
              widget.onIndexChanged(0);
            },
          ),
          TeacherBottomNavigationItem(
            assetUrl: "assets/icons/document.svg",
            text: "Upload",
            isActive: activeIndex == 1,
            onPressed: () {
              setState(() {
                activeIndex = 1;
              });
              widget.onIndexChanged(1);
            },
          ),
          TeacherBottomNavigationItem(
            assetUrl: "assets/icons/result.svg",
            text: "Reports",
            isActive: activeIndex == 2,
            onPressed: () {
              setState(() {
                activeIndex = 2;
              });
              widget.onIndexChanged(2);
            },
          ),
        ],
      ),
    );
  }
}

class TeacherBottomNavigationItem extends StatelessWidget {
  const TeacherBottomNavigationItem(
      {super.key,
      required this.assetUrl,
      required this.text,
      this.onPressed,
      this.isActive = false});
  final String assetUrl;
  final String text;
  final bool isActive;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(
            horizontal: isActive ? size.width * 0.03 : size.width * 0.02,
            vertical: defaultPadding),
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetUrl,
              width: 20,
              theme: SvgTheme(
                  currentColor:
                      isActive ? Theme.of(context).primaryColor : Colors.white),
              // color: ,
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      isActive ? Theme.of(context).primaryColor : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
