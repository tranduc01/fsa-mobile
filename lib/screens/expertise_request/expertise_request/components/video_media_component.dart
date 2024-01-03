import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class VideoMediaComponent extends StatefulWidget {
  final String mediaUrl;

  VideoMediaComponent({
    required this.mediaUrl,
  });

  @override
  State<VideoMediaComponent> createState() => _VideoMediaComponentState();
}

class _VideoMediaComponentState extends State<VideoMediaComponent> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl.validate()))
          ..initialize().then((_) {
            setState(() {}); //when your thumbnail will show.
          });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : Container());
  }
}
