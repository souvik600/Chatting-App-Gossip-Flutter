import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:u_chat_me/helper/my_date_util.dart';
import 'package:u_chat_me/models/chat_user.dart';
import 'package:u_chat_me/widgets/dialogs/profile_picture.dart';

import '../api/apis.dart';
import '../main.dart';

// View profile Screen
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.name),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On : ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              Text(
                MyDateUtil.getLastMessageTime(
                    context: context,
                    time: widget.user.createdAt,
                    showYear: true),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //for adding space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  //user profile picture
                  //user profile picture
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfilePicture(
                                user: widget.user,
                              ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .1),
                      child: CachedNetworkImage(
                        width: mq.height * .2,
                        height: mq.height * .2,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                  ),
                  //for adding space
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Name : ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                            fontSize: 18,
                            color: CupertinoColors.activeGreen,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mq.height * .01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Email : ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      Text(
                        widget.user.email,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mq.height * .01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About : ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      Text(
                        widget.user.about,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
