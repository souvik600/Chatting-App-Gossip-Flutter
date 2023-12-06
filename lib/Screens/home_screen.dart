import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_chat_me/Screens/profile_screen.dart';
import 'package:u_chat_me/models/chat_user.dart';
import 'package:u_chat_me/widgets/chat_user_card.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for store all user
  List<ChatUser> _list = [];

  //for store search item
  final List<ChatUser> _searchList = [];

  //for store search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              leading: const Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Name,Email,...'),
                      autofocus: true,
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.6),
                      //When search text list then update search list
                      onChanged: (val) {
                        //        searching logic
                        _searchList.clear();
                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    )
                  : const Text("Gossip"),
              actions: [
                //search Button
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                // 3 dot button
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: APIs.me,
                                  )));
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    )),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 15),
              child: FloatingActionButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                // Add button

                child: const Icon(Icons.add_comment_rounded),
              ),
            ),
            body: StreamBuilder(
                stream: APIs.getMyUsersId(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                  //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      // return const Center(
                      //   child: CircularProgressIndicator(),
                      // );

                  //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                    return StreamBuilder(
                      stream: APIs.getAllUsers(snapshot.data?.docs
                              .map((e) =>e.id)
                              .toList() ??
                          []),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );

                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : _list.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(
                                        user: _isSearching
                                            ? _searchList[index]
                                            : _list[index]);
                                    //return Text('Name:${list[index]} ');
                                  });
                            } else {
                              return const Center(
                                child: Text(
                                  'No Connection Found!!',
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                        }
                      },
                    );
                  }
                })),
      ),
    );
  }

  //For adding new user dialog
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id : ',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User Does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
