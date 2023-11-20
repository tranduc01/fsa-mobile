import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SinglePostScreen extends StatefulWidget {
  final int postId;

  const SinglePostScreen({required this.postId});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    "https://hoatuoithanhthao.com/media/ftp/hoa-lan-5.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(129, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your first text here",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Your second text here Your second text here Your second text here Your second text here Your second text hereYour second text hereYour second text here Your second text here",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 6,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your third text here",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      8.height,
                      Text(
                        "Your third text here",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(137, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.network(
                    'https://scontent.fsgn2-7.fna.fbcdn.net/v/t39.30808-6/353017930_6153557468098795_166607921767111563_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_ohc=G2C7rGssBqwAX9JKqCa&_nc_ht=scontent.fsgn2-7.fna&oh=00_AfBunkTQu6x0cn1h3G4bOD9EW0tQGDyUlL3p0-5nZjnRVg&oe=6560CD6C',
                    height: 50,
                    width: 50,
                  ).cornerRadiusWithClipRRect(25)
                ],
              ),
            ),
            Divider(
              thickness: 1,
            )
          ],
        ),
      ],
    ));
  }
}
