import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:u_chat_me/Screens/auth/login_screen.dart';
import 'package:u_chat_me/helper/dialogs.dart';
import 'package:u_chat_me/models/chat_user.dart';

import '../api/apis.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fromKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
          ),
          body: Form(
            key: _fromKey,
            child: Padding(
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
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ?

                        //local image
                        ClipRRect(
                            borderRadius:
                            BorderRadius.circular(mq.height * .1),
                            child: Image.file(File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover))
                            :

                        //image from server
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(mq.height * .1),
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

                        //edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                    //for adding space
                    SizedBox(
                      height: mq.height * .03,
                    ),

                    Text(
                      widget.user.email,
                      style: const TextStyle(fontSize: 18),
                    ),
                    //Name Button
                    //for adding space
                    SizedBox(
                      height: mq.height * .03,
                    ),
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) =>
                      val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'Name',
                        label: const Text('Name'),
                      ),
                    ),
                    //for adding space
                    //About button
                    SizedBox(
                      height: mq.height * .02,
                    ),

                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) =>
                      val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eq. Fleeing Happy',
                        label: const Text('About'),
                      ),
                    ),
                    //update button
                    SizedBox(
                      height: mq.height * .05,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_fromKey.currentState!.validate()) {
                          _fromKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Profile Update Successfully');
                          });

                          log('Inside Validator');
                        }
                      },
                      icon: const Icon(Icons.update),
                      label: const Text('UPDATE'),
                    ),
                    // log out
                    SizedBox(
                      height: mq.height * .03,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      onPressed: () async {
                        Dialogs.showProgressBar(context);
                        await APIs.updateActiveStatus(false);

                        //sign out From app
                        await APIs.auth.signOut().then((value) async =>
                        {
                          await GoogleSignIn().signOut().then((value) =>
                          {
                            //for hiding progress dialog
                            Navigator.pop(context),
                            //for moving homeScreen with Login Screen
                            Navigator.pop(context),
                            APIs.auth = FirebaseAuth.instance,
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()))
                          })
                        });
                      },
                      icon: const Icon(Icons.logout,),
                      label: const Text('LogOut',
                        style: TextStyle(color: Colors.white, fontSize:17,fontWeight: FontWeight.w500),),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

//  button sheet for piking profile picture
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              const Text(
                'Select Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: mq.height * .04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //take picture from gallery
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // // for hiding bottom sheet
                          // Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/gallery.png')),
                  //take picture from camara
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camara.png')),
                ],
              )
            ],
          );
        });
  }
}
