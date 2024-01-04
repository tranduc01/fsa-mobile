import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/gallery/components/album_media_component.dart';

import '../../../models/gallery/albums.dart';

class SingleAlbumDiscoveryDetailScreen extends StatefulWidget {
  final Album album;

  const SingleAlbumDiscoveryDetailScreen({Key? key, required this.album})
      : super(key: key);

  @override
  State<SingleAlbumDiscoveryDetailScreen> createState() =>
      _SingleAlbumDiscoveryDetailScreenState();
}

class _SingleAlbumDiscoveryDetailScreenState
    extends State<SingleAlbumDiscoveryDetailScreen> {
  ScrollController scrollCont = ScrollController();
  bool isError = false;
  int mPage = 1;
  bool mIsLastPage = false;
  bool isUpdateState = false;

  @override
  void initState() {
    super.initState();

    scrollCont.addListener(() {
      if (scrollCont.position.pixels == scrollCont.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.album, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
            itemCount: 1,
            itemBuilder: (context, snap) {
              return SingleChildScrollView(
                controller: scrollCont,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "${language.title}: ",
                        style: boldTextStyle(),
                        children: [
                          TextSpan(
                              text: widget.album.title,
                              style: primaryTextStyle()),
                        ],
                      ),
                    ),
                    16.height,
                    RichText(
                      text: TextSpan(
                        text: "${language.description}: ",
                        style: boldTextStyle(),
                        children: [
                          TextSpan(
                              text: widget.album.description,
                              style: primaryTextStyle()),
                        ],
                      ),
                    ),
                    GridView.builder(
                      itemCount: widget.album.media.length,
                      padding: EdgeInsets.only(
                          bottom: mIsLastPage ? 16 : 60, top: 16),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisExtent: 160,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        Media media = widget.album.media[index];
                        return AlbumMediaComponent(
                          mediaId: media.id,
                          mediaType: media.type,
                          canDelete: false,
                          thumbnail: media.url.validate(),
                          mediaUrl: media.url.validate(),
                          onDelete: (mediaId) async {
                            var ids = <int>[];
                            ids.add(mediaId);
                          },
                        );
                      },
                    )
                  ],
                ).paddingAll(16),
              );
            },
          ),
        ],
      ),
    );
  }
}
