import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/gallery_controller.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../main.dart';
import '../../../models/gallery/albums.dart';

class GalleryScreenAlbumComponent extends StatefulWidget {
  final Album album;
  final Function(int)? callback;
  final bool canDelete;

  const GalleryScreenAlbumComponent(
      {Key? key, required this.album, this.callback, this.canDelete = false})
      : super(key: key);

  @override
  State<GalleryScreenAlbumComponent> createState() =>
      _GalleryScreenAlbumComponentState();
}

class _GalleryScreenAlbumComponentState
    extends State<GalleryScreenAlbumComponent> {
  late GalleryController galleryController = Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(commonRadius),
          ),
          child: widget.album.media.isNotEmpty
              ? cachedImage(widget.album.media.first.url,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover)
              : Image.asset('assets/images/images.png',
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill)
                  .cornerRadiusWithClipRRect(commonRadius),
        ),
        if (widget.canDelete.validate())
          Align(
              alignment: Alignment.topRight,
              child: Container(
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
                      title: language.albumDeleteConfirmation,
                      onAccept: (s) {
                        widget.callback!.call(widget.album.id!);
                      },
                      dialogType: DialogType.DELETE,
                    );
                  },
                  icon: Image.asset(ic_delete,
                      color: Colors.black, height: 20, width: 20),
                ),
              )),
        Positioned(
          bottom: 8,
          left: 8,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(commonRadius),
                  ),
                  child: Text(
                    widget.album.title.validate(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                2.height,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
