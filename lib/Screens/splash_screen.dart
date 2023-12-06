import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_chat_me/Screens/auth/login_screen.dart';
import 'package:u_chat_me/Screens/home_screen.dart';

import '../../main.dart';
import '../api/apis.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));
      if(APIs.auth.currentUser != null){
        log('\nUser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }

      //setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Gossip",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.cyan, fontSize: 21)),
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              right: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('images/u_chat_me_icon.png')),
          Positioned(
            top: mq.height * .40,
            right: mq.width * .18,
            child: const Text(
              "WelCome to Gossip",
              style: TextStyle(
                fontSize: 25,
                color: Colors.cyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            bottom: mq.height * .05,
            left: mq.width * .20,
            width: mq.width * .9,
            height: mq.height * .06,
            child: const Text("This App Made by @Souvik Das🧡",
              style: TextStyle(fontSize: 16),),
          ),
        ],
      ),
    );
  }
}
