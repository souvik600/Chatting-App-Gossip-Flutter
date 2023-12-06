import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/chat_user.dart';
import '../../screens/view_profile_screen.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
          width: mq.width * .2,
          height: mq.height * .4,
          child: Stack(
            children: [
              //user profile picture
              Center(
                child: Positioned(
                  top: mq.height * .075,
                  left: mq.width * .1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .005),
                    child: CachedNetworkImage(
                      width: mq.width * .5,
                      fit: BoxFit.cover,
                      imageUrl: user.image,
                      errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
