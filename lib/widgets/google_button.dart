import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop/consts/firebase_consts.dart';
import 'package:shop/fetch_screen.dart';
import 'package:shop/inner_screens/feeds_screen.dart';
import 'package:shop/screens/btm_bar.dart';
import 'package:shop/services/global_methods.dart';
import 'package:shop/widgets/text_widget.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<UserCredential> _googleSignIn(context) async {
    GoogleSignIn.instance.initialize(
      serverClientId:
          '382852329743-lfs9j2vufu5o61aocgoo2vo3otpji4pt.apps.googleusercontent.com',
    );
    // Trigger the authentication flow
    final GoogleSignInAccount? googleAccount = await GoogleSignIn.instance
        .authenticate();

    // if (googleAccount == null) {
    //   throw FirebaseAuthException(
    //     code: 'ERROR_ABORTED_BY_USER',
    //     message: 'Sign in aborted by user',
    //   );
    // }
    if (googleAccount != null) {
      final googleAuth = googleAccount.authentication;
      if (googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(idToken: googleAuth.idToken),
          );
          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
                  'id': authResult.user!.uid,
                  'name': authResult.user!.displayName,
                  'email': authResult.user!.email,
                  'shipping-address': '',
                  'userWish': [],
                  'userCart': [],
                  'createdAt': Timestamp.now(),
                });
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
        } on FirebaseAuthException catch (error) {
          GlobalMethods.errorDialog(
            subtitle: '${error.message}',
            context: context,
          );
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {}
      }
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleAccount!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/google.png',
                width: 40.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            TextWidget(
              text: 'Sign in with google',
              color: Colors.white,
              textSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
