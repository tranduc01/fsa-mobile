import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../utils/images.dart';

class VideoPostComponent extends StatefulWidget {
  final String videoURl;
  final bool isShowControllers;
  final VoidCallback? callBack;

  VideoPostComponent(
      {required this.videoURl, this.isShowControllers = true, this.callBack});

  @override
  State<VideoPostComponent> createState() => _VideoPostComponentState();
}

class _VideoPostComponentState extends State<VideoPostComponent> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  GlobalKey visibilityKey = GlobalKey();
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoURl))
          ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        enterFullscreenButton: Image.asset(ic_full_screen,
                color: Colors.white, width: 16, height: 16)
            .paddingAll(4),
        exitFullscreenButton: Image.asset(ic_exit_full_screen,
                color: Colors.white, width: 16, height: 16)
            .paddingAll(4),
        playButton: Image.asset(ic_play_button,
                color: Colors.white, width: 16, height: 16)
            .paddingAll(4),
        pauseButton:
            Image.asset(ic_pause, color: Colors.white, width: 16, height: 16)
                .paddingAll(4),
        playbackSpeedButtonAvailable: false,
        settingsButtonAvailable: false,
      ),
    );
    widget.callBack?.call();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    videoPlayerController.pause();
    _customVideoPlayerController.videoPlayerController.pause();
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height() * 0.8,
      child: VisibilityDetector(
          key: visibilityKey,
          onVisibilityChanged: (info) {
            _customVideoPlayerController.videoPlayerController.pause();
          },
          child: CustomVideoPlayer(
              customVideoPlayerController: _customVideoPlayerController)),
    ).center();
  }
}

class StoryVideoPostComponent extends StatefulWidget {
  final String videoURl;
  final bool isShowControllers;
  final VoidCallback? callBack;

  StoryVideoPostComponent(
      {required this.videoURl, this.isShowControllers = true, this.callBack});

  @override
  State<StoryVideoPostComponent> createState() =>
      _StoryVideoPostComponentState();
}

class _StoryVideoPostComponentState extends State<StoryVideoPostComponent> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoURl),
      videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, allowBackgroundPlayback: true),
    );

    videoPlayerController.addListener(() {
      setState(() {});
    });
    videoPlayerController.setLooping(true);
    videoPlayerController.initialize();
    videoPlayerController.play();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height() * 0.8,
      child: AspectRatio(
        aspectRatio: videoPlayerController.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(videoPlayerController),
            VideoProgressIndicator(videoPlayerController, allowScrubbing: true),
          ],
        ),
      ),
    ).center();
  }
}
