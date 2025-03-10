import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/lessons/lessons_page.dart';

class CompositionWaitingPage extends StatefulWidget {
  const CompositionWaitingPage({super.key, required this.taskId});
  final String taskId;

  @override
  State<CompositionWaitingPage> createState() => _CompositionWaitingPageState();
}

class _CompositionWaitingPageState extends State<CompositionWaitingPage> {
  final WritingController _writingController = WritingController();

  TaskProgress progress = TaskProgress(state: TaskState.pending);
  void _getTaskState() async {
    HttpResponse<TaskProgress> response =
        await _writingController.getTaskState(widget.taskId);
    if (response.isSuccess) {
      if (context.mounted) {
        setState(() {
          progress = response.models.first;
        });
      }
    }
  }

  late Timer timer;

  @override
  void initState() {
    //call _getTaskState after every 2 seconds
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _getTaskState();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 350,
        padding: const EdgeInsetsDirectional.all(defaultPadding * 2),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                key: ValueKey<TaskState>(progress.state),
                children: [
                  Builder(builder: (context) {
                    if (progress.state == TaskState.progress) {
                      return const _ProgressWidget(
                        isLoading: true,
                        progress: 0.1,
                      );
                    } else if (progress.state == TaskState.success) {
                      return const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80,
                      );
                    } else if (progress.state == TaskState.failure) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 80,
                      );
                    }
                    return const Column(
                      children: [
                        LoadingSpinner(),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text(
                          "Getting The Status Of Your Composition",
                          style: TextStyle(
                              fontSize: 12, color: AppColors.greyTextColor),
                        )
                      ],
                    );
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Builder(builder: (context) {
                      if (progress.state == TaskState.progress) {
                        return Text(
                          progress.message!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        );
                      } else if (progress.state == TaskState.success) {
                        return const Column(
                          children: [
                            Text(
                              "Upload Successful",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
                            ),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            Text(
                              "Switch to this composition to take its fun lessons",
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.greyTextColor),
                            )
                          ],
                        );
                      } else if (progress.state == TaskState.failure) {
                        return const Text(
                          "Upload Failed",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),
                ],
              ),
            ),
            const Spacer(),
            progress.state == TaskState.success
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: TapBounce(
                      onTap: () async {
                        // await _writingController.refetch();
                        if (context.mounted) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const LessonsPage();
                          }));
                        }
                      },
                      child: PrimaryButton(
                        color: Colors.grey.withOpacity(0.2),
                        child: const Text(
                          "Go To Home",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class _ProgressWidget extends StatefulWidget {
  const _ProgressWidget({this.isLoading = false, required this.progress});

  final bool isLoading;
  final double progress;

  @override
  State<_ProgressWidget> createState() => __ProgressWidgetState();
}

class __ProgressWidgetState extends State<_ProgressWidget> {
  bool animate = false;

  late double progress;
  @override
  void initState() {
    progress = widget.progress;
    if (widget.isLoading) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          animate = !animate;
          if (progress < 0.6) {
            progress += 0.01;
          }
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedScale(
          scale: animate ? 1 : 1.1,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
                color: Color(0xFFFFFAF2), shape: BoxShape.circle),
            child: Center(
              child: AnimatedScale(
                scale: animate ? 1 : 0.9,
                duration: const Duration(milliseconds: 500),
                child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFFEFD8), shape: BoxShape.circle),
                    child: Center(
                      child: AnimatedScale(
                        scale: animate ? 1 : 0.95,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFFE3BB), shape: BoxShape.circle),
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ),
        CircularPercentIndicator(
          radius: 50,
          percent: progress,
          curve: Curves.easeOut,
          lineWidth: 4,
          progressColor: AppColors.buttonColor,
          backgroundColor: Colors.transparent,
        )
      ],
    );
  }
}
