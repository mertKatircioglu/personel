import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'auth_screen.dart';

//Uygulama başlatıldığında main page olarak ilk bu sayfaya yönlendirme yapılıyor,
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

//Bu method firebase veritabanını incelyerek kullanıcı kaydının ve girişinin olup olmadığını sorguluyor
  startTimer(BuildContext context) async{
    final User? authUser =FirebaseAuth.instance.currentUser;
    Timer(const Duration(seconds: 2), () async {
      if(authUser !=null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomePage()));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const AuthScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startTimer(context);
    return const Scaffold(
      body: Center(
        child: Text('Hoş geldiniz. Yönlendiriliyorsunuz...'),
      ),
    );
  }
}
