import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personel/splash.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Uygulamamız bu kısımda başlatılarak kullanıcıyı ilk hangi sayfaya yönlendireceğimizi belirliyoruz.
  //Ben splash.dart adında bir dart dosyası yaratarak kullanıcıyı ilk buraya yönlendirdim.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Güler Doğan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

