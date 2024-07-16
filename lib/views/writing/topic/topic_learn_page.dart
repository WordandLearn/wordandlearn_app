import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/topic/components/flash_card_container.dart';
import 'package:word_and_learn/views/writing/topic/topic_example_page.dart';

class TopicLearnPage extends StatefulWidget {
  final Topic topic;
  const TopicLearnPage({super.key, required this.topic});

  @override
  State<TopicLearnPage> createState() => _TopicLearnPageState();
}

class _TopicLearnPageState extends State<TopicLearnPage> {
  final WritingController _writingController = Get.find<WritingController>();
  bool completed = false;

  @override
  void initState() {
    super.initState();
  }

  int activeFlashcard = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.secondaryContainer,
        body: SafeArea(
          child: FutureBuilder<HttpResponse<FlashcardText>>(
              future: _writingController.getTopicFlashcards(widget.topic.id),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    buildAppbar(context, snapshot),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        decoration: const BoxDecoration(
                            color: AppColors.secondaryContainer),
                        child:
                            snapshot.hasData && snapshot.data!.models.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: defaultPadding * 2,
                                        horizontal: defaultPadding * 0.5),
                                    child: FlashCardContainer(
                                      flashcards: snapshot.data!.models,
                                      onChanged: (index) {
                                        setState(() {
                                          activeFlashcard = index + 1;
                                        });
                                      },
                                    ),
                                  )
                                : const Center(child: LoadingSpinner()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding, horizontal: defaultPadding),
                      child: snapshot.hasData
                          ? SizedBox(
                              height: 50,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: activeFlashcard ==
                                        snapshot.data!.models.length
                                    ? PrimaryButton(
                                        onPressed: () {
                                          if (activeFlashcard ==
                                              snapshot.data!.data.length) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TopicExamplePage(
                                                          topic: widget.topic),
                                                ));
                                          } else {
                                            setState(() {
                                              activeFlashcard++;
                                            });
                                          }
                                        },
                                        child: const Text(
                                          "View Example",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : null,
                              ),
                            )
                          : const SizedBox.shrink(),
                    )
                  ],
                );
              }),
        ));
  }

  Widget buildAppbar(BuildContext context,
      AsyncSnapshot<HttpResponse<FlashcardText>> snapshot) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Text(
                  widget.topic.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: snapshot.hasData
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding / 2),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(30, 158, 158, 158),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "$activeFlashcard/${snapshot.data!.data.length}",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        )
                      : const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultPadding),
                          child: LoadingSpinner(
                            size: 10,
                          ),
                        ),
                )
              ],
            ),

            //Indicators
            snapshot.hasData && snapshot.data!.models.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: defaultPadding * 0.5),
                    child: Row(
                      children: List.generate(
                          snapshot.data!.models.length,
                          (index) => Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  height: 4,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: index + 1 == activeFlashcard
                                          ? AppColors.secondaryColor
                                          : Colors.transparent),
                                ),
                              )),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
