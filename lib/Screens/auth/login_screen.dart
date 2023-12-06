import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:u_chat_me/Screens/home_screen.dart';
import 'package:u_chat_me/helper/dialogs.dart';

import '../../api/apis.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }
  _handleGoogleBtnClick(){
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if(user != null){
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}' );
        if(( await APIs.userExists())){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const HomeScreen()));
        }else{
          await APIs.creatUser().then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }

      }
    });
  }
  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);

    }catch(e){
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Gossip",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.cyan, fontSize: 21)),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: const Duration(seconds: 1),
              child: Image.asset('images/u_chat_me_icon.png')),
          AnimatedPositioned(
            top: mq.height * .40,
            right: _isAnimate ? mq.width * .18 : -mq.width * .5,
            duration: const Duration(seconds: 1),
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
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: const StadiumBorder()),
                onPressed: () {
                  _handleGoogleBtnClick();
                },
                icon: Image.asset('images/google.png', height: mq.height * .04),
                label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 17),
                      children: [
                        TextSpan(text: "Sign In With "),
                        TextSpan(
                            text: "Google",
                            style: TextStyle(fontWeight: FontWeight.w600))
                      ]),
                )),
          ),
        ],
      ),
    );
  }
}


