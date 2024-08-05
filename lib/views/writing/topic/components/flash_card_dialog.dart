import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';

class FlashCardDialog extends StatefulWidget {
  const FlashCardDialog({
    super.key,
    required this.size,
    required this.flashcardText,
    required this.onUnderstand,
  });

  final Size size;
  final FlashcardText flashcardText;
  final void Function() onUnderstand;

  @override
  State<FlashCardDialog> createState() => _FlashCardDialogState();
}

class _FlashCardDialogState extends State<FlashCardDialog> {
  double rotation = 0.001;
  bool listeningComplete = false;
  void _animateRotation() {
    if (mounted) {
      setState(() {
        rotation = 0;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            rotation = 0.002;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -60,
          right: 0,
          child: Image.asset(
            "assets/stickers/cat_analyst.png",
            width: 100,
          ),
        ),
        AnimatedRotation(
          turns: rotation,
          duration: const Duration(milliseconds: 1),
          child: Container(
            height: widget.size.height * 0.7,
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
            width: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.flashcardText.colorValue,
                boxShadow: [
                  BoxShadow(
                      color: widget.flashcardText.darkerColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 10))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: _FlashcardAudioWidget(
                    flashcardText: widget.flashcardText,
                    onCompleted: () {
                      setState(() {
                        listeningComplete = true;
                      });
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: AutoSizeText(
                    widget.flashcardText.text,
                    style: const TextStyle(fontSize: 22, height: 2),
                  ),
                )
              ],
            ),
          ),
        ),
        widget.flashcardText.completed
            ? const SizedBox.shrink()
            : Positioned(
                bottom: -30,
                left: 0,
                right: 0,
                child: Center(
                  child: _FlashCardButton(
                    flashcardText: widget.flashcardText,
                    completed: listeningComplete,
                    onTap: () {
                      _animateRotation();
                      widget.onUnderstand();
                    },
                  ),
                ),
              )
      ],
    );
  }
}

class _FlashcardAudioWidget extends StatefulWidget {
  const _FlashcardAudioWidget({
    super.key,
    required this.flashcardText,
    required this.onCompleted,
  });

  final FlashcardText flashcardText;
  final void Function() onCompleted;

  @override
  State<_FlashcardAudioWidget> createState() => _FlashcardAudioWidgetState();
}

class _FlashcardAudioWidgetState extends State<_FlashcardAudioWidget> {
  late Future<File?> audioFuture;
  final WritingController writingController = Get.find<WritingController>();
  @override
  void initState() {
    audioFuture = writingController.getFlashcardAudio(widget.flashcardText.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
        future: audioFuture,
        builder: (context, snapshot) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              // width: 200,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20)),
              child: snapshot.hasData
                  ? _FlashcardAudioPlayer(
                      audioFile: snapshot.data!,
                      onCompleted: widget.onCompleted,
                      flashcardText: widget.flashcardText,
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Audio Loading",
                            style: TextStyle(
                                fontSize: 12, color: AppColors.greyTextColor),
                          ),
                          SizedBox(
                            width: defaultPadding,
                          ),
                          LoadingSpinner(
                            size: 15,
                          ),
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}

class _FlashcardAudioPlayer extends StatefulWidget {
  const _FlashcardAudioPlayer({
    super.key,
    required this.audioFile,
    required this.flashcardText,
    required this.onCompleted,
  });

  final File audioFile;
  final FlashcardText flashcardText;
  final void Function() onCompleted;

  @override
  State<_FlashcardAudioPlayer> createState() => _FlashcardAudioPlayerState();
}

class _FlashcardAudioPlayerState extends State<_FlashcardAudioPlayer> {
  final PlayerController _playerController = PlayerController();
  PlayerState playerState = PlayerState.initialized;
  @override
  void initState() {
    prepareAudio();
    super.initState();
  }

  void prepareAudio() async {
    await _playerController.preparePlayer(
      path: widget.audioFile.path,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );

    _playerController.startPlayer(
        forceRefresh: true, finishMode: FinishMode.pause);

    _playerController.onPlayerStateChanged.listen((state) {
      setState(() {
        playerState = state;
      });
    });
    _playerController.onCompletion.listen((_) {
      widget.onCompleted();
    });
  }

  @override
  void dispose() {
    _playerController.stopPlayer();
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _playerController.startPlayer(
                forceRefresh: true, finishMode: FinishMode.pause);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: playerState == PlayerState.playing
                    ? AppColors.buttonColor
                    : Colors.white,
                shape: BoxShape.circle),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: Icon(
                playerState == PlayerState.playing
                    ? CupertinoIcons.volume_up
                    : CupertinoIcons.volume_down,
                color: playerState == PlayerState.playing
                    ? Colors.white
                    : AppColors.buttonColor,
                key: ValueKey<bool>(playerState == PlayerState.playing),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: AudioFileWaveforms(
            animationCurve: Curves.bounceInOut,
            continuousWaveform: false,
            enableSeekGesture: false,
            size: const Size(200 * 0.6, 10),
            playerController: _playerController,
            waveformType: WaveformType.long,
            playerWaveStyle: PlayerWaveStyle(
                liveWaveColor: widget.flashcardText.darkerColor,
                fixedWaveColor: widget.flashcardText.colorValue),
          ),
        )
      ],
    );
  }
}

class _FlashCardButton extends StatefulWidget {
  const _FlashCardButton({
    required this.flashcardText,
    required this.onTap,
    this.completed = false,
  });

  final FlashcardText flashcardText;
  final void Function() onTap;
  final bool completed;
  @override
  State<_FlashCardButton> createState() => _FlashCardButtonState();
}

class _FlashCardButtonState extends State<_FlashCardButton> {
  double scale = 1;

  void _animateBounce() {
    setState(() {
      scale = 1.02;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
        child: GestureDetector(
          onTap: () {
            _animateBounce();
            if (widget.completed) {
              Future.delayed(const Duration(milliseconds: 400), () {
                widget.onTap();
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceInOut,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: widget.completed
                    ? widget.flashcardText.darkerColor
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20)),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: !widget.completed
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.info),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          "Finish Listening To Continue",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Icon(
                            Icons.done_rounded,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding / 2,
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultPadding),
                          child: Text(
                            "I Understand",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
