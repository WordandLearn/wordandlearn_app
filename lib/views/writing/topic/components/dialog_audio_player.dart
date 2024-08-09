import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';

class DialogAudioWidget extends StatefulWidget {
  const DialogAudioWidget({
    super.key,
    required this.onCompleted,
    required this.future,
    required this.color,
  });

  final void Function() onCompleted;
  final Future<File?> future;
  final ColorModel color;
  @override
  State<DialogAudioWidget> createState() => DialogAudioWidgetState();
}

class DialogAudioWidgetState extends State<DialogAudioWidget> {
  // final WritingController writingController = Get.find<WritingController>();
  @override
  void initState() {
    // audioFuture = writingController.getFlashcardAudio(widget.flashcardText.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
        future: widget.future,
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
                  ? DialogAudioPlayer(
                      audioFile: snapshot.data!,
                      onCompleted: widget.onCompleted,
                      lineColor: widget.color.darkerColor,
                      waveColor: widget.color.colorValue,
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

class DialogAudioPlayer extends StatefulWidget {
  const DialogAudioPlayer({
    super.key,
    required this.audioFile,
    required this.onCompleted,
    required this.lineColor,
    required this.waveColor,
  });

  final File audioFile;
  final void Function() onCompleted;
  final Color lineColor;
  final Color waveColor;

  @override
  State<DialogAudioPlayer> createState() => _DialogAudioPlayerState();
}

class _DialogAudioPlayerState extends State<DialogAudioPlayer> {
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
                liveWaveColor: widget.lineColor,
                fixedWaveColor: widget.waveColor),
          ),
        )
      ],
    );
  }
}
