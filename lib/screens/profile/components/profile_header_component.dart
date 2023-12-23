import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/cached_network_image.dart';

class ProfileHeaderComponent extends StatelessWidget {
  final String? avatarUrl;

  ProfileHeaderComponent({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: avatarUrl.isEmptyOrNull
              ? context.height() * 0.22
              : context.height() * 0.25,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                'assets/images/cover.jpg',
                width: context.width(),
                height: context.height() * 0.2,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle),
                  child: cachedImage(avatarUrl,
                          height: 100, width: 100, fit: BoxFit.cover)
                      .cornerRadiusWithClipRRect(100),
                ),
              ).visible(!avatarUrl.isEmptyOrNull),
            ],
          ),
        ),
      ],
    );
  }
}
