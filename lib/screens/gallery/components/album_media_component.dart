import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/post/screens/audio_post_screen.dart';
import 'package:socialv/screens/post/screens/image_screen.dart';
import 'package:socialv/screens/post/screens/pdf_screen.dart';
import 'package:socialv/screens/post/screens/video_post_screen.dart';

import '../../../utils/cached_network_image.dart';
import '../../../utils/constants.dart';
import '../../../utils/images.dart';

class AlbumMediaComponent extends StatefulWidget {
  final String mediaUrl;
  final String? mediaType;
  final String thumbnail;
  final bool? canDelete;
  final int? mediaId;
  final Function(int)? onDelete;

  AlbumMediaComponent(
      {required this.mediaUrl,
      this.onDelete,
      this.canDelete = false,
      this.mediaId,
      required this.thumbnail,
      this.mediaType});

  @override
  State<AlbumMediaComponent> createState() => _AlbumMediaComponentState();
}

class _AlbumMediaComponentState extends State<AlbumMediaComponent> {
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
    return GestureDetector(
      onTap: () {
        if (widget.mediaType == MediaTypes.image) {
          ImageScreen(imageURl: widget.mediaUrl.validate()).launch(context);
        } else if (widget.mediaType == MediaTypes.audio) {
          AudioPostScreen(widget.mediaUrl.validate()).launch(context);
        } else if (widget.mediaType == MediaTypes.video) {
          VideoPostScreen(widget.mediaUrl.validate()).launch(context);
        } else if (widget.mediaType == MediaTypes.doc) {
          PDFScreen(docURl: widget.mediaUrl.validate()).launch(context);
        } else {
          //
        }
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(commonRadius),
            ),
            height: context.height(),
            width: context.width(),
            child: widget.mediaType != MediaTypes.video
                ? cachedImage(
                    height: context.height(),
                    width: context.width(),
                    widget.mediaType == MediaTypes.image
                        ? widget.mediaUrl.validate()
                        : widget.thumbnail.validate(),
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(commonRadius)
                : _controller!.value.isInitialized
                    ? VideoPlayer(_controller!)
                        .cornerRadiusWithClipRRect(commonRadius)
                    : cachedImage(
                        height: context.height(),
                        width: context.width(),
                        widget.thumbnail.validate(),
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(commonRadius),
          ),
          if (widget.canDelete.validate())
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(commonRadius),
              ),
              child: IconButton(
                onPressed: () {
                  showConfirmDialogCustom(
                    context,
                    title: 'Bạn có chắc chắn muốn xóa hình ảnh này không?',
                    onAccept: (s) {
                      widget.onDelete!.call(widget.mediaId!);
                    },
                    dialogType: DialogType.DELETE,
                  );
                },
                icon: Image.asset(ic_delete,
                    color: Colors.black, height: 20, width: 20),
              ),
            )
        ],
      ),
    );
  }
}
