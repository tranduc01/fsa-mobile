import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/table_view_widget.dart';
import 'package:socialv/screens/post/screens/image_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;
  final double fontSize;

  HtmlWidget({this.postContent, this.color, this.fontSize = 14.0});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: postContent.validate(),
      onLinkTap: (s, _, __) {
        log(s);
        if (s!.contains('?user_id=')) {
        } else {
          openWebPage(context, url: s);
        }
      },
      onAnchorTap: (s, _, __) {},
      /*onImageTap: (s, _, __, ___) {
        ImageScreen(imageURl: s.validate());
      },*/
      style: {
        "table": Style(
            backgroundColor: color ?? transparentColor,
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        "tr": Style(
            border: Border(
                bottom: BorderSide(color: Colors.black45.withOpacity(0.5))),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        "th": Style(
            padding: HtmlPaddings.zero,
            backgroundColor: Colors.black45.withOpacity(0.5),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT)),
        "td": Style(
            padding: HtmlPaddings.zero,
            alignment: Alignment.center,
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT)),
        'embed': Style(
            color: color ?? transparentColor,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'strong': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'a': Style(
          color: color ?? context.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: FontSize(fontSize),
          lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
          padding: HtmlPaddings.zero,
          textDecoration: TextDecoration.none,
        ),
        'div': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'figure': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            padding: HtmlPaddings.zero,
            margin: Margins.zero,
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT)),
        'h1': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'h2': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'h3': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'h4': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'h5': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'h6': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'p': Style(
          color: color ?? textPrimaryColorGlobal,
          fontSize: FontSize(16),
          textAlign: TextAlign.justify,
          lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
          padding: HtmlPaddings.zero,
        ),
        'ol': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'ul': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'strike': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'u': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'b': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'i': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'hr': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'header': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'code': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'data': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'body': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'big': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'blockquote': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
            padding: HtmlPaddings.zero),
        'audio': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(fontSize),
            padding: HtmlPaddings.zero),
        'img': Style(
            width: Width(context.width()),
            padding: HtmlPaddings.only(bottom: 8),
            fontSize: FontSize(fontSize)),
        'li': Style(
          color: color ?? textPrimaryColorGlobal,
          fontSize: FontSize(fontSize),
          listStyleType: ListStyleType.disc,
          listStylePosition: ListStylePosition.outside,
        ),
      },
      extensions: [
        //ImageExtension(),

        TagExtension(
          tagsToExtend: {'figure'},
          builder: (extensionContext) {
            if (extensionContext.innerHtml.contains('audio')) {
              //return AudioPostWidget(postString: extensionContext.innerHtml);
            } else if (extensionContext.innerHtml.contains('twitter')) {
              //String t = extensionContext.innerHtml.splitAfter('<div class="wp-block-embed__wrapper">').splitBefore('</div>');
              //return TweetWebView(tweetUrl: t);
            } else {
              return Offstage();
            }
            return Offstage();
          },
        ),

        TagExtension(
          tagsToExtend: {'img'},
          builder: (extensionContext) {
            String img = '';
            if (extensionContext.attributes.containsKey('src')) {
              img = extensionContext.attributes['src'].validate();
            } else if (extensionContext.attributes.containsKey('data-src')) {
              img = extensionContext.attributes['data-src'].validate();
            }
            if (img.isNotEmpty) {
              return CachedNetworkImage(
                imageUrl: img,
                width: context.width(),
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(commonRadius).onTap(() {
                ImageScreen(imageURl: img).launch(context);
              });
            } else {
              return Offstage();
            }
          },
        ),
        TagWrapExtension(
          tagsToWrap: {"table"},
          builder: (child) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.open_in_full_rounded),
                    onPressed: () async {
                      await TableViewWidget(child).launch(context);
                      setOrientationPortrait();
                    },
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: child,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
